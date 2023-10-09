import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../model/message_session.dart';
import 'message_item_widget.dart';
import 'package:base/src/widget/image_viewer.dart';

class MessageListWidget extends StatefulWidget {
  const MessageListWidget({Key? key, required this.messgageSession,required this.messages,required this.onScrollToTop, required this.targetName})
      : super(key: key);
  final void Function() onScrollToTop;
  final MessageSession messgageSession;
  final List<SocketData> messages;
  final String targetName;
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MessageListWidget> {
  final AudioPlayer _mPlayer = AudioPlayer();
  int _playingIndex = -1;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
    _mPlayer.setReleaseMode(ReleaseMode.stop);
    _mPlayer.onPlayerComplete.listen((value) {
      _playingIndex = -1;
      setState(() {});
    });
    _controller.addListener(() {
      // dog.d('_controller.position:${_controller.offset}');
      if(_controller.offset==0.0){
        widget.onScrollToTop.call();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _mPlayer.stop();
    _mPlayer.dispose();
  }

  @override
  void didUpdateWidget(covariant MessageListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });
  }

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return _renderMessageList();
  }

  Widget _renderMessageList() {

    return Expanded(
      child: ListView.separated(
          controller: _controller,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemBuilder: (BuildContext contex, int index) {
            return ChatMessageItem(
              data: widget.messages[index],
              audiolayer: _mPlayer,
              listIndex: index,
              playingIndex: _playingIndex,
              targetName: widget.targetName,
              onPlayerStatusChange: (int idx) {
                _playingIndex = idx;
                setState(() {});
              },
              onTap: () {
                if (widget.messages[index].contentType == MsgContentType.ChatImage) {
                  _onTapedImageItem(index);
                  if(widget.messages[index].srcUid!=Session.uid) {
                    widget.messgageSession.setMessageReadStatus(
                        [widget.messages[index]]);
                  }
                  setState(() {});
                } else if (widget.messages[index].contentType ==
                    MsgContentType.ChatAudio) {
                  _onTapedAudioItem(index);
                  if(widget.messages[index].srcUid!=Session.uid) {
                    widget.messgageSession.setMessageReadStatus(
                        [widget.messages[index]]);
                  }
                  setState(() {});
                }
              },
            );
          },
          separatorBuilder: (BuildContext contex, int index) {
            return const SizedBox(height: 10);
          },
          itemCount: widget.messages.length),
    );
  }

  _onTapedImageItem(int index) {
    int initIndex = 0;
    List<String> imageUrls = widget.messages
        .where((element) => element.contentType == MsgContentType.ChatImage)
        .mapIndexed((idx, e) {
      if (widget.messages[index].message.extraInfo['filePath'] ==
          e.message.extraInfo['filePath']) {
        initIndex = idx;
      }
      return System.file('/file/${e.message.extraInfo['filePath']}');
    }).toList();
    ImageViewer.show(context, imageUrls: imageUrls, initIndex: initIndex);
  }

  _onTapedAudioItem(int index) {}
}
