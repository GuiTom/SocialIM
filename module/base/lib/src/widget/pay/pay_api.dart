import 'package:base/base.dart';

import '../../protobuf/generated/iap_product.pb.dart';

class PayAPI {
  static Future<IapProductListResp?> getIapProducts(String source) async {
    Map<String, dynamic> params = {
      'source':source
    };
    IapProductListResp resp = await Net.post(
        url: System.api("/api/pay/getIapProducts"),
        pb: true,
        params: params,
        pbMsg: IapProductListResp.create());
    if (resp.code == 1) {
      return resp;
    } else {
      ToastUtil.showCenter(msg: resp.message);
    }
    return null;
  }
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
  static Future<Resp?> googlePlayVerify(
  {required String package,required String orderId, required String productId,required String purchaseToken}) async {
    Map<String, dynamic> params = {
      'uid':Session.uid,
      'package': package,
      'orderId': orderId,
      'productId': productId,
      'purchaseToken':purchaseToken
    };

    Resp resp = await Net.post(
        url: System.api("/api/pay/google_play_verify"),
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
