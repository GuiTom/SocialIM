import 'dart:async';
import 'dart:io';

import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:message/src/model/message_session.dart';
import 'package:message/src/util/DatabaseHelper.dart';
import '../video_call_page.dart';
import 'chat_audio.dart';
import 'chat_bubble.dart';
import '../locale/k.dart';
import 'package:base/src/locale/k.dart' as BaseK;

import 'chat_rtc_bubble.dart';

enum MenuId {
  resend,
  delete,
}

class ItemModel {
  String title;
  IconData icon;
  MenuId id;

  ItemModel(this.id, this.title, this.icon);
}

class ChatMessageItem extends StatefulWidget {
  final SocketData data;
  final AudioPlayer audiolayer;
  final void Function(int) onPlayerStatusChange;
  final int listIndex;
  final int playingIndex;
  final GestureTapCallback? onTap;
  final String targetName;

  const ChatMessageItem(
      {Key? key,
      required this.data,
      required this.audiolayer,
      required this.onPlayerStatusChange,
      required this.playingIndex,
      required this.listIndex,
      required this.onTap,
      required this.targetName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ChatMessageItem> {
  final CustomPopupMenuController _popUpMenuController =
      CustomPopupMenuController();

  @override
  void initState() {
    super.initState();
    _checkTimeOut();
  }

  void _checkTimeOut() {
    // dog.d('widget.data:${widget.data}');
    if (widget.data.sendBySelf && widget.data.status == Status.sending) {
      // dog.d('widget.data.self:${widget.data}');
      Future.delayed(const Duration(seconds: 10), () {
        if (widget.data.status == Status.sending) {
          widget.data.status = Status.timeOut;
          DatabaseHelper.instance
              .updateMessage(widget.data, {'status': Status.timeOut.index});
          if (!mounted) return;
          setState(() {});
        }
      });
    }
  }

  List<ItemModel> get menuItems {
    return [
      // ItemModel('复制', Icons.content_copy),
      // ItemModel('转发', Icons.send),
      if (widget.data.sendBySelf && widget.data.status == Status.timeOut)
        ItemModel(MenuId.resend, K.getTranslation('resend'), Icons.send),
      // ItemModel('收藏', Icons.collections),
      ItemModel(MenuId.delete, BaseK.K.getTranslation('delete'), Icons.delete),
      // ItemModel('多选', Icons.playlist_add_check),
      // ItemModel('引用', Icons.format_quote),
      // ItemModel('提醒', Icons.add_alert),
      // ItemModel('搜一搜', Icons.search),
    ];
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;
    bool isLeft = Session.uid != widget.data.srcUid;
    if (widget.data.contentType == MsgContentType.ChatText) {
      child = ChatBubble(isLeft: isLeft, text: widget.data.message.content);
    } else if (widget.data.contentType == MsgContentType.ChatImage) {
      if (!widget.data.sendBySelf) {
        //图像上传完毕
        String imageUrl =
            System.file('/file/${widget.data.message.extraInfo['filePath']}');
        int cachedWidth =
            widget.data.message.extraInfo['imageWidth'] ?? Util.width / 4;
        int cachedHeight = widget.data.message.extraInfo['imageHeight'] ?? 0.0;
        double imageWidth = cachedWidth.toDouble();

        double imageHeight = cachedHeight.toDouble();
        if (imageWidth > Util.width / 4) {
          imageHeight = imageHeight * (Util.width / 4) / imageWidth;
          imageWidth = Util.width / 4;
        }

        child = ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            width: imageWidth,
            height: imageHeight,
            memCacheWidth: imageWidth.toInt(),
            memCacheHeight: imageHeight.toInt(),
            fit: BoxFit.fitWidth,
            placeholder: (
              BuildContext context,
              String url,
            ) =>
                CupertinoActivityIndicator(
                    radius: imageWidth * 0.5, color: Colors.white),
          ),
        );
      } else if (widget.data.message.extraInfo['localPath'] != null) {
        //图像正在上传
        String localPath = widget.data.message.extraInfo['localPath'];
        int cachedWidth =
            widget.data.message.extraInfo['imageWidth'] ?? Util.width / 4;

        int cachedHeight = widget.data.message.extraInfo['imageHeight'] ?? 0.0;
        double imageWidth = cachedWidth.toDouble();
        double imageHeight = cachedHeight.toDouble();
        if (imageWidth > Util.width / 4) {
          imageHeight = imageHeight * (Util.width / 4) / imageWidth;
          imageWidth = Util.width / 4;
        }
        child = ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Image.file(
                File(localPath),
                width: imageWidth,
                height: imageHeight,
              ),
              if (widget.data.message.extraInfo['filePath'] == null)
                CupertinoActivityIndicator(
                    radius: imageWidth * 0.5, color: Colors.white),
            ],
          ),
        );
      }else {
        child = Container();
      }
    } else if (widget.data.contentType == MsgContentType.ChatAudio) {
      child = ChatAudio(
        isLeft: isLeft,
        isPlaying: widget.playingIndex == widget.listIndex,
        durationInMillseconds: widget.data.message.extraInfo['duration'],
      );
    } else if (widget.data.contentType == MsgContentType.ChatRtcAudio) {
      child = ChatBubble(isLeft: isLeft, text: widget.data.message.content);
    } else if (widget.data.contentType == MsgContentType.ChatRTCVideo) {
      child = ChatRtcBubble(isLeft: isLeft, data: widget.data);
    } else {
      child = const SizedBox(
        width: 200,
        height: 100,
      );
    }

    child = GestureDetector(
      onTap: () {
        if (widget.data.contentType == MsgContentType.ChatAudio) {
          _handelTapAudio();
        } else if (widget.data.contentType == MsgContentType.ChatRTCVideo ||
            widget.data.contentType == MsgContentType.ChatRtcAudio) {
          VideoCallPage.show(
              context,
              true,
              widget.data.sendBySelf
                  ? widget.data.targetId
                  : widget.data.srcUid,
              0,
              widget.data.targetId == Session.uid
                  ? widget.data.message.extraInfo['senderName']
                  : widget.targetName);
        }
        widget.onTap?.call();
      },
      child: child,
    );

    child = CustomPopupMenu(
      menuBuilder: _buildLongPressMenu,
      pressType: PressType.longPress,
      controller: _popUpMenuController,
      child: child,
    );
    if (widget.data.contentType == MsgContentType.ChatText ||
        widget.data.contentType == MsgContentType.ChatAudio) {
      child = Flexible(child: child);
    }
    List<Widget> children = [
      UserHeadWidget(
        imageUrl: Util.getHeadIconUrl(widget.data.srcUid),
        uid: widget.data.srcUid,
        size: 40,
        isMale: widget.data.peerGender == 1 ||
            (widget.data.sendBySelf && Session.userInfo.sex == 1),
      ),
      const SizedBox(
        width: 12,
      ),
      child,
      const SizedBox(
        width: 6,
      ),
      if ((widget.data.contentType == MsgContentType.ChatAudio ||
              widget.data.contentType == MsgContentType.ChatRTCVideo ||
              widget.data.contentType == MsgContentType.ChatRtcAudio) &&
          !widget.data.read &&
          !widget.data.sendBySelf)
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 20),
          child: _buildUnReadFlagWidget(),
        ),
      if (widget.data.status == Status.sending &&
          widget.data.sendBySelf) //表示正在发送的loading
        Container(
          padding: const EdgeInsetsDirectional.only(top: 20),
          width: 20,
          height: 20,
          child: const CupertinoActivityIndicator(
            radius: 10,
            color: Colors.grey,
          ),
        ),
      if (widget.data.status == Status.timeOut && widget.data.sendBySelf) //已经超时
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 20),
          child: Image.asset(
            'assets/icon_message_timeout.png',
            package: 'message',
            width: 24,
            height: 24,
          ),
        ),
    ];
    return Row(
      mainAxisAlignment:
          isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isLeft ? children : children.reversed.toList(),
    );
  }

  Widget _buildUnReadFlagWidget() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.red),
    );
  }

  Future _handelTapAudio() async {
    if (widget.listIndex != widget.playingIndex) {
      String audioUrl =
          System.file('/file/${widget.data.message.extraInfo['filePath']}');
      await widget.audiolayer.play(UrlSource(audioUrl));
      widget.onPlayerStatusChange.call(widget.listIndex);
    } else {
      await widget.audiolayer.stop();
      widget.onPlayerStatusChange.call(-1);
    }
  }

  Widget _buildLongPressMenu() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 50 * (menuItems.length > 5 ? 5 : menuItems.length).toDouble(),
        color: const Color(0xFF4C4C4C),
        child: GridView.count(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 5, vertical: 10),
          crossAxisCount: menuItems.length > 5 ? 5 : menuItems.length,
          crossAxisSpacing: 0,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: menuItems
              .map((item) => GestureDetector(
                    onTap: () async {
                      if (item.id == MenuId.resend) {
                        //再次发送
                        SocketRadio.instance.reSendMessage(widget.data);
                      } else if (item.id == MenuId.delete) {
                        (await MessageSession.getSession(
                                targetType: widget.data.targetType,
                                targetId: widget.data.targetId,
                                sessionName: widget.data.sessionName,
                                sessionId: widget.data.sessionId))
                            .deleteMessage(widget.data);
                        eventCenter.emit('messageDeleted');
                      }
                      _popUpMenuController.hideMenu();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 20,
                          color: Colors.white,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: Text(
                            item.title,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
