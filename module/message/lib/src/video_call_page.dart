import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'locale/k.dart';
import 'message_api.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage(
      {super.key,
      required this.isVideo,
      required this.targetUid,
      this.token,
      this.channelId});

  final bool isVideo;
  final int targetUid;
  final String? token;
  final String? channelId;

  @override
  State<StatefulWidget> createState() {
    return _State();
  }

  static Future show(BuildContext context, bool isVideo, int targetUid,
      {String? token, String? channelId}) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return VideoCallPage(
            isVideo: isVideo,
            targetUid: targetUid,
            token: token,
            channelId: channelId,
          );
        });
  }
}

enum CallStatus { Connectting, Connected, Closed }

class _State extends State<VideoCallPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _cameraEnabled = true;
  bool _micphoneEnabled = true;
  String? _channelId;
  String? _token;
  bool _isVideo = false;
  late int _targetUid;
  CallStatus _callStatus = CallStatus.Connectting;

  @override
  void initState() {
    super.initState();
    _isVideo = widget.isVideo;
    _targetUid = widget.targetUid;
    if (widget.channelId != null) {
      _channelId = widget.channelId!;
    }
    _getToken();
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
    await _engine.initialize(const RtcEngineContext(
      appId: Constant.agroaAppId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        debugPrint("local user ${connection.localUid} joined");
        setState(() {
          _localUserJoined = true;
          _remoteUid = _targetUid;
        });
        if (widget.channelId == null) {
          _sendNotificationToPeer();
        }
      }, onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        debugPrint("remote user $remoteUid joined");
        setState(() {
          _remoteUid = remoteUid;
          _callStatus = CallStatus.Connected;
        });
      }, onUserOffline: (RtcConnection connection, int remoteUid,
              UserOfflineReasonType reason) {
        debugPrint("remote user $remoteUid left channel");
        _callStatus = CallStatus.Closed;
        if (remoteUid != Session.uid) {
          Navigator.pop(context);
        }
      }, onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
        debugPrint(
            '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
      }, onError: (ErrorCodeType err, String msg) {
        debugPrint(err.toString() + '---->' + msg);
        ToastUtil.showCenter(msg: msg);
      }),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    if (_isVideo) {
      await _engine.enableVideo();

      await _engine.startPreview();
    }
    if (Session.uid != _targetUid) {
      await _engine.joinChannel(
        token: _token!,
        channelId: _channelId!,
        uid: Session.uid,
        options: const ChannelMediaOptions(),
      );
    }
    _callStatus = CallStatus.Connectting;
  }

  @override
  void dispose() {
    _engine.leaveChannel(
        options: const LeaveChannelOptions(
            stopAllEffect: true,
            stopAudioMixing: true,
            stopMicrophoneRecording: true));
    _engine.release();
    super.dispose();
  }

  void _sendNotificationToPeer() {
    SocketRadio.instance.sendMessage({
      'type':
          _isVideo ? MsgType.ChatRTCVideo.index : MsgType.ChatRtcAudio.index,
      'content':
          '[${K.getTranslation(_isVideo ? 'video_call' : 'audio_call')}]',
      'extraInfo': {
        'senderName': Session.userInfo.name,
        'senderGender': Session.userInfo.sex,
        'token': _token,
        'channelId': _channelId,
      }
    }, _targetUid, TargetType.Private);
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          _remoteVideo(),
          SizedBox(
            width: 100,
            height: 150,
            child: Center(
              child: _localUserJoined
                  ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
          ),
          _buildOptionLayer(),
        ],
      ),
    );
  }

  Widget _buildOptionLayer() {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () {},
                icon: const Icon(LineIcons.smilingFaceWithHeartEyes)),
            Expanded(
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(LineIcons.smilingFaceWithHeartEyes))),
            const SizedBox(width: 100),
          ],
        ),
        if (_callStatus == CallStatus.Connectting) const Text('Connectting...'),
        if (_callStatus == CallStatus.Connected) const Text('Connected...'),
        if (_callStatus == CallStatus.Closed) const Text('Huange up...'),
        _buildIOButtons(),
        _buildBottomButtons(),
      ],
    );
  }

  Widget _buildIOButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (!_micphoneEnabled)
          IconButton(
              onPressed: () {
                _engine.muteLocalAudioStream(false);
                _micphoneEnabled = true;
                setState(() {});
              },
              icon: SvgPicture.asset(
                'assets/mic_closed.svg',
                package: 'message',
              )),
        if (_micphoneEnabled)
          IconButton(
              onPressed: () {
                _engine.muteLocalAudioStream(true);

                _micphoneEnabled = false;
                setState(() {});
              },
              icon: SvgPicture.asset(
                'assets/mic_open.svg',
                package: 'message',
              )),
        if (!_cameraEnabled)
          IconButton(
              //开启视频
              onPressed: () async {
                _engine.enableVideo();
                _engine.muteLocalVideoStream(false);
                _cameraEnabled = true;
                setState(() {});
              },
              icon: SvgPicture.asset(
                'assets/video_closed.svg',
                package: 'message',
              )),
        if (_cameraEnabled)
          IconButton(
              //关闭视频
              onPressed: () async {
                _engine.disableVideo();
                _engine.muteLocalVideoStream(true);
                _cameraEnabled = false;
                setState(() {});
              },
              icon: SvgPicture.asset(
                'assets/video_closed.svg',
                package: 'message',
              )),
      ],
    );
  }

  Widget _buildBottomButtons() {
    if (_callStatus == CallStatus.Connected) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () async {
                ToastUtil.showTop(msg: '已挂断');
                await Future.delayed(const Duration(milliseconds: 400));
                if (!mounted) return;
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icon_to_hangup.svg',
                package: 'message',
              )),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () async {
                ToastUtil.showTop(msg: '已挂断');
                await Future.delayed(const Duration(milliseconds: 400));
                if (!mounted) return;
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                'assets/icon_to_hangup.svg',
                package: 'message',
              )),
          if (Session.uid == _targetUid)
            IconButton(
                onPressed: () async {
                  //接听
                  if (Session.uid == _targetUid) {
                    await _engine.joinChannel(
                      token: _token!,
                      channelId: _channelId!,
                      uid: Session.uid,
                      options: const ChannelMediaOptions(),
                    );
                  }
                },
                icon: SvgPicture.asset(
                  'assets/icon_to_accept_call.svg',
                  package: 'message',
                )),
        ],
      );
    }
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: _channelId),
        ),
      );
    } else {
      return Center(
        child: const Text(
          'Please wait for remote user to join',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
