import 'dart:io';
import 'package:base/src/locale/k.dart' as BaseK;
import 'package:base/base.dart';
import 'package:flutter/material.dart';


class LiveRoomInputBar extends StatefulWidget {
  final int targetId;
  final TargetType targetType;

  @override
  State<StatefulWidget> createState() => _State();

  const LiveRoomInputBar(
      {super.key, required this.targetId, required this.targetType});
}

class _State extends State<LiveRoomInputBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController(text: '');

  bool _isMute = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(6),
      decoration: const BoxDecoration(
        color: Color(0xFFE8E8E8),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          _buildMuteMicWidget(),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 12, vertical: 0),
                child: TextField(
                  controller: _textController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                    hintText: BaseK.K.getTranslation('be_active_then_story_happen'),
                  ),
                  textInputAction: TextInputAction.send,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  onSubmitted: (String value) {
                    _onInputSubmit(value);
                  },
                ),
          )),
          const SizedBox(width: 8),
          ThrottleInkWell(
            onTap: () {
              _onInputSubmit(_textController.text);
            },
            child: SizedBox(
              width: 60,
              child: Button(
                title: BaseK.K.getTranslation('send'),
                buttonSize: ButtonSize.Small,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildMuteMicWidget() {
    return ThrottleInkWell(
      onTap: () {
        _isMute = !_isMute;

        ToastUtil.showBottom(msg: _isMute ? '已禁麦' : '已开麦');

        RtcEngineManager.instance.muteLocalAudioStream(_isMute);
        setState(() {});
      },
      child: SvgPicture.asset('assets/ic_im_voice.svg',
          package: 'live_room',
          width: 30,
          height: 30,
          color: _isMute ? null : Colors.green),
    );
  }

  void _onInputSubmit(String keyword) {
    if (Platform.isIOS) {
      FocusScope.of(Constant.context).requestFocus(_focusNode);
    }
    SocketRadio.instance.sendMessage(
        {'type': MsgContentType.ChatText.index, 'content': keyword},
        widget.targetId,
        TargetType.LiveRoom,MsgContentType.ChatText);
    _clearInput();
  }

  void _clearInput() {
    _textController.clear();
  }
}
