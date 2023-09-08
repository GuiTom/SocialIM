import 'package:base/base.dart';

import 'protobuf/generated/room.pb.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class RoomApi {
  static Future<RoomInfoResp?> reportJoinLeaveToServer(
      String action, String channelId, String roomName) async {
    RoomInfoResp resp = await Net.post(
        url: System.api('/api/room/join_leave'),
        params: {
          'action': action,
          'channelId': channelId,
          'uid': Session.uid,
          'channelName': roomName
        },
        pbMsg: RoomInfoResp.create(),
        pb: true);
    if (resp.code == 1) {
      return resp;
    } else {
      ToastUtil.showCenter(msg: resp.message);
      return null;
    }
  }

  static Future<Resp?> reportMicChangeToServer(
      int uid, int roomId, int position, ClientRoleType type) async {
    Resp resp = await Net.post(
        url: System.api('/api/room/change_mic'),
        params: {
          'uid': uid,
          'roomId': roomId,
          'position': position,
          'upMic': type == ClientRoleType.clientRoleBroadcaster ? 1 : 0
        },
        pbMsg: Resp.create(),
        pb: true);
    if (resp.code == 1) {
      return resp;
    } else {
      ToastUtil.showCenter(msg: resp.message);
      return null;
    }
  }

  static Future<RtcTokenResp?> getRoomToken(
      String channelId, int uid, ClientRoleType type) async {
    RtcTokenResp resp = await Net.post(
        url: System.api('/api/room/token'),
        params: {
          'channelId': channelId,
          'uid': uid,
          'role': type.index + 1,
        },
        pbMsg: RtcTokenResp.create(),
        pb: true);
    if (resp.code == 1) {
      return resp;
    } else {
      ToastUtil.showCenter(msg: resp.message);
      return null;
    }
  }
}
