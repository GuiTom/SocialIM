//@dart=2.12
import 'package:flutter/cupertino.dart';

class ChatAudio extends StatefulWidget {
  final bool isLeft;
  final int durationInMillseconds;
  final bool isPlaying;
  const ChatAudio(
      {Key? key, required this.isLeft, required this.durationInMillseconds, required this.isPlaying})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatAudio> {
  @override
  void dispose() {
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
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
            SizedBox(
              width: 67 + (widget.durationInMillseconds * 3 ~/ 1000).toDouble(),
              height: 47,
            ),
            PositionedDirectional(
              start: widget.isLeft ? 10 : null,
              end: widget.isLeft ? null : 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if(widget.isLeft)
                    const SizedBox(width: 8,),
                  Text(
                    '${widget.durationInMillseconds ~/ 1000}"',
                    style: const TextStyle(color: Color(0xFF313131)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    widget.isPlaying?'assets/chat_audio_stop.png':'assets/chat_audio_play.png',
                    package: 'message',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
