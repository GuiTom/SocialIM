//@dart=2.12
import 'package:flutter/cupertino.dart';
import 'package:base/base.dart';

import '../locale/k.dart';

class ChatRtcBubble extends StatefulWidget {
  final bool isLeft;
  final SocketData data;

  const ChatRtcBubble({Key? key, required this.isLeft, required this.data})
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
                    widget.data.contentType == MsgContentType.ChatRTCVideo
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
    if (widget.data.message.extraInfo['handshakeStatus'] == HandShakeStatus.rejected.name) {
      if(widget.data.targetId==Session.uid) {
        content = K.getTranslation('rejected');
      }else {
        content = K.getTranslation('the_peer_rejected');
      }
    } else if (widget.data.message.extraInfo['handshakeStatus'] == HandShakeStatus.canceled.name) {
      if(widget.data.targetId==Session.uid) {
        content = K.getTranslation('the_peer_canceled');
      }else {
        content = K.getTranslation('canceled');
      }
    } else if (widget.data.message.extraInfo['handshakeStatus'] == HandShakeStatus.timeout.name) {
      if(widget.data.targetId==Session.uid) {
        content = K.getTranslation('no_answer');
      }else {
        content = K.getTranslation('the_peer_no_answer');
      }
    } else if (widget.data.message.extraInfo['handshakeStatus'] == HandShakeStatus.finished.name) {
      int duration = widget.data.message.extraInfo['duration'] ?? 0;
      content = K.getTranslation('session_duration', args: [
        '${(duration ~/ 60).toString().padLeft(2, '0')}:${(duration % 60).toString().padLeft(2, '0')}'
      ]);
    } else {
      content = widget.data.message.content;
    }
    return Text(content);
  }
}
