import 'dart:convert';
import 'dart:typed_data';

import 'package:base/src/model/session.dart';
import '../util/type_util.dart';

enum TargetType {
  Reply,
  Private, //一对一私聊
  LiveRoom, //房间
  Group, //群组
}

enum MsgType {
  Reply,
  ChatText,
  ChatAudio,
  ChatImage,
  MemberEnterExit, //成员进出
  MemberStatusChange //成员状态变化
}

enum Status {
  sending, //正在发送
  reached, //已到达服务器或对方手机
  timeOut, //超时未送达
  readByOther //对方已阅读
}

class SocketMessage {
  SocketMessage(
      {required this.content, required this.type, required this.extraInfo});

  final MsgType type;
  final String content;
  Map<String, dynamic> extraInfo;

  factory SocketMessage.fromMap(Map<String, dynamic> map) {
    return SocketMessage(
        content: map['content'] ?? '',
        type: MsgType.values[map['type'] ?? 0],
        extraInfo: TypeUtil.parseMap(map["extraInfo"]));
  }

  Map<String, dynamic> toMMap() {
    return {
      'content': content,
      'type': type.index,
      'extraInfo': TypeUtil.parseString(extraInfo)
    };
  }
  Map<String, dynamic> toRawMap() {
    return {
      'content': content,
      'type': type.index,
      'extraInfo': extraInfo
    };
  }

  @override
  String toString() {
    return 'SocketMessage{type: $type, content: $content, extraInfo: $extraInfo}';
  }
}

class SocketData {
  SocketData._(
      {required this.srcUid,
      required this.targetId,
      required this.targetType,
      required this.message,
      required this.status,
      required this.read,
      required this.createAt});

  bool read = false; //是否已经被自己阅读
  Status status = Status.sending; //0,正在发送 1.已送达 2.已超时 3.对方已读
  final int srcUid;
  final int targetId;
  final TargetType targetType;
  final int createAt; //时间戳 单位豪秒
  final SocketMessage message;

  @override
  String toString() {
    return 'SocketData{ msid:$messageId, srcUid: $srcUid, targetId: $targetId, targetType: $targetType, createAt: ${DateTime.fromMillisecondsSinceEpoch(createAt)}, message: $message, type:$targetType,status:$status read:$read, sendBySelf:$sendBySelf}';
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
      }else {
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

  String get messageId {
    if (targetType == TargetType.Private) {
      if (targetId == Session.uid) {
        //别人发给我的
        return '${srcUid}_$createAt';
      }
    }
    return '${targetId}_$createAt';
  }

  Map<String, dynamic> toMMap() {
    return {
      'messageId': messageId,
      'sessionId': sessionId,
      'srcUid': srcUid,
      'targetId': targetId,
      'targetType': targetType.index,
      'createAt': createAt,
      'message': TypeUtil.parseString(message.toMMap()),
      'read': read ? 1 : 0,
      'status': status.index,
    };
  }

  factory SocketData.fromMap(Map<String, dynamic> map) {
    return SocketData._(
        srcUid: map['srcUid'] ?? 0,
        targetId: map['targetId'] ?? 0,
        targetType: TargetType.values[map['targetType'] ?? 0],
        createAt: map['createAt'] ?? 0,
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
    int targetType = byteData.getInt8(12);
    int timeStamp = byteData.getInt64(13);
    String message = length > 21 ? utf8.decode(bytes.sublist(21, length)) : '';

    return SocketData._(
        srcUid: srcUid,
        targetId: targetId,
        targetType: TargetType.values[targetType],
        message: SocketMessage.fromMap(TypeUtil.parseMap(message)),
        status: Status.sending,
        read: false,
        createAt: timeStamp);
  }
}
