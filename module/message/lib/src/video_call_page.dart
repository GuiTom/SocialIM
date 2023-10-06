import 'dart:async';

import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'locale/k.dart';
import 'model/message_session.dart';
import 'rtc_api.dart';
import 'message_api.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage(
      {super.key,
      required this.isVideo,
      required this.targetUid,
      this.token,
      this.channelId,
      required this.messageId,
      this.socketData, required this.targetName});

  final bool isVideo;
  final int targetUid;
  final String targetName;
  final String? token;
  final String? channelId;
  final int messageId;
  final SocketData? socketData;

  @override
  State<StatefulWidget> createState() {
    return _State();
  }

  static Future show(BuildContext context, bool isVideo, int targetUid,
      int messageId, String targetName,
      {String? channelId, SocketData? socketData}) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return VideoCallPage(
            isVideo: isVideo,
            targetUid: targetUid,
            channelId: channelId,
            messageId: messageId,
            socketData: socketData, targetName: targetName,
          );
        });
  }
}

enum CallStatus { Calling, Connectting, Connected, Closed }

class _State extends State<VideoCallPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  RtcEngine? _engine;
  bool _cameraEnabled = true;
  bool _micphoneEnabled = true;

  bool _remoteVideoIsOn = true;
  int _messageId = 0;
  String? _channelId;
  String? _token;
  bool _isVideo = false;
  late int _targetUid;
  CallStatus _callStatus = CallStatus.Calling;
  Offset _remoteVideoOffset = const Offset(20.0, 60.0);
  @override
  void initState() {
    super.initState();
    eventCenter.addListener('HandshakeChangeMessageReceived', _messageReceived);
    _isVideo = widget.isVideo;
    _targetUid = widget.targetUid;
    _messageId = widget.messageId;
    if (widget.channelId != null) {
      _channelId = widget.channelId!;
    }
    _getToken();
  }

  void _messageReceived(String type, Object data) async {
    SocketData _data = (data as List).first;
    SocketData _primaryData = (data as List).last;
    if (_data.contentType == MsgContentType.ChatRtcHandshakeChange) {
      if (!mounted) return;
      if (_data.message.extraInfo['handshakeStatus'] == 'rejected') {
        if (_data.targetId == Session.uid) {
          ToastUtil.showCenter(msg: K.getTranslation('the_peer_rejected'));
        } else {
          ToastUtil.showCenter(msg: K.getTranslation('rejected'));
        }
      } else if (_data.message.extraInfo['handshakeStatus'] == 'canceled') {
        ToastUtil.showCenter(msg: K.getTranslation('canceled'));
      } else if (_data.message.extraInfo['handshakeStatus'] == 'timeout') {
        ToastUtil.showCenter(msg: K.getTranslation('no_answer'));
      } else if (_data.message.extraInfo['handshakeStatus'] == 'finished') {
        ToastUtil.showCenter(msg: K.getTranslation('session_ended'));
      }
      if (!(_data.message.extraInfo['handshakeStatus'] == 'timeout'&&!_primaryData.sendBySelf)) {
        MessageSession session = (await MessageSession.getSession(
            targetType: _primaryData.targetType,
            targetId: _targetUid,
            sessionName: _primaryData.sessionName,
            sessionId: _primaryData.sessionId ?? ''));
        session.setMessageReadStatus([_primaryData]);
      }
      await _engine!.leaveChannel();
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future _getToken() async {
    _channelId ??= ''.generateRandomString(5);
    RtcTokenResp? resp = await MessageApi.getRoomToken(
        _channelId!, Session.uid, ClientRoleType.clientRoleBroadcaster);
    if (resp?.code == 1 ?? false) {
      _token = resp!.token;
      initAgora();
    }
    return null;
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: Constant.agroaAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          _localUserJoined = true;
          _remoteUid = _targetUid;
          if (!isCaller) {
            _callStatus = CallStatus.Connected;
          }
        });
        if (widget.channelId == null) {
          _messageId = await RtcApi.sendNotificationCallPeer(
              _targetUid, _isVideo, _token ?? '', _channelId!);
        }
      }, onRejoinChannelSuccess: (RtcConnection connection, int elapsed) async {
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          _localUserJoined = true;
          _remoteUid = _targetUid;
          if (!isCaller) {
            _callStatus = CallStatus.Connected;
          }
        });
        if (widget.channelId == null) {
          _messageId = await RtcApi.sendNotificationCallPeer(
              _targetUid, _isVideo, _token ?? '', _channelId!);
        }
      }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        setState(() {
          _remoteUid = remoteUid;
          _callStatus = CallStatus.Connected;
        });
        _startTimeCount();
      }, onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
        debugPrint("remote user $remoteUid left channel");
        _callStatus = CallStatus.Closed;
        if (remoteUid != Session.uid) {
          Navigator.pop(context);
        }
        _stopTimeCount();
      }, onRemoteVideoStateChanged: (RtcConnection connection,
              int remoteUid,
              RemoteVideoState state,
              RemoteVideoStateReason reason,
              int elapsed) {
        _remoteVideoIsOn = state != RemoteVideoState.remoteVideoStateStopped;
        dog.d(reason);
      }, onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        debugPrint(
            '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
      }, onError: (ErrorCodeType err, String msg) {
        debugPrint('$err---->$msg');
        ToastUtil.showCenter(msg: msg);
      }),
    );

    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    if (_isVideo) {
      await _engine!.enableVideo();

      await _engine!.startPreview();
    }
    if (isCaller) {
      //是主叫方
      await _engine!.joinChannel(
        token: _token!,
        channelId: _channelId!,
        uid: Session.uid,
        options: const ChannelMediaOptions(),
      );
    }
    setState(() {});
  }

  bool get isCaller {
    return widget.channelId == null;
  }

  @override
  void dispose() {
    _engine!.release();
    _stopTimeCount();
    eventCenter.removeListener(
        'HandshakeChangeMessageReceived', _messageReceived);
    super.dispose();
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF313131),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (_remoteUid != null && _remoteVideoIsOn) _remoteVideo(),
          if (_callStatus == CallStatus.Calling &&
              _cameraEnabled &&
              _engine != null)
            _localVideo(),
          if (!_remoteVideoIsOn) Container(color: const Color(0xFF313131)),
          if (_cameraEnabled &&
              _localUserJoined &&
              _callStatus == CallStatus.Connected)
            PositionedDirectional(
              start: _remoteVideoOffset.dx,
              top: _remoteVideoOffset.dy,
              child: Draggable(
                feedback:Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue.withOpacity(0.5),
                  ),
                ) ,
                onDragUpdate: (DragUpdateDetails details){
                  _remoteVideoOffset = details.delta;
                  setState(() {
                  });
                },
                onDragEnd: (DraggableDetails details){
                  _remoteVideoOffset = details.offset;
                  setState(() {
                  });
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 100,
                    height: 150,
                    child: Center(
                      child: AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine!,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ),
          _buildPeerAvatarWidget(),
          _buildOptionLayer(),
        ],
      ),
    );
  }

  Widget _buildPeerAvatarWidget() {
    return PositionedDirectional(
      top: 100,
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: Column(
          children: [
            UserHeadWidget(
                imageUrl: Util.getHeadIconUrl(widget.targetUid.toInt()), size: 100),
            const SizedBox(height: 12,),
            Text(widget.targetName,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionLayer() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more)),
            const Spacer(),
            Text(
              _timerText ?? '',
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            const SizedBox(width: 50),
          ],
        ),
        const Spacer(),
        if (_callStatus == CallStatus.Calling)
          Text(
            K.getTranslation('calling...'),
            style: const TextStyle(color: Colors.white),
          ),
        if (_callStatus == CallStatus.Connectting)
          Text(
            K.getTranslation('connectting...'),
            style: const TextStyle(color: Colors.white),
          ),
        if (_callStatus == CallStatus.Connected)
          Text(
            K.getTranslation('connected'),
            style: const TextStyle(color: Colors.white),
          ),
        if (_callStatus == CallStatus.Closed)
          Text(
            K.getTranslation('hang_up'),
            style: const TextStyle(color: Colors.white),
          ),
        _buildIOButtons(),
        const SizedBox(
          height: 30,
        ),
        _buildBottomButtons(),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  Widget _buildIOButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!_micphoneEnabled)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    _engine!.muteLocalAudioStream(true);
                    _micphoneEnabled = true;
                    setState(() {});
                  },
                  icon: SvgPicture.asset(
                    'assets/mic_closed.svg',
                    package: 'message',
                  )),
              Text(
                K.getTranslation('micphone_closed'),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        if (_micphoneEnabled)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    _engine!.muteLocalAudioStream(true);
                    _micphoneEnabled = false;
                    setState(() {});
                  },
                  icon: Image.asset(
                    'assets/mic_open.png',
                    package: 'message',
                  )),
              Text(
                K.getTranslation('micphone_open'),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        if (!_cameraEnabled)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                //关闭视频
                onPressed: () async {
                  // _engine.disableVideo();
                  _engine!.muteLocalVideoStream(false);
                  _cameraEnabled = true;
                  _engine!.startPreview();
                  setState(() {});
                },
                icon: SvgPicture.asset(
                  'assets/icon_video_closed.svg',
                  package: 'message',
                ),
              ),
              Text(
                K.getTranslation('camera_open'),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        if (_cameraEnabled)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                //关闭视频
                onPressed: () async {
                  _engine!.muteLocalVideoStream(true);
                  _engine!.stopPreview();
                  _cameraEnabled = false;
                  setState(() {});
                },
                icon: SvgPicture.asset(
                  'assets/icon_video_open.svg',
                  package: 'message',
                ),
              ),
              Text(
                K.getTranslation('camera_open'),
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildBottomButtons() {
    if (_callStatus == CallStatus.Connected || isCaller) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () async {
                if (_callStatus == CallStatus.Connected) {
                  //挂断
                  ToastUtil.showTop(msg: K.getTranslation('already_hang_up'));
                  RtcApi.sendNotificationHangup(
                      _targetUid, _timer?.tick ?? 0, _messageId);
                  MessageSession session = (await MessageSession.getSession(
                      targetType: widget.socketData!.targetType,
                      targetId: _targetUid,
                      sessionName: widget.socketData!.sessionName,
                      sessionId: widget.socketData!.sessionId ?? ''));
                  session.setMessageReadStatus([widget.socketData!]);
                } else if (isCaller) {
                  ToastUtil.showTop(msg: K.getTranslation('canceled'));
                  RtcApi.sendNotificationCancelToPeer(_targetUid, _messageId);
                }
                await _engine!.leaveChannel();
                await Future.delayed(const Duration(milliseconds: 400));
                if (!mounted) return;
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icon_to_hangup.svg',
                package: 'message',
                color: Colors.red,
              )),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () async {
                ToastUtil.showTop(msg: K.getTranslation('rejected'));
                RtcApi.sendNotificationRejectPeer(_targetUid, _messageId);
                MessageSession session = (await MessageSession.getSession(
                    targetType: widget.socketData!.targetType,
                    targetId: _targetUid,
                    sessionName: widget.socketData!.sessionName,
                    sessionId: widget.socketData!.sessionId ?? ''));
                session.setMessageReadStatus([widget.socketData!]);
                await Future.delayed(const Duration(milliseconds: 400));
                if (!mounted) return;
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icon_to_hangup.svg',
                package: 'message',
                color: Colors.red,
              )),
          if (!isCaller)
            IconButton(
                onPressed: () async {
                  //接听
                  await _engine!.joinChannel(
                    token: _token!,
                    channelId: _channelId!,
                    uid: Session.uid,
                    options: const ChannelMediaOptions(),
                  );
                },
                icon: SvgPicture.asset(
                  'assets/icon_to_accept_call.svg',
                  package: 'message',
                  color: Colors.green,
                )),
        ],
      );
    }
  }

  // Display remote user's video
  Widget _remoteVideo() {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: _remoteUid),
        connection: RtcConnection(channelId: _channelId),
      ),
    );
  }

  Widget _localVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Timer? _timer;
  String? _timerText;

  void _startTimeCount() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timerText =
          '${(timer.tick ~/ 60).toString().padLeft(2, '0')}:${(timer.tick % 60).toString().padLeft(2, '0')}';
      if (timer.tick >= 60) {
        //挂断
        if (!mounted) return;
        RtcApi.sendNotificationTimeoutToPeer(
            _targetUid, timer.tick, _messageId);
        Navigator.pop(context);
        return;
      }
      setState(() {});
    });
  }

  void _stopTimeCount() {
    _timer?.cancel();
    _timerText = null;
    // setState(() {});
  }
}
