//@dart=2.12
import 'package:flutter/cupertino.dart';

class ChatBubble extends StatefulWidget {
  final bool isLeft;
  final String text;

  const ChatBubble({Key? key, required this.isLeft, required this.text})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatBubble> {

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 5,),
      Stack(
        children: [
          const SizedBox(
            width: 67,
            height: 47,
          ),
          Positioned.fill(
              child: Transform.scale(
                scaleX: widget.isLeft ? -1 : 1,
                child: Image.asset(
                  'assets/bubble_bg.webp',
                  package: 'message',
                  centerSlice: Rect.fromCenter(
                      center: const Offset(33.5, 23.5), width: 2, height: 2),
                  scale: 5,
                  fit: BoxFit.fill,
                ),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              30,
              20,
            ),
            child: Text(widget.text),
          ),
        ],
      ),
    ],);
  }
}
