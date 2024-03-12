import 'dart:convert';
import 'dart:typed_data';

import 'package:base/src/model/session.dart';
import '../../base.dart';
import '../util/type_util.dart';

enum TargetType {
  None,
  Private, //一对一私聊
  LiveRoom, //房间
  Group, //群组
}

enum MsgContentType {
  Recipt,
  ChatText,
  ChatAudio,
  ChatImage,
  ChatRTCVideo,
  ChatRtcAudio,
  ChatRtcHandshakeChange,
  MemberEnterExit, //成员进出
  MemberStatusChange, //成员状态变化
  Customize,
}

enum Status {
  sending, //正在发送
  reached, //已到达服务器或对方手机
  timeOut, //超时未送达
}
enum HandShakeStatus{
  rejected,
  canceled,
  timeout,
  finished
}
class SocketMessage {
  SocketMessage(
      {required this.content, required this.extraInfo});

 
  final String content;
  Map<String, dynamic> extraInfo;

  factory SocketMessage.fromMap(Map<String, dynamic> map) {
    return SocketMessage(
        content: map['content'] ?? '',
        extraInfo: TypeUtil.parseMap(map["extraInfo"]));
  }

  Map<String, dynamic> toMMap() {
    return {
      'content': content,
      'extraInfo': TypeUtil.parseString(extraInfo)
    };
  }

  Map<String, dynamic> toRawMap() {
    return {'content': content, 'extraInfo': extraInfo};
  }

  @override
  String toString() {
    return 'SocketMessage{ content: $content, extraInfo: $extraInfo}';
  }
}

class SocketData {
  SocketData._(
      {required this.messageId,
      required this.srcUid,
      required this.targetId,
      required this.targetType,
        required this.contentType,
      required this.message,
      required this.status,
      required this.read,
      required this.createAt});
  final MsgContentType contentType;
  bool read = false; //是否已经被自己阅读
  Status status = Status.sending; //0,正在发送 1.已送达 2.已超时 3.对方已读
  final int srcUid;
  final int targetId;
  final TargetType targetType;
  final int createAt; //时间戳 单位豪秒
  final int messageId;
  final SocketMessage message;

  @override
  String toString() {
    return 'SocketData{ msid:$messageId, srcUid: $srcUid, targetId: $targetId, targetType: $targetType, createAt: ${DateTime.fromMillisecondsSinceEpoch(createAt)}, message: $message, type:$targetType,contentType:$contentType,status:$status read:$read, sendBySelf:$sendBySelf}';
  }

  String get sessionName {
    if (targetType == TargetType.Private) {
      if (targetId == Session.uid) {
        //别人发给我的
        return message.extraInfo['senderName'] ?? '';
      } else {
        return message.extraInfo['receiverName'] ?? ''; //自己的回包
      }
    }
    return message.extraInfo['groupName'] ?? '';
  }

  int get peerGender {
    if (targetType == TargetType.Private) {
      if (targetId == Session.uid) {
        //别人发给我的
        return message.extraInfo['senderGender'] ?? 0;
      } else {
        return 0;
      }
    }
    return 0;
  }

  bool get sendBySelf {
    return srcUid == Session.uid;
  }

  String get sessionId {
    if (targetType == TargetType.Private) {
      if (targetId == Session.uid) {
        //别人发给我的
        return '${targetType.name}_${srcUid}';
      }
    }
    return '${targetType.name}_${targetId}';
  }

  Map<String, dynamic> toMMap() {
    return {
      'messageId': messageId,
      'sessionId': sessionId,
      'srcUid': srcUid,
      'targetId': targetId,
      'targetType': targetType.index,
      'createAt': createAt,
      'contentType': contentType.index,
      'message': TypeUtil.parseString(message.toMMap()),
      'read': read ? 1 : 0,
      'status': status.index,
    };
  }

  factory SocketData.fromMap(Map<String, dynamic> map) {
    return SocketData._(
        messageId: map['messageId'],
        srcUid: map['srcUid'] ?? 0,
        targetId: map['targetId'] ?? 0,
        targetType: TargetType.values[map['targetType'] ?? 0],
        createAt: map['createAt'] ?? 0,
        contentType:MsgContentType.values[map['contentType'] ?? 0],
        read: map['read'] == 1 ? true : false,
        status: Status.values[map['status'] ?? 0],
        message: SocketMessage.fromMap(TypeUtil.parseMap(map["message"])));
  }

  factory SocketData.fromSocketBytes(List<int> data) {
    Uint8List bytes = Uint8List.fromList(data);
    ByteData byteData = ByteData.view(bytes.buffer);
    int length = byteData.getUint32(0);
    int srcUid = byteData.getInt32(4);
    int targetId = byteData.getInt32(8);
    int types = byteData.getInt8(12);
    int targetType = types>>4;
    int contentType = types&0x0F;
    int timeStamp = byteData.getInt64(13);
    int messageId = byteData.getUint32(21);
    String message = length > 25 ? utf8.decode(bytes.sublist(25, length)) : '';

    return SocketData._(
        messageId: messageId,
        srcUid: srcUid,
        targetId: targetId,
        targetType: TargetType.values[targetType],
        contentType: MsgContentType.values[contentType],
        message: SocketMessage.fromMap(TypeUtil.parseMap(message)),
        status: Status.sending,
        read: false,
        createAt: timeStamp);
  }
}
