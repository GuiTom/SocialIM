import 'package:base/base.dart';

class ConfigApi{
  static Future<GlobalConfigInfoResp> getGlobalConfig(
      ) async {
    return Net.post(url: System.api('/api/config'),
        pb: true,
        params: {},
        pbMsg: GlobalConfigInfoResp.create());
  }
}