import 'package:base/base.dart';

class ProfileApi {
  static Future<UserInfoResp> getUserInfo(int uid) async {
    UserInfoResp resp = await Net.post(
        url: System.api('/api/user/info'),
        pb: true,
        params: {'uid': uid},
        pbMsg: UserInfoResp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }

  static Future<Resp> setUerInfo(
      Map <String,dynamic>params) async {
    params['uid'] = Session.uid;
    Resp resp = await Net.post(
        url: System.api('/api/user/updateInfo'),
        pb: true,
        params: params,
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }
  static Future<GenerateNameResp> genName(
      Map <String,dynamic>params) async {
    GenerateNameResp resp = await Net.post(
        url: System.api('/api/user/genName'),
        pb: true,
        params: params,
        pbMsg: GenerateNameResp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }
  static Future<Resp> removeFriend(int otherUid) async {
    String url = System.api('/api/user/removeFriend');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> addFriend(int otherUid) async {
    String url = System.api('/api/user/addFriend');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> addFocus(int otherUid) async {
    String url = System.api('/api/user/addFocus');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> removeFocus(int otherUid) async {
    String url = System.api('/api/user/removeFocus');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> removeUserFromBlackList(int otherUid) async {
    String url = System.api('/api/user/pullUserOutOfBlackList');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  static Future<UserBlackListResp> getUserBlackList() async {
    String url = System.api('/api/user/getUserBlackList');
    Map<String, dynamic> params = {'uid':Session.uid};
    UserBlackListResp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: UserBlackListResp.create());
    return resp;
  }

}
