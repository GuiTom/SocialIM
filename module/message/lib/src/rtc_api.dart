import 'package:base/base.dart';

import 'locale/k.dart';

class RtcApi {
  //发起通话
  static Future<int> sendNotificationCallPeer(int targetUid,bool isVideo,String token,String channelId) async{
    return SocketRadio.instance.sendMessage({
      'content':
      '[${K.getTranslation(isVideo ? 'video_call' : 'audio_call')}]',
      'extraInfo': {
        'senderName': Session.userInfo.name,
        'senderGender': Session.userInfo.sex,
        'token': token,
        'channelId': channelId,
      }
    }, targetUid, TargetType.Private,isVideo ? MsgContentType.ChatRTCVideo : MsgContentType.ChatRtcAudio);
  }
  //拒绝通话
  static void sendNotificationRejectPeer(int targetUid,int messageId) {
    SocketRadio.instance.sendMessage({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.rejected.name,
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange,msgId: messageId);
  }
  //挂断通话
  static void sendNotificationHangup(int targetUid,int duration,int messageId) {
    SocketRadio.instance.sendMessage({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.finished.name,
        'duration': duration,
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange,msgId: messageId);
  }
  //通话超时
  static void sendNotificationTimeoutToPeer(int targetUid,int duration,int messageId) {
    SocketRadio.instance.sendMessage({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.timeout.name,
        'duration': duration,
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange,msgId: messageId);
  }
  //取消通话
  static void sendNotificationCancelToPeer(int targetUid,int messageId) {
    SocketRadio.instance.sendMessage({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.canceled.name,
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange,msgId: messageId);
  }

}