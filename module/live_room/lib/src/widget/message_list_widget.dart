//@dart=2.12
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import '../locale/k.dart';

class MessageListWidget extends StatefulWidget {
  final List<SocketData> messages;

  const MessageListWidget({Key? key, required this.messages}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessageListState();
}

class MessageListState extends State<MessageListWidget> {
  late List<SocketData> _messages;

  @override
  void initState() {
    super.initState();
    _messages = widget.messages;
  }

  void pushMessage(SocketData message) {
    if (message.message.extraInfo['action'] == 'closeRoom') {
      ToastUtil.showCenter(msg: K.getTranslation('room_is_closed'));
      Navigator.pop(context, true);
      return;
    }
    _messages = [message, ..._messages];
    dog.d("socketData:---->:$message");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 202,
      padding: const EdgeInsetsDirectional.only(top: 35, bottom: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.purple.withOpacity(0.5),
          ],
        ),
      ),
      child: ListView.separated(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
          reverse: true,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return Text(() {
              SocketMessage message = _messages[index].message;

              String name = message.extraInfo['name'] ?? '';
              String action = message.extraInfo['action'] ?? '';
              if (action == 'join') {
                return K
                    .getTranslation('welcome_somebody_enter_room', args: [name]);
              }
              if (action == 'leave') {
                return K.getTranslation('somebody_levead_room', args: [name]);
              }
              return message.content;
            }(), style: const TextStyle(color: Colors.white, fontSize: 14));
          },
          itemCount: _messages.length),
    );
  }
}
