import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:dog/dog.dart';

import 'dart:io';

import '../../base.dart';
import '../model/session.dart';

import '../util/events.dart';
import '../util/type_util.dart';
import '../model/socket_data.dart';

class SocketRadio {
  SocketRadio._();
  static SocketRadio? _instance;

  WebSocket? _webSocket;
  bool _noRetry = false;
  static SocketRadio get instance {
    _instance ??= SocketRadio._();
    return _instance!;
  }

  reconnect() async{
    close();
    if(_webSocket?.readyState!=WebSocket.connecting) {
      await connect(Constant.socketUrl);
    }
   dog.d('reconnect:${_webSocket?.readyState}');
  }

  close() {
    _webSocket?.close();
    _webSocket = null;
  }
  froze() {
    _noRetry = true;
    _webSocket?.close();
    _webSocket = null;
  }
  cancelFroze() {
    _noRetry = false;
  }

  connect(String addr) async {
    dog.d('connect:$addr');
    try {
      _webSocket = await WebSocket.connect(addr);
      _webSocket?.listen(_onData,
          onError: _onError, cancelOnError: true, onDone: _onDone);
      _webSocket!.pingInterval = const Duration(seconds: 30);
    }catch(e){
      dog.d(e);
    }

    _register();

  }
  void _onData(data) {
    // dog.i('$socketName _receivePackages message:$message', tag: LOG_TAG);
    if (data is List<int>) {
          SocketData socketData = SocketData.fromSocketBytes(data);
          eventCenter.emit("socket_message", socketData);
    }
  }
  void _onError(Object error, StackTrace stackTrace) async {
    dog.d('socket error:$error');
    close();
    if(!_noRetry) {
      _asureConnection();
    }
  }
  void _onDone() async {
    close();
    if(!_noRetry) {
      _asureConnection();
    }
  }
  void _asureConnection() {
    _timer ??= Timer.periodic(const Duration(seconds: 3), (timer) async{
      dog.d('timerLoop');
      if (_webSocket?.readyState != WebSocket.open) {
       await reconnect();
      }else {
        _timer?.cancel();
      }
    });
  }

  Timer? _timer;
  //targetType 1,普通用户,2。群组，房间等
 Future<int> sendMessage(Map message, int targetId, TargetType targetType,MsgContentType contentType) async{
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    String messageStr = TypeUtil.parseString(message);
    var body = Uint8List.fromList(utf8.encode(messageStr));
    var head = ByteData(25);
    int length = 25 + body.length;
    head.setUint32(0, length);
    head.setInt32(4, Session.uid);
    head.setInt32(8, targetId);
    int types = (targetType.index<<4)&contentType.index;
    head.setInt8(12, types);
    head.setInt64(13, timestamp);
    int messageId = Random().nextInt(pow(2, 32).toInt());
    head.setUint32(21, messageId);
    var data = head.buffer.asUint8List(0, head.lengthInBytes).cast<int>() +
        body.toList();
    if (_webSocket?.readyState != WebSocket.open) {
     await connect(Constant.socketUrl);
    }
    _webSocket?.add(data);
    if(targetType==TargetType.Private) {
      eventCenter.emit("socket_message", SocketData.fromSocketBytes(data));
    }
    return messageId;
  }

  //targetType 1,普通用户,2。群组，房间等
  reSendMessage(SocketData socketData) async{
    String messageStr = TypeUtil.parseString(socketData.message.toRawMap());
    var body = Uint8List.fromList(utf8.encode(messageStr));

    var head = ByteData(25);
    int length = 25 + body.length;
    head.setUint32(0, length);
    head.setInt32(4, socketData.srcUid);
    head.setInt32(8, socketData.targetId);
    int types = (socketData.targetType.index<<4)&socketData.contentType.index;
    head.setInt8(12, types);
    head.setInt64(13, socketData.createAt);
    head.setUint32(21, socketData.messageId);
    var data = head.buffer.asUint8List(0, head.lengthInBytes).cast<int>() +
        body.toList();
    if (_webSocket?.readyState != WebSocket.open) {
      await reconnect();
    }
    _webSocket?.add(data);
  }

  //targetType 1,普通用户,2。群组，房间等
  _register() {
    var head = ByteData(17);
    head.setUint32(0, 8);
    head.setInt32(4, Session.uid);
    var data = head.buffer.asUint8List(0, head.lengthInBytes).cast<int>();
    _webSocket?.add(data);
  }

  // disconnect() {
  //   _webSocket?.close();
  //   _webSocket = null;
  // }
}
