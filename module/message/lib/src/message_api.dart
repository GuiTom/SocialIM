import 'package:base/base.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class MessageApi{
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