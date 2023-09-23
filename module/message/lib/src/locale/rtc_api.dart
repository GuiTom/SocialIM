import 'package:base/base.dart';

import 'k.dart';

class RtcApi {
  //拨打通话
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
        'handshakeStatus': 'rejected',
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange);
  }
  //挂断通话
  static void sendNotificationHangup(int targetUid,int duration,int messageId) {
    SocketRadio.instance.sendMessage({
      'extraInfo': {
        'handshakeStatus': 'finished',
        'duration': duration,
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange);
  }
  //通话超时
  static void sendNotificationTimeoutToPeer(int targetUid,int duration,int messageId) {
    SocketRadio.instance.sendMessage({
      'extraInfo': {
        'handshakeStatus': 'timeout',
        'duration': duration,
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange);
  }
  //取消通话
  static void sendNotificationCancelToPeer(int targetUid,int messageId) {
    SocketRadio.instance.sendMessage({
      'extraInfo': {
        'handshakeStatus': 'cancel',
        'targetMessageId':messageId,
      }
    }, targetUid, TargetType.Private,MsgContentType.ChatRtcHandshakeChange);
  }

}