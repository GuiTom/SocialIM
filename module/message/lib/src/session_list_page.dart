import 'package:base/src/widget/unread_dot_widget.dart';

import 'locale/k.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';

import 'chat_page.dart';
import 'model/message_session.dart';

/// 消息页
class SessionListPage extends StatefulWidget {
  final int pageIndex;

  const SessionListPage({Key? key, required this.pageIndex}) : super(key: key);

  @override
  SessionListPageState createState() => SessionListPageState();
}

class SessionListPageState extends State<SessionListPage> {
  late List<MessageSession>? _sessions;
  bool _loading = true;
  int _selectedRow = -1;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _onReceivedMessage(type, data) async {
    if (data is SocketData) {
      SocketData _data = data as SocketData;
      if (_data.targetType == TargetType.Group ||
          _data.targetType == TargetType.Private) {
        _reload();
      }
    } else if (data is MessageSession) {
      _reload();
    }
  }

  Future _initData() async {
    _loading = true;
    eventCenter.addListener('sessionCountChange', _onReceivedMessage);
    eventCenter.addListener('messageAded', _onReceivedMessage);
    _reload();
  }

  Future _reload() async {
    _sessions = (await MessageSession.sessions).sorted(
        (a, b) => (b.lastData?.createAt ?? 0) - (a.lastData?.createAt ?? 0));
    _loading = false;
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChildPageLifecycleWrapper(
        index: widget.pageIndex,
        wantKeepAlive: true,
        onLifecycleEvent: (event) {
          dog.d(event);
          if (event == LifecycleEvent.visible) {
            _initData();
          } else if (event == LifecycleEvent.invisible) {
            eventCenter.removeListener(
                'sessionCountChange', _onReceivedMessage);
            eventCenter.removeListener('messageAded', _onReceivedMessage);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF1F1F1),
          appBar: AppBar(
            // backgroundColor: Colors.transparent,
            // elevation:3,
            title: Text(
              K.getTranslation('message'),
            ),
          ),
          body: Padding(
            padding: const EdgeInsetsDirectional.only(top: 8),
            child: _buildListView(),
          ),
        ));
  }

  Widget _buildListView() {
    if (_loading) {
      return const Loading();
    }
    if (_sessions?.isEmpty ?? true) {
      return Center(
        child: Text(
          K.getTranslation('no_message_tip'),
          style: const TextStyle(color: Color(0x3F111111)),
        ),
      );
    }
    return ListView.separated(
        separatorBuilder: (BuildContext contex, int index) {
          return Container(height: 1, color: const Color(0xFFF1F1F1));
        },
        itemBuilder: (BuildContext contex, int index) {
          MessageSession messageSession = _sessions![index];
          return _buildListItem(messageSession, index);
        },
        itemCount: _sessions!.length);
  }

  Widget _buildListItem(MessageSession messageSession, int index) {
    String sessionName = messageSession.sessionName;
    int? otherUid = messageSession.targetId;

    return GestureDetector(
      onTap: () async {
        _selectedRow = index;
        setState(() {});
        await ChagePage.show(Constant.context,
            targetId: otherUid, targetName: sessionName);
        _selectedRow = -1;
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {});
        _reload();
      },
      onLongPressStart: (LongPressStartDetails details) {
        _selectedRow = index;
        setState(() {});
        _showPopupMenu(context, messageSession, details.globalPosition);
      },
      child: Container(
          color: _selectedRow == index ? const Color(0xFFE1E1E1) : Colors.white,
          height: 60,
          child: Row(
            children: [
              const SizedBox(
                width: 8,
              ),
              Stack(
                clipBehavior: Clip.none,
                alignment: AlignmentDirectional.topEnd,
                children: [
                  UserHeadWidget(
                      imageUrl: Util.getHeadIconUrl(otherUid),
                      size: 40,
                      isMale: messageSession.peerGender == 1),
                  if (messageSession.unReadCount > 0)
                    PositionedDirectional(
                      top: -5,
                      end: -5,
                      child: UnReadDotWidget(count: messageSession.unReadCount),
                    )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.only(start: 12, top: 8),
                      child: Text(sessionName),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        if (messageSession.targetType != TargetType.Private)
                          Text('[${K.getTranslation('message_count', args: [
                                messageSession.msgCount
                              ])}]${messageSession.sessionName}:'),
                        Text(messageSession.lastData?.message.content ?? ''),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (messageSession.lastData != null)
                Align(
                  alignment: AlignmentDirectional.topCenter,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(top: 8, end: 12),
                    child: Text(
                      TimeUtil.translatedTimeStr(
                        messageSession.lastData!.createAt.toInt(),
                      ),
                      style: const TextStyle(
                          color: Color(0xFFA1A1A1), fontSize: 12),
                    ),
                  ),
                ),
            ],
          )),
    );
  }

  void _showPopupMenu(
      BuildContext context, MessageSession session, Offset offset) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromSize(
      Rect.fromLTWH(offset.dx, offset.dy, offset.dx, overlay.size.height),
      overlay.size,
    );
    // 弹出菜单
    showMenu<String>(
      context: context,
      position: position,
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '1',
          child: Text(K.getTranslation('delete_session')),
        ),
      ],
    ).then((String? value) async {
      if (value != null) {
        _sessions?.remove(session);
        MessageSession.deleteSession(session.sessionId);
      }
      _selectedRow = -1;
      setState(() {});
    });
  }
}
