//@dart=2.12
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class RtcEngineManager {
  static RtcEngineManager? _instance;
  String appId = "0a3d1efd4a7d4ed4a057a0ee869cfcfb";
  Function(dynamic content)? _onJoinSucced;

  static RtcEngineManager get instance {
    _instance ??= RtcEngineManager();
    return _instance!;
  }

  RtcEngine? _engine;

  Future<void> dispose() async {
    await _engine?.leaveChannel();
    await _engine?.release();
    _engine = null;
  }

  Future<void> initEngine(RtcEngineEventHandler h) async {
    _engine = createAgoraRtcEngine();
    await _engine?.initialize(RtcEngineContext(
      appId: appId,
    ));
    _engine?.setParameters("{\"che.audio.opensl_log_level\":0}");
    _engine?.setParameters("{\"che.audio.opensl.mode\":1}");
    _engine?.setLogFilter(LogFilterType.logFilterOff);


    _engine?.registerEventHandler(h);
    await _engine?.enableAudio();
    // await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine?.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioDefault,
    );
  }
  void reNewToken(String token){
    _engine?.renewToken(token);
  }

  Future setClientRole(bool isBroadCaster) async {
    final _roleType = isBroadCaster
        ? ClientRoleType.clientRoleBroadcaster
        : ClientRoleType.clientRoleAudience;
    return await _engine?.setClientRole(role: _roleType!);
  }
  Future muteLocalAudioStream(bool mute) async {
    return await _engine?.muteLocalAudioStream(mute);
  }

  joinChannel(BuildContext context, int uid, String token, String channelId,
      ClientRoleType roleType) async {

    // if (defaultTargetPlatform == TargetPlatform.android) {
      await PermissionUtil.checkAndRequestMicrophonePermission();
    // }
    await _engine?.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          clientRoleType: roleType,
        ));
  }

  leaveChannel() async {
    await _engine?.leaveChannel();
  }

  switchMicrophone(bool enable) async {
    // await _engine?.muteLocalAudioStream(enable);
    await _engine?.enableLocalAudio(enable);
  }
}
