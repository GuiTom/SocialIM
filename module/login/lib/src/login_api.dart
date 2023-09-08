import 'package:base/base.dart';

class LoginApi {
  ///手机号是否存在
  static Future<Resp> mobileExist(String mobile, String? _areaCode) async {
    String url = System.api('/api/user/mobileExist');
    Map<String, String?> params = {'phone': '$_areaCode-$mobile'};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }

  static Future<Resp> emailExist(String email) async {
    String url = System.api('/api/user/emailExist');
    Map<String, String?> params = {'email': email};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }

  static Future<UserInfoResp?> register(
      {String? phoneCompleteNumber, String? smsCode, String? email}) async {
    Map<String, dynamic> params = {'sms_code': smsCode};
    if (phoneCompleteNumber != null) {
      params['phone'] = phoneCompleteNumber!;
    }
    if (email != null) {
      params['email'] = email!;
    }

    UserInfoResp resp = await Net.post(
        url: System.api("/api/user/register"),
        pb: true,
        params: params,
        pbMsg: UserInfoResp.create());
    if (resp.code == 1) {
      return resp;
    } else {
      ToastUtil.showCenter(msg: resp.message);
    }
    return null;
  }

  static Future<UserInfoResp?> login(
      {String? phoneCompleteNumber,
      String? smsCode,
      String? email,
      String? password}) async {
    Map<String, dynamic> params = {};
    if (phoneCompleteNumber != null) {
      params['phone'] = phoneCompleteNumber;
    }
    if (email != null) {
      params['email'] = email;
    }
    if (password != null) {
      params['password'] = password;
    } else {
      params['code'] = smsCode;
    }
    params['isIos'] = Constant.isIos ? 1 : 0;
    UserInfoResp resp = await Net.post(
        url: System.api("/api/user/login"),
        pb: true,
        params: params,
        pbMsg: UserInfoResp.create());
    if (resp.code == 1) {
      return resp;
    } else {
      ToastUtil.showCenter(msg: resp.message);
    }
    return null;
  }

  static Future<Resp> getSmsCode(
      {required areaCode, required mobile, required String type}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/getSmsCode'),
        pb: true,
        params: {'phone': '$areaCode-$mobile', 'type': type},
        pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> getEmailCode(
      {required String email,required String type}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/getEmailCode'),
        pb: true,
        params: {'email': email, 'type': type},
        pbMsg: Resp.create());
    return resp;
  }

  static Future<Resp> checkSmsCode(
      {required smsCode,
      required areaCode,
      required mobile,
      required String type}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/checkSmsCode'),
        pb: true,
        params: {'phone': '$areaCode-$mobile', 'type': type, 'code': smsCode},
        pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> checkEmailCode(
      {required smsCode,
        required email,
        required String type}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/checkEmailCode'),
        pb: true,
        params: {'email': email, 'type': type, 'code': smsCode},
        pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> setPassword(
      {required int uid, required String password}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/modify_password'),
        pb: true,
        params: {
          'uid': uid,
          'password': Util.cryptPwd(password)
        },
        pbMsg: Resp.create());
    return resp;
  }

  static Future<Resp> changePhoneNumber(
      {required newCompletePhoneNumber, required String smsCode}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/changePhoneNumber'),
        pb: true,
        params: {
          'newPhone': newCompletePhoneNumber,
          'uid': Session.uid,
          'code': smsCode,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }
  static Future<Resp> changeEmail(
      {required newEmail, required String smsCode}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/changeEmail'),
        pb: true,
        params: {
          'newEmail': newEmail,
          'uid': Session.uid,
          'code': smsCode,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }
  static Future<Resp> unRegister({required String smsCode}) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/unregister'),
        pb: true,
        params: {
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }
}
