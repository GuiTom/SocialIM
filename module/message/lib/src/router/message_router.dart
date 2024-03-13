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
  void showRTCCall(
      BuildContext context, bool isVideo, int targetUid, String senderName) {
    VideoCallPage.show(context, isVideo, targetUid, 0, senderName);
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
        if (socketData.contentType == MsgContentType.ChatRtcHandshakeChange) {
          //rtc握手
          SocketData? primaryData = session.getMessageById(
              socketData.message.extraInfo['targetMessageId'].toString());
          if (primaryData != null) {
            //由于本方法是async，reply消息可能先于原消息到达，此情况将到达回执先缓存起来
            primaryData!.message.extraInfo['handshakeStatus'] =
                socketData!.message.extraInfo['handshakeStatus'];
            if (socketData!.message.extraInfo['duration'] != null) {
              primaryData!.message.extraInfo['duration'] =
                  socketData!.message.extraInfo['duration'];
            }
            // List<SocketData> sockets = await session.messages;
            int res = await DatabaseHelper.instance.updateMessage(primaryData);
            dog.d('res:$res');
            eventCenter.emit(
                'HandshakeChangeMessageReceived', [socketData, primaryData]);
          }
        } else if (socketData.contentType == MsgContentType.Recipt) {
          // dog.d('socketData ->reply:${socketData}');
          SocketData? primaryData =
              session.getMessageById(socketData.messageId.toString());
          if (primaryData != null) {
            primaryData!.status = Status.reached;
            // List<SocketData> sockets = await session.messages;
            int res = await DatabaseHelper.instance
                .updateMessage(primaryData, {'status': Status.reached.index});
            dog.d('res:$res');
            eventCenter.emit('messageReceived', socketData);
          }
        } else {
          if (socketData.targetId == Session.uid) {
            session.sessionName = socketData.sessionName;
            session.peerGender = socketData.peerGender;
          }
          if (socketData.contentType == MsgContentType.ChatImage ||
              socketData.contentType == MsgContentType.ChatAudio) {
            if (socketData.sendBySelf &&
                socketData.message.extraInfo["localPath"] == null) {//图像上传成功
              SocketData? primaryData =
                  session.getMessageById(socketData.messageId.toString());
              primaryData?.message.extraInfo['filePath'] =
                  socketData.message.extraInfo["filePath"];
              eventCenter.emit('messageReceived', socketData);
              return;
            }
          }
          await session.insertMessage(socketData);
          dog.d('socketData ->send:${socketData}');
          if (socketData.contentType == MsgContentType.ChatRTCVideo ||
              socketData.contentType == MsgContentType.ChatRtcAudio) {
            if (socketData.targetId == Session.uid &&
                socketData.message.extraInfo['handshakeStatus'] == null) {
              VideoCallPage.show(
                Constant.context,
                socketData.contentType == MsgContentType.ChatRTCVideo,
                socketData.srcUid,
                socketData.messageId,
                socketData.message.extraInfo['senderName'],
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
