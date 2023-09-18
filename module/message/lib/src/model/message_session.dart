import 'dart:math';

import 'package:base/base.dart';
import 'package:synchronized/synchronized.dart';

import '../util/DatabaseHelper.dart';

class MessageSession {
  bool isAtChatPage = false;

  static Future<List<MessageSession>> get sessions async {
    if (sessionMap.isEmpty) {
      List<MessageSession> sessions =
          await DatabaseHelper.instance.queryAllSessions(limit: 200);
      for (var e in sessions) {
        sessionMap[e.sessionId] = e;
        Constant.totalUnReadMsgCount += e.unReadCount;
      }
    }
    return sessionMap.values.toList();
  }

  static bool showMessageBadge = false;
  static const seseionListKey = 'conversationList10';

  static Map<String, MessageSession> sessionMap = {};
  static Lock sessionlock = Lock();

  MessageSession(
      {required this.targetType,
      required this.targetId,
      required this.sessionName,
      this.peerGender = 0,
      required this.sessionId});

  static Future<int> deleteSession(String sessionId) {
    Constant.totalUnReadMsgCount -= sessionMap[sessionId]?.unReadCount ?? 0;
    eventCenter.emit('unReadCountChange');
    sessionMap.remove(sessionId);
    return DatabaseHelper.instance.deleteSession(sessionId);
  }

  static Future<MessageSession> getSession(
      {required targetType,
      required targetId,
      required sessionName,
      required sessionId}) async {
    MessageSession? messageSession;
    await sessionlock.synchronized(() async {
      messageSession = sessionMap[sessionId];
      if (messageSession == null) {
        // dog.d('new Session:$sessionId');
        List<MessageSession> messageSessions = (await DatabaseHelper.instance
            .querySessions(
                fieldName: SessionField.sessionId.name, fieldValue: sessionId));
        if (messageSessions.isEmpty) {
          messageSession = MessageSession(
              targetType: TargetType.Private,
              targetId: targetId,
              sessionName: sessionName,
              sessionId: sessionId);
          sessionMap[messageSession!.sessionId] = messageSession!;
         int res = await DatabaseHelper.instance.insertSession(messageSession!);
         print(res);
          eventCenter.emit('sessionCountChange', messageSession!);
        } else {
          messageSession = messageSessions.first;
        }
        sessionMap[messageSession!.sessionId] = messageSession!;
      }
    });
    return messageSession!;
  }

  List<SocketData> _messages = <SocketData>[];
  final Map<String, SocketData> _messageMap = {};
  int page = 1;
  int pageSize = 20;
  int offsetDelta = 0;
  bool hasMore = true;
  final _lock = Lock();

  Future<List<SocketData>> get messages async {
    await _lock.synchronized(() async {
      if (_messages.isEmpty) {
        page = 1;
        hasMore = true;
        List<SocketData> socketDatas = await DatabaseHelper.instance
            .queryMessages(
                filedName: MessageField.sessionId.name,
                fieldValue: sessionId,
                offset: (page - 1) * 20 + offsetDelta,
                limit: pageSize,
                orderBy: '${MessageField.createAt.name} DESC');
        _messages.addAll(socketDatas.reversed.toList());
        for (var element in socketDatas) {
          _messageMap[element.messageId.toString()] = element;
        }
      }
    });
    // dog.d('last message:${_messages!.last}');
    return _messages;
  }

  // addMessage(SocketData data) {
  //   _messages.add(data);
  // }

  Future<List<SocketData>> more() async {
    int nextPage = page + 1;
    List<SocketData> socketDatas = await DatabaseHelper.instance.queryMessages(
        filedName: MessageField.sessionId.name,
        fieldValue: sessionId,
        offset: (nextPage - 1) * 20 + offsetDelta,
        limit: pageSize,
        orderBy: '${MessageField.createAt.name} DESC');
    if (socketDatas.isNotEmpty) {
      page = nextPage;
      List<SocketData> sds = socketDatas.reversed.toList();
      sds.addAll(_messages);
      _messages = sds;
      for (var element in socketDatas) {
        _messageMap[element.messageId.toString()] = element;
      }
    }
    hasMore = socketDatas.length >= pageSize;
    return _messages;
  }

  SocketData? getMessageById(String messaageId) {
    return _messageMap[messaageId];
  }

  Future insertMessage(SocketData data) async {
    lastData = data;
    msgCount += 1;
    if (!data.sendBySelf &&
        !(isAtChatPage && data.message.type == MsgType.ChatText)) {
      unReadCount += 1;
      Constant.totalUnReadMsgCount += 1;
    }

   int r = await DatabaseHelper.instance.updateSession(this);
    List<MessageSession> ses = await DatabaseHelper.instance.queryAllSessions(limit: 200);
    print(ses);
    int res = await DatabaseHelper.instance.insertMessage(data);

    if (_messages.isEmpty) {
      _messages = await messages;
    } else {
      _messages.add(data);
      // dog.d('add data2:${data.message.content}');
    }
    // dog.d('last message:2${_messages!.last}');

    _messageMap[data.messageId.toString()] = data;
    eventCenter.emit('messageAded', data);
    eventCenter.emit('unReadCountChange');
  }

  Future deleteMessage(SocketData data) async {
    msgCount -= 1;
    if (!data.sendBySelf && !data.read) {
      unReadCount -= 1;

      Constant.totalUnReadMsgCount -= 1;
      // if(unReadCount<0){
      //   unReadCount = 0;
      // }
      // if (Constant.totalUnReadMsgCount < 0) Constant.totalUnReadMsgCount = 0;
      eventCenter.emit('unReadCountChange');
    }
    if (data == _messages.last) {
      _messages.remove(data);
      lastData = _messages.last;
    } else {
      _messages.remove(data);
    }
    await DatabaseHelper.instance.deleteMessage(data.messageId.toString());
    if(offsetDelta>0) {
      offsetDelta -= 1;
    }else {
      page += 1;
      offsetDelta = pageSize -1;
    }
    await DatabaseHelper.instance.updateSession(this);
    _messageMap.remove(data.messageId);
  }

  String sessionName;
  int peerGender;
  final String sessionId;
  final int targetId; //一对一场景中是发送方Uid,群发场景中是targetId
  final TargetType targetType;
  int msgCount = 0;
  int unReadCount = 0;
  SocketData? lastData;

  factory MessageSession.fromMap(Map<String, dynamic> map) {
    return MessageSession(
      sessionId: map['sessionId'],
      sessionName: map['sessionName'],
      peerGender: map['peerGender'] ?? 0,
      targetType: TargetType.values[map['targetType']],
      targetId: map['targetId'],
    )
      ..msgCount = map['msgCount']
      ..unReadCount = max(map['unReadCount'] ?? 0, 0)
      ..lastData = map['lastData'].isEmpty
          ? null
          : SocketData.fromMap(TypeUtil.parseMap(map['lastData']));
  }

  Map<String, dynamic> toMMap() {
    return {
      'sessionId': sessionId,
      'targetId': targetId,
      'sessionName': sessionName ?? '',
      'peerGender': peerGender ?? '',
      'targetType': targetType.index,
      'msgCount': max(msgCount, 0),
      'unReadCount': unReadCount,
      'lastData': TypeUtil.parseString(lastData?.toMMap()) ?? '',
    };
  }

  //设置自己是否已读
  void setMessageReadStatus(List<SocketData> socketDatas) {
    unReadCount -= socketDatas.length;
    Constant.totalUnReadMsgCount -= socketDatas.length;
    if (unReadCount < 0) {
      unReadCount = 0;
    }
    if (Constant.totalUnReadMsgCount < 0) Constant.totalUnReadMsgCount = 0;
    DatabaseHelper.instance.updateSession(this);
    socketDatas.forEach((element) {
      element.read = true;
      DatabaseHelper.instance.updateMessage(element, {'read': 1});
    });
    eventCenter.emit('unReadCountChange');
  }
}
