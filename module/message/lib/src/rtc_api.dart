import 'dart:math';

import 'package:base/base.dart';

import 'locale/k.dart';

class RtcApi {
  //发起通话
  static Future<SocketData> sendNotificationCallPeer(
      int targetUid, bool isVideo, String token, String channelId) async {
    int messageId = Random().nextInt(pow(2, 32).toInt()) + DateTime.now().millisecondsSinceEpoch;;
    var data = SocketRadio.instance.createSocketData({
      'content': '[${K.getTranslation(isVideo ? 'video_call' : 'audio_call')}]',
      'extraInfo': {
        'senderName': Session.userInfo.name,
        'senderGender': Session.userInfo.sex,
        'token': token,
        'channelId': channelId,
      }
    }, targetUid, TargetType.Private,
        isVideo ? MsgContentType.ChatRTCVideo : MsgContentType.ChatRtcAudio,
        msgId: messageId);
    SocketData socketData = SocketData.fromSocketBytes(data);
    SocketRadio.instance.sendMessage(socketData);
    return Future(() => socketData);
  }
  //拒绝通话
  static void sendNotificationAcceptCall(int targetUid, int messageId) {

    var data = SocketRadio.instance.createSocketData({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.accepted.name,
        'targetMessageId': messageId,
      }
    }, targetUid, TargetType.Private, MsgContentType.ChatRtcHandshakeChange,
        msgId: messageId);
    SocketData socketData = SocketData.fromSocketBytes(data);
    SocketRadio.instance.sendMessage(socketData);
  }
  //拒绝通话
  static void sendNotificationRejectPeer(int targetUid, int messageId) {

    var data = SocketRadio.instance.createSocketData({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.rejected.name,
        'targetMessageId': messageId,
      }
    }, targetUid, TargetType.Private, MsgContentType.ChatRtcHandshakeChange,
        msgId: messageId);
    SocketData socketData = SocketData.fromSocketBytes(data);
    SocketRadio.instance.sendMessage(socketData);
  }

  //挂断通话
  static  Future<SocketData> sendNotificationHangup(
      int targetUid, int duration, int messageId) async{
    int messageId = Random().nextInt(pow(2, 32).toInt()) + DateTime.now().millisecondsSinceEpoch;;

    var data = SocketRadio.instance.createSocketData({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.finished.name,
        'duration': duration,
        'targetMessageId': messageId,
      }
    }, targetUid, TargetType.Private, MsgContentType.ChatRtcHandshakeChange,
        msgId: messageId);
    SocketData socketData = SocketData.fromSocketBytes(data);
    return SocketRadio.instance.sendMessage(socketData);
  }

  //通话超时
  static void sendNotificationTimeoutToPeer(
      int targetUid, int duration, int messageId) {
    int messageId = Random().nextInt(pow(2, 32).toInt()) + DateTime.now().millisecondsSinceEpoch;;

    var data = SocketRadio.instance.createSocketData({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.timeout.name,
        'duration': duration,
        'targetMessageId': messageId,
      }
    }, targetUid, TargetType.Private, MsgContentType.ChatRtcHandshakeChange,
        msgId: messageId);
    SocketData socketData = SocketData.fromSocketBytes(data);
    SocketRadio.instance.sendMessage(socketData);
  }

  //取消通话
  static void sendNotificationCancelToPeer(int targetUid, int messageId) {
    int messageId = Random().nextInt(pow(2, 32).toInt()) + DateTime.now().millisecondsSinceEpoch;;
    var data = SocketRadio.instance.createSocketData({
      'extraInfo': {
        'handshakeStatus': HandShakeStatus.canceled.name,
        'targetMessageId': messageId,
      }
    }, targetUid, TargetType.Private, MsgContentType.ChatRtcHandshakeChange,
        msgId: messageId);
    SocketData socketData = SocketData.fromSocketBytes(data);
    SocketRadio.instance.sendMessage(socketData);
  }
}
