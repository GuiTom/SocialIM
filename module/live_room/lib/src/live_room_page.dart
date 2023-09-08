import 'package:base/base.dart';
import 'package:live_room/src/protobuf/generated/room.pb.dart';
import 'package:live_room/src/rtc_engine_manager.dart';
import 'package:live_room/src/widget/live_room_input_bar.dart';
import 'package:live_room/src/widget/message_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'room_api.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'locale/k.dart';
class LiveRoomPage extends StatefulWidget {
  const LiveRoomPage(
      {Key? key,
      required this.roomId,
      required this.channelId,
      required this.uid,
      required this.roomName,
      required this.token})
      : super(key: key);
  final String channelId;
  final int roomId; //数据库的ID,与声网无关
  final int uid;
  final String roomName;
  final String token;

  static Future show(BuildContext context,
      {required int roomId,
      required String roomName,
      required String channelId,
      required token,
      required int uid}) {
    return Navigator.of(context).push(MaterialPageRoute<bool>(
      builder: (context) => LiveRoomPage(
        roomId: roomId,
        channelId: channelId,
        roomName: roomName,
        uid: uid,
        token: token,
      ),
      settings: const RouteSettings(name: '/LiveRoomPage'),
    ));
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class UserInfo {
  final String name;
  final int uid;
  final int level;
  final int sex;
  int position;

  @override
  String toString() {
    return 'UserInfo{name: $name, uid: $uid, level: $level, sex: $sex, position: $position}';
  }

  UserInfo(
      {required this.name,
      required this.uid,
      required this.level,
      required this.sex,
      required this.position});

  factory UserInfo.fromJson(Map<String, dynamic> map) {
    return UserInfo(
        name: map['name'] ?? '',
        uid: map['uid'] ?? 0,
        sex: map['sex'] ?? 0,
        level: map['level'] ?? 0,
        position: map['position'] ?? 0);
  }
}

class _State extends State<LiveRoomPage> {
  bool _loading = true;
  int _roomId = 0;

  ClientRoleType _currentRole = ClientRoleType.clientRoleAudience;

  List<UserInfo> _users = [];
  final GlobalKey<MessageListState> _messageListStateKey =
      GlobalKey<MessageListState>();
  String? _token;
  int _micPosition = 0;
  RoomInfo? _roomInfo;

  @override
  void initState() {
    super.initState();
    _roomId = widget.roomId;

    eventCenter.addListener("socket_message", _onReceivedMessage);
    _token = widget.token;
    _initEngine();
  }

  void _onReceivedMessage(String type, Object data) {
    SocketData _data = data as SocketData;
    if (_data.targetType == TargetType.LiveRoom &&
        (_data.message.type == MsgType.ChatText ||
            _data.message.type == MsgType.MemberEnterExit)) {
      _messageListStateKey.currentState?.pushMessage(_data);
    }
    if (_data.message.type == MsgType.MemberEnterExit) {
      String action = _data.message.extraInfo['action'];
      int uid = TypeUtil.parseInt(_data.message.extraInfo['uid']);
      if (action == 'join') {
        UserInfo? user =
            _users.firstWhereOrNull((element) => element.uid == uid);
        if (user == null) {
          _users.add(UserInfo.fromJson(_data.message.extraInfo));
        }
        dog.d('_users0:$_users $uid');
      } else if (action == 'leave') {
        dog.d('_users:$_users $uid');
        _users.removeWhere((element) => element.uid == uid);
        dog.d('_users2:$_users');
      }
      setState(() {});
    }
    if (_data.message.type == MsgType.MemberStatusChange) {
      String action = _data.message.extraInfo['action'];
      int uid = TypeUtil.parseInt(_data.message.extraInfo['uid']);
      if (action == 'upMic' || action == 'downMic') {
        int position = TypeUtil.parseInt(_data.message.extraInfo['position']);
        dog.d('_users3:$_users');
        _users.firstWhereOrNull((element) => element.uid == uid)?.position =
            position;
        setState(() {});
        dog.d('_users4:$_users');
      }
    }
  }

  Future<void> _initEngine() async {
    await RtcEngineManager.instance.initEngine(RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
      ToastUtil.showCenter(msg: '$err:$msg');
    }, onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
      //加入房间,
      RoomInfoResp? resp = await RoomApi.reportJoinLeaveToServer(
          'join', connection.channelId ?? widget.channelId, widget.roomName);
      if (resp != null) {
        _roomId = resp.data.roomId;
        _users =
            TypeUtil.parseList(resp.data.users, (e) => UserInfo.fromJson(e));
        _loading = false;
        _roomInfo = resp.data;
        setState(() {});
      }
    }, onLeaveChannel: (RtcConnection connection, RtcStats stats) async {
      //离开房间
      RoomInfoResp? resp = await RoomApi.reportJoinLeaveToServer(
          'leave', connection.channelId ?? widget.channelId, widget.roomName);
      if (resp != null) {
        ToastUtil.showCenter(msg: resp.message);
        if (!mounted) return;
        Navigator.pop(context);
      }
    }, onTokenPrivilegeWillExpire:
            (RtcConnection connection, String token) async {
      //token要过期
      RtcTokenResp? resp = await RoomApi.getRoomToken(
          connection.channelId ?? widget.channelId, Session.uid, _currentRole);
      if (resp != null) {
        RtcEngineManager.instance.reNewToken(token);
        if (Constant.isDebug) {
          ToastUtil.showCenter(msg: 'token已经更换');
        }
      }
    }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
      //有人加入
      if (Constant.isDebug) {
        ToastUtil.showCenter(msg: '$remoteUid加入房间');
      }
    }, onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
      //有人退出
      if (_roomInfo?.creatorUid == remoteUid) {
        Navigator.pop(context);
        ToastUtil.showCenter(msg: K.getTranslation('room_closed'));
      } else {
        if (Constant.isDebug) {
          ToastUtil.showCenter(msg: '$remoteUid离开房间');
        }
      }
    }, onClientRoleChangeFailed: (RtcConnection connection,
            ClientRoleChangeFailedReason reason, ClientRoleType currentRole) {
      ToastUtil.showCenter(msg: '切换role${currentRole.name} 失败$reason');
    }, onClientRoleChanged: (RtcConnection connection, ClientRoleType oldRole,
            ClientRoleType newRole, ClientRoleOptions newRoleOptions) async {
      //上下麦
      if (newRole == ClientRoleType.clientRoleAudience) {
        _micPosition = -1;
      }

      RtcEngineManager.instance.muteLocalAudioStream(
          newRole != ClientRoleType.clientRoleBroadcaster);
      if (_currentRole != newRole) {
        Resp? resp = await RoomApi.reportMicChangeToServer(
            Session.uid, _roomId, _micPosition, newRole);
        if (resp != null) {
          _users.firstWhereOrNull((element) {
            if (element.uid == Session.uid) {
              element.position = _micPosition;
              return true;
            }
            return false;
          });
          setState(() {});
        }
      }
      // _formalRole = newRole;
      _currentRole = newRole;
    }));
    _joinChannel();
  }

  void _joinChannel() {
    if (!mounted) return;
    final role = _roomId == 0
        ? ClientRoleType.clientRoleBroadcaster
        : ClientRoleType.clientRoleAudience;
    // _formalRole = role;
    _currentRole = role;
    RtcEngineManager.instance.joinChannel(
      context,
      Session.uid,
      _token!,
      widget.channelId,
      role!,
    );
  }

  @override
  void dispose() {
    super.dispose();
    eventCenter.removeListener("socket_message", _onReceivedMessage);
    // SocketRadio.instance.disconnect();

    RtcEngineManager.instance.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.roomName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          body: SafeArea(
            child: GestureDetector(onTap: (){
              FocusScope.of(context).unfocus();
            }, child: _buildBody()),
          ),
        ),
        onWillPop: () async {
          Navigator.pop(context, true);
          return true;
        });
  }

  Widget _buildBody() {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(color: Colors.black),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // _buildCreatorWidget(),
            const SizedBox(height: 15),
            _buildOtherUserWidget(),
            const Spacer(),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MessageListWidget(key: _messageListStateKey, messages: []),
            LiveRoomInputBar(
                targetId: _roomId, targetType: TargetType.LiveRoom),
          ],
        ),
        if (_loading) const Loading(),
      ],
    );
  }

  Widget _buildOtherUserWidget() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Wrap(
          spacing: 30,
          runSpacing: 20,
          children: List.generate(
            8,
            (index) {
              UserInfo? user = _users
                  .firstWhereOrNull((element) => element.position == index);
              return user != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ThrottleTapDetector(
                            onTap: () {
                              // if(user!.uid!=Session.uid) return;
                              _changeMic(user!.uid, index, false);
                            },
                            child: UserHeadWidget(
                              imageUrl: Util.getHeadIconUrl(widget.uid),
                              size: 50,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 20,
                          child: Text(
                            user!.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ThrottleTapDetector(
                            onTap: () {
                              if (_currentRole ==
                                  ClientRoleType.clientRoleBroadcaster) {
                                ToastUtil.showCenter(msg: K.getTranslation('at_mic_tip'));
                                return;
                              }
                              _changeMic(Session.uid, index, true);
                            },
                            child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.3),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.white.withOpacity(0.06)),
                                ),
                                alignment: AlignmentDirectional.center,
                                child: SvgPicture.asset('assets/empty_join.svg',
                                    width: 24,
                                    height: 24,
                                    package: 'live_room'))),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    );
            },
          )),
    );
  }

  void _changeMic(int uid, int position, bool isUp) async {
    if(!isUp) {
      final result = await showModalActionSheet<String>(
        context: context,
        message: '您当前在麦上',
        actions: [
          const SheetAction(
            label: '下麦',
            key: 'downMic',
          ),
          const SheetAction(
            label: '取消',
            key: 'cancelKey',
          ),
        ],
      );
      if(result=='cancelKey'){
        return;
      }
    }
    _micPosition = position;
    RtcEngineManager.instance.setClientRole(isUp);
  }
}
