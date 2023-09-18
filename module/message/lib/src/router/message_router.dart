import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:message/src/util/DatabaseHelper.dart';
import 'package:message/src/video_call_page.dart';
import '../chat_page.dart';
import '../model/message_session.dart';
import '../session_list_page.dart';
import 'package:synchronized/synchronized.dart';

class MessageRouter implements IMessageRouter {
  @override
  Widget getSessionListPage(int pageIndex) {
    return SessionListPage(pageIndex: pageIndex);
  }

  @override
  void initSessions() async {
    await MessageSession.sessions;
    eventCenter.emit('unReadCountChange');
  }

  @override
  void listenMessage() async {
    eventCenter.addListener('socket_message', (type, data) {
      _onReceivedMessage(type, data);
    });
    eventCenter.addListener('logout', (type, data) {
      DatabaseHelper.instance.close();
    });
  }

  final _lock = Lock();

  void _onReceivedMessage(String type, Object object) async {
    if (object is! SocketData) return;
    await _lock.synchronized(() async {
      SocketData socketData = object;
      if (socketData.targetType == TargetType.Group ||
          socketData.targetType == TargetType.Private) {
        MessageSession session = (await MessageSession.getSession(
            targetType: socketData.targetType,
            targetId: Session.uid == socketData.srcUid
                ? socketData.targetId
                : socketData.srcUid,
            sessionName: socketData.sessionName,
            sessionId: socketData.sessionId));
        //RTC握手状态改变
        if (socketData.message.type == MsgType.ChatRtcHandshakeChange) {
          SocketData? primaryData =
              session.getMessageById(socketData.message.extraInfo['targetMessageId'].toString());
          if (primaryData != null) {
            //由于本方法是async，reply消息可能先于原消息到达，此情况将到达回执先缓存起来
            primaryData!.message.extraInfo['handshakeStatus'] = socketData!.message.extraInfo['handshakeStatus'];
            // List<SocketData> sockets = await session.messages;
            int res = await DatabaseHelper.instance.updateMessage(primaryData);
            dog.d('res:$res');
            eventCenter.emit('messageReceived',socketData);
          }
        } else if (socketData.message.type == MsgType.Recipt) {
          // dog.d('socketData ->reply:${socketData}');
          SocketData? primaryData =
              session.getMessageById(socketData.messageId.toString());
          if (primaryData != null) {
            primaryData!.status = Status.reached;
            // List<SocketData> sockets = await session.messages;
            int res = await DatabaseHelper.instance
                .updateMessage(primaryData, {'status': Status.reached.index});
            dog.d('res:$res');
            eventCenter.emit('messageReceived',socketData);
          }
        } else {
          session.sessionName = socketData.sessionName;
          session.peerGender = socketData.peerGender;
          await session.insertMessage(socketData);
          dog.d('socketData ->send:${socketData}');
          if (socketData.message.type == MsgType.ChatRTCVideo ||
              socketData.message.type == MsgType.ChatRtcAudio) {
            if (socketData.targetId == Session.uid) {
              VideoCallPage.show(
                Constant.context,
                socketData.message.type == MsgType.ChatRTCVideo,
                socketData.srcUid,
                socketData.messageId,
                channelId: socketData.message.extraInfo['channelId'],
              );
            }
          }
        }
      }
    });
  }

  @override
  Future toChatPage(int targetId, String targetName) {
    return ChagePage.show(Constant.context,
        targetId: targetId, targetName: targetName);
  }
}
