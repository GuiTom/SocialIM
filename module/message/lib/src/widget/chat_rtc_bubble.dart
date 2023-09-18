//@dart=2.12
import 'package:flutter/cupertino.dart';
import 'package:base/base.dart';

class ChatRtcBubble extends StatefulWidget {
  final bool isLeft;
  final SocketMessage message;

  const ChatRtcBubble({Key? key, required this.isLeft, required this.message})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatRtcBubble> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
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
                15,
                15,
                15,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    widget.message.type == MsgType.ChatRTCVideo
                        ? 'assets/icon_call_video.svg'
                        : 'assets/icon_call_voice.svg',
                    package: 'message',
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  _buildContent(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    String? content;
    if (widget.message.extraInfo['handshakeStatus'] == 'rejected') {
      content = '已拒绝';
    } else if (widget.message.extraInfo['handshakeStatus'] == 'canceled') {
      content = '对方已取消';
    } else if (widget.message.extraInfo['handshakeStatus'] == 'timeout') {
      content = '未应答';
    } else if (widget.message.extraInfo['handshakeStatus'] == 'finished') {
      int duration = widget.message.extraInfo['duration'] ?? 0;
      content =
          '通话时长 ${(duration ~/ 60).toString().padLeft(2, '0')}:${(duration % 60).toString().padLeft(2, '0')}';
    } else {
      content = widget.message.content;
    }
    return Text(content);
  }
}
