import 'package:base/base.dart';

class BootApi {
  static Future<Resp?> reportPushToken(String token) async {
    if (Session.uid == 0) return null;
    return Net.post(
        url: System.api('/api/user/reportPushToken'),
        pb: true,
        params: {
          'uid': Session.uid,
          'token': token,
        },
        pbMsg: Resp.create());
  }
}
