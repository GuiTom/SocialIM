import 'package:base/base.dart';

class PayAPI {
  static Future<Resp?> iosVerify(
      String receipt, String originalTransactionId, String productId) async {
    Map<String, dynamic> params = {
      'uid':Session.uid,
      'receipt': receipt,
      'originalTransactionId': originalTransactionId,
      'productId': productId
    };

    Resp resp = await Net.post(
        url: System.api("/api/pay/ios_verify"),
        pb: true,
        params: params,
        pbMsg: Resp.create());
    if (resp.code == 1) {
      return resp;
    } else {
      ToastUtil.showCenter(msg: resp.message);
    }
    return null;
  }
}
