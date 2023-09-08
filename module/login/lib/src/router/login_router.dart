import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:login/src/change_phone_number_page.dart';
import 'package:login/src/pre_login_page.dart';
import 'package:login/src/old_email_verfication_page.dart';

import '../change_email_page.dart';
import '../locale/k.dart';
import '../login_api.dart';
import '../old_sms_verfication_page.dart';
import '../login_page.dart';
import '../password_setting_page.dart';
import '../phone_number_verify_page.dart';
import '../register_page.dart';
import '../unregister/unregister_risk_page.dart';

class LoginRouter implements ILoginRouter {
  @override
  Future toLoginPage(
      {String? phone,
      String? email,
      String? areaCode,
      String? conuntryIsoCode,
      bool usePassword = false}) {
    return LoginPage.show(Constant.context,
        phone: phone,
        email: email,
        areaCode: areaCode,
        conuntryISOCode: conuntryIsoCode,
        usePassword: usePassword);
  }

  @override
  Widget getPreLoginPage() {
    return const PreLoginPage();
  }

  @override
  Future toPasswordSettingPage(String completePhoneNumber) {
    return PasswordSettingPage.show(Constant.context);
  }

  @override
  Widget getPasswordSettingPage() {
    return const PasswordSettingPage();
  }

  @override
  Future toUnRegisterRiskPage() {
    //注销账号入口
    return UnRegisterRiskPage.show(Constant.context);
  }

  //公共的短信验证页面
  @override
  Future toSmsVerificationCodePage(VerficationType type, String pageTitle,
      String phone, String areaCode, String conuntryISOCode,
      [void Function()? onVerficationSuccess]) async {
    await OldSmsVerficationPage.show(
        Constant.context, type, pageTitle, phone, areaCode, conuntryISOCode,
        (String completePhoneNumber, String smsCode) async {
      if (type == VerficationType.unRegisterAccount) {
        //注销账号验证
        Resp resp = await LoginApi.unRegister(smsCode: smsCode!);
        if (resp.code == 1) {
          onVerficationSuccess?.call();
        }
        return Future(() => true);
      } else if (type == VerficationType.changePassword) {
        //修改密码验证
        return PasswordSettingPage.show(Constant.context);
      } else if (type == VerficationType.changePhoneNumberOld) {
        //换绑手机号新号验证
        return ChangePhoneNumberPage.show(
            Constant.context,
            VerficationType.changePhoneNumberNew,
            pageTitle,
            areaCode,
            conuntryISOCode);
      }
    });
  }

  //公共的邮件验证页面
  @override
  Future toEmailVerificationCodePage(
      VerficationType type, String pageTitle, String email,
      [void Function()? onVerficationSuccess]) async {
    await OldEmailVerficationPage.show(Constant.context, type, pageTitle, email,
        (String completePhoneNumber, String smsCode) async {
      if (type == VerficationType.unRegisterAccount) {
        //注销账号验证
        Resp resp = await LoginApi.unRegister(smsCode: smsCode!);
        if (resp.code == 1) {
          onVerficationSuccess?.call();
        }
        return Future(() => true);
      } else if (type == VerficationType.changePassword) {
        //修改密码验证
        return PasswordSettingPage.show(Constant.context);
      } else if (type == VerficationType.changeEmailOld) {
        //换绑手机号新号验证
        return ChangeEmailPage.show(
          Constant.context,
          VerficationType.changeEmailNew,
          pageTitle,
          email,
        );
      }
    });
  }
// @override
// Widget getPhoneCodeVerifyPage() {
//   return const PhoneNumberVerifyPage();
// }
}
