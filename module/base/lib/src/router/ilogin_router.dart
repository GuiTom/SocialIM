import 'package:base/base.dart';
import 'package:flutter/material.dart';

enum VerficationType {
  //短信验证种类
  changeEmailOld, //修改邮箱旧号验证
  changeEmailNew, //修改邮箱新号验证
  changePhoneNumberOld, //改绑手机旧号验证
  changePhoneNumberNew, //改绑手机新号验证
  changePassword, //修改密码
  unRegisterAccount, //注销账号
}

abstract class ILoginRouter extends IModuleRouter {
  Future toLoginPage(
  {String? phone, String ?email, String? areaCode, String? conuntryIsoCode, bool usePassword});

  Widget getPreLoginPage();

  Future toPasswordSettingPage(String completePhoneNumber);

  Widget getPasswordSettingPage();

  // Widget getPhoneCodeVerifyPage();

  //公用短信验证码验证页面
  Future toSmsVerificationCodePage(VerficationType type, String pageTitle,
      String phone, String areaCode, String conuntryISOCode,
      [void Function()? onVerficationSuccess]);
  //公用邮件验证码验证页面
  Future toEmailVerificationCodePage(VerficationType type, String pageTitle,
      String email,
      [void Function()? onVerficationSuccess]);
  Future toUnRegisterRiskPage();
}
