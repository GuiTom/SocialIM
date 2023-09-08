import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:message/src/video_call_page.dart';
import 'package:message/src/widget/message_list_widget.dart';
import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart' as Ep;
import 'package:image/image.dart' as Img;
import 'package:base/src/locale/k.dart' as BaseK;
import 'package:message/src/widget/recorder_overlay_widget.dart';
import 'locale/k.dart';
import 'model/message_session.dart';

class ChagePage extends StatefulWidget {
  const ChagePage({Key? key, required this.targetId, required this.targetName})
      : super(key: key);
  static const routeName = '/ChagePage';
  final int targetId;
  final String targetName;

  static Future show(BuildContext context,
      {required int targetId, required String targetName}) {
    Route? pageRoute = defaultLifecycleObserver.findRoute(routeName);
    if (pageRoute == null) {
      return Navigator.of(context).push(MaterialPageRoute<bool>(
        builder: (context) => ChagePage(
          targetId: targetId,
          targetName: targetName,
        ),
        settings: const RouteSettings(name: routeName),
      ));
    } else {
      Navigator.of(context)
          .popUntil((route) => route.settings.name == routeName);
      return Future(() => true);
    }
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChagePage> with WidgetsBindingObserver {
  final TextEditingController _textController = TextEditingController(text: '');
  final ScrollController _textScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showEmojiPanel = false;
  bool _loading = false;
  List<SocketData>? _messages;
  MessageSession? _messgaeSession;
  bool _isVoiceInput = false;

  @override
  void initState() {
    super.initState();
    eventCenter.addListener('messageAded', _messageUpdated);
    eventCenter.addListener('messageReceived', _messageUpdated);
    eventCenter.addListener('messageDeleted', _messageUpdated);
    WidgetsBinding.instance!.addObserver(this);

    _loadMessages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    eventCenter.removeListener('messageAded', _messageAddedd);
    eventCenter.removeListener('messageReceived', _messageUpdated);
    eventCenter.removeListener('messageDeleted', _messageUpdated);
    _messgaeSession?.isAtChatPage = false;
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    setState(() {
      _showEmojiPanel = _showEmojiPanel && bottomInset <= 0;
    });
  }
  void _messageAddedd(String type, Object data) async {
    _messgaeSession!.offsetDelta += 1;
    _messages = await _messgaeSession!.messages;
    if (!mounted) return;
    setState(() {});
  }

  void _messageUpdated(String type, Object data) async {
    _messages = await _messgaeSession!.messages;

    if (!mounted) return;
    setState(() {});
  }

  void _loadMessages() async {
    _loading = true;
    String sessionId = '${TargetType.Private.name}_${widget.targetId}';
    _messgaeSession = await MessageSession.getSession(
        targetType: TargetType.Private,
        targetId: widget.targetId,
        sessionName: widget.targetName,
        sessionId: sessionId);
    _messgaeSession!.offsetDelta = 0;
    _messages = await _messgaeSession!.messages;
    _messgaeSession!.setMessageReadStatus(_messages!
        .where((element) =>
            (element.message.type == MsgType.ChatText ||
                element.message.type == MsgType.ChatImage) &&
            !element.sendBySelf &&
            !element.read)
        .toList());
    _loading = false;
    _messgaeSession!.isAtChatPage = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Loading();
    }
    return Scaffold(
        backgroundColor: const Color(0xFFF1F1F1),
        appBar: AppBar(
          title: Text(
            _messgaeSession!.sessionName,
          ),
        ),
        body: SafeArea(
            child: GestureDetector(
          onTap: () {
            if (_focusNode.hasFocus) {
              FocusScope.of(context).unfocus(); // 点击屏幕其他位置时隐藏键盘
            }
            _showEmojiPanel = false;
            setState(() {});
          },
          child: Column(
            children: [
              MessageListWidget(
                onScrollToTop: () async {
                  if (!_messgaeSession!.hasMore) return;
                  _messages = await _messgaeSession!.more();
                  setState(() {});
                },
                messgageSession: _messgaeSession!,
                messages: _messages!,
              ),
              _renderInput(),
              const SizedBox(height: 12),
              _renderBottomToolButtons(),
              const SizedBox(height: 12),
              if (_showEmojiPanel) _renderEmojiPanel(),
            ],
          ),
        )));
  }

  Widget _renderInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              _isVoiceInput = !_isVoiceInput;
              setState(() {});
            },
            child: SvgPicture.asset(
              _isVoiceInput
                  ? 'assets/icon_keyboard_dark.svg'
                  : 'assets/icon_voice_dark.svg',
              width: 28,
              height: 28,
              package: 'message',
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              height: 40,
              child: _isVoiceInput
                  ? _buildVoiceInputWidget()
                  : _buildTextInputWidget(),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          ThrottleInkWell(
            onTap: () {
              if (_isVoiceInput) return;
              _onInputSubmit(_textController.text);
            },
            child: SizedBox(
              width: 55,
              child: Button(
                title: BaseK.K.getTranslation('send'),
                buttonSize: ButtonSize.Small,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextInputWidget() {
    return TextField(
      decoration: InputDecoration(
        hintText: BaseK.K.getTranslation('be_active_then_story_happen'),
        border: InputBorder.none,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0x66313131),
            fontSize: 14),
        isDense: true,
        contentPadding:
            const EdgeInsetsDirectional.only(start: 10.0, end: 12.0),
      ),
      textAlign: TextAlign.start,
      style: const TextStyle(fontSize: 14.0, color: Colors.black),
      focusNode: _focusNode,
      controller: _textController,
      scrollController: _textScrollController,
      autocorrect: false,
      autofocus: false,
      maxLines: null,
      textInputAction: TextInputAction.send,
      onSubmitted: _onInputSubmit,
      onChanged: (String value) {
        setState(() {});
      },
      keyboardAppearance: Brightness.light,
    );
  }

  Widget _buildVoiceInputWidget() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () async {
        // dog.d('on-LongPress:onLongPress');
        RecorderOverlay.show(context, (recordDetail) async {
          dog.d('recordDetail:$recordDetail');
          UploadResp resp = await Net.uploadFile(
              url: System.api('/api/upload/chatAudio'),
              filePath: recordDetail['filePath'],
              pb: true,
              params: {'uid': Session.uid},
              pbMsg: UploadResp.create());
          if (resp.code == 1) {
            SocketRadio.instance.sendMessage({
              'type': MsgType.ChatAudio.index,
              'content': '[${K.getTranslation('voice')}]',
              'extraInfo': {
                'senderName': Session.userInfo.name,
                'senderGender': Session.userInfo.sex,
                'receiverName': widget.targetName,
                'filePath': resp.filePath,
                'duration': recordDetail['duration'],
              }
            }, widget.targetId, TargetType.Private);
          } else {
            ToastUtil.showCenter(msg: resp.message);
          }
        });
      },
      onLongPressEnd: (LongPressEndDetails details) async {
        // dog.d('on-LongPressEnd:${details.localPosition}|${details.globalPosition}');
        if (details.localPosition.dy > -10) {
          //正常结束
          RecorderOverlay.finish();
        } else {
          //取消录音
          RecorderOverlay.cancel();
        }
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        // dog.d('on-onLongPressMoveUpdate:${details.localPosition}|${details.globalPosition}');
        if (details.localPosition.dy < -10) {
          RecorderOverlay.changeStatus(2);
        } else {
          RecorderOverlay.changeStatus(0);
        }
      },
      child: Text(
        K.getTranslation('hold_to_talk'),
        style: const TextStyle(color: Color(0xFF616161)),
      ),
    );
  }

  void _onInputSubmit(String keyword) {
    if (keyword.isEmpty) return;
    if (Platform.isIOS) {
      FocusScope.of(context).requestFocus(_focusNode);
    }
    SocketRadio.instance.sendMessage({
      'type': MsgType.ChatText.index,
      'content': keyword,
      'extraInfo': {
        'senderName': Session.userInfo.name,
        'senderGender': Session.userInfo.sex,
        'receiverName': widget.targetName
      }
    }, widget.targetId, TargetType.Private);
    _textController.clear();
    _showEmojiPanel = false;
    setState(() {});
  }

  Widget _renderBottomToolButtons() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ThrottleInkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              _showEmojiPanel = true;
              setState(() {});
            },
            child: SvgPicture.asset(
              'assets/chat_bottom_emote.svg',
              package: 'message',
            ),
          ),
          ThrottleInkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              _showEmojiPanel = false;
              _sendImage();
              setState(() {});
            },
            child: SvgPicture.asset(
              'assets/chat_bottom_pic.svg',
              package: 'message',
            ),
          ),
          // ThrottleInkWell(
          //   onTap: () {
          //     _showVideoCallActionSheet(context);
          //     FocusScope.of(context).unfocus();
          //     _showEmojiPanel = false;
          //     setState(() {});
          //   },
          //   child: SvgPicture.asset(
          //     'assets/icon_video_call.svg',
          //     package: 'message',
          //   ),
          // ),
        ]);
  }

  void _showVideoCallActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon_call_video.svg',
                      package: 'message',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 5,),
                    Text(K.getTranslation('video_call')),
                  ],
                ),
                onTap: () {
                  // Handle action when 'Choose from Gallery' is tapped
                  Navigator.pop(context);
                  // VideoCallPage.show(context, true);
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icon_call_voice.svg',
                      package: 'message',
                      width: 28,
                      height: 28,
                    ),
                    const SizedBox(width: 5,),
                    Text(K.getTranslation('voice_call')),
                  ],
                ),
                onTap: () {
                  // Handle action when 'Take a Photo' is tapped
                  Navigator.pop(context);
                },
              ),
              Container(
                height: 5,
                color: const Color(0xFFE1E1E1),
              ),
              ListTile(
                title: Text(BaseK.K.getTranslation('cancel'),textAlign: TextAlign.center,),
                onTap: () {
                  // Handle action when 'Take a Photo' is tapped
                  Navigator.pop(context);
                },
              ),
              // Add more ListTiles for additional actions
            ],
          ),
        );
      },
    );
  }

  void _sendImage() async {
    final imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker.pickImage(
      imageQuality: 50,
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return;
    }
    final image = Img.decodeImage(File(pickedFile!.path).readAsBytesSync());
    if (image == null) {
      return;
    }
    int imageWidth = image!.width;
    int imageHeight = image!.height;

    CommonLoading.show();
    UploadResp resp = await Net.uploadFile(
        url: System.api('/api/upload/chatImage'),
        filePath: pickedFile.path,
        pb: true,
        params: {'uid': Session.uid},
        pbMsg: UploadResp.create());
    if (resp.code == 1) {
      SocketRadio.instance.sendMessage({
        'type': MsgType.ChatImage.index,
        'content': '[${K.getTranslation('picture')}]',
        'extraInfo': {
          'senderName': Session.userInfo.name,
          'senderGender': Session.userInfo.sex,
          'receiverName': widget.targetName,
          'filePath': resp.filePath,
          'imageWidth': imageWidth,
          'imageHeight': imageHeight,
        }
      }, widget.targetId, TargetType.Private);
    } else {
      ToastUtil.showCenter(msg: resp.message);
    }
    CommonLoading.dismiss();
  }

  Widget _renderEmojiPanel() {
    return SizedBox(
      height: 250,
      child: Ep.EmojiPicker(
        onEmojiSelected: (Ep.Category? category, Ep.Emoji emoji) {
          // Do something when emoji is tapped (optional)
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            _textScrollController
                .jumpTo(_textScrollController.position.maxScrollExtent);
          });
        },
        onBackspacePressed: () {
          // Do something when the user taps the backspace button (optional)
          // Set it to null to hide the Backspace-Button
          _textController.text =
              _textController.text.characters.skipLast(1).toString();
        },
        textEditingController: _textController,
        // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Ep.Config(
          columns: 7,
          emojiSizeMax: 32 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.30
                  : 1.0),
          // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: EdgeInsets.zero,
          initCategory: Ep.Category.RECENT,
          bgColor: const Color(0xFFF2F2F2),
          indicatorColor: Colors.blue,
          iconColor: Colors.grey,
          iconColorSelected: Colors.blue,
          backspaceColor: Colors.blue,
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          recentTabBehavior: Ep.RecentTabBehavior.RECENT,
          recentsLimit: 28,
          noRecents: Text(
            K.getTranslation('no_recents'),
            style: const TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ),
          // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(),
          // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const Ep.CategoryIcons(),
          buttonMode: Ep.ButtonMode.MATERIAL,
        ),
      ),
    );
  }
}
