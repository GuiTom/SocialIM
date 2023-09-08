import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:login/src/register_page.dart';
import 'login_api.dart';
import 'locale/k.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'dart:ui' as ui;
import 'login_page.dart';

class PhoneNumberVerifyPage extends StatefulWidget {
  const PhoneNumberVerifyPage({super.key});

  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const PhoneNumberVerifyPage(),
        settings: const RouteSettings(name: '/PhoneNumberVerifyPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PhoneNumberVerifyPage> {
  // String? _areaCode;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _countryISOCode = ui.window.locale.countryCode ?? 'CN';
    _focusNode.requestFocus();
  }

  PhoneNumber? _phoneNumber;
  String _countryISOCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                K.getTranslation('phone_number_login'),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: IntlPhoneField(
                focusNode: _focusNode,
                initialCountryCode: _countryISOCode,
                decoration: InputDecoration(
                  labelText: K.getTranslation('phone_number'),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(),
                  ),
                ),
                languageCode: ui.window.locale.languageCode,
                onChanged: (phone) {
                  _phoneNumber = phone;
                  // dog.d(phone.completeNumber);
                },
                onCountryChanged: (country) {
                  _countryISOCode = country.code;
                  dog.d('Country changed to: ' + country.name);
                },
                invalidNumberMessage: K.getTranslation('invalid_number'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () async {
                  if (_phoneNumber == null) {
                    ToastUtil.showCenter(
                        msg: K.getTranslation('please_input_phone_number'));
                    return;
                  }
                  String _conuntryCode =
                      _phoneNumber!.countryCode.replaceAll('+', '');
                  if (!Util.isMobile(_phoneNumber!.number ?? '',
                      areaCode: _conuntryCode)) {
                    ToastUtil.showCenter(
                      msg: K.getTranslation('invalid_number'),
                      // Toast 显示位置，可以是 ToastGravity.TOP、ToastGravity.CENTER 或 ToastGravity.BOTTOM
                    );
                    return;
                  }

                  Resp resp = await LoginApi.mobileExist(
                      _phoneNumber!.number, _conuntryCode);
                  if (!mounted) return;
                  if (resp.code == 1) {
                    //存在，跳登录
                    if (resp.data == 2) {
                      //没设置密码，跳验证码登录
                      LoginPage.show(Constant.context,phone:_phoneNumber!.number,
                          areaCode:_conuntryCode,conuntryISOCode: _countryISOCode,usePassword:false);
                    } else {
                      LoginPage.show(Constant.context, phone:_phoneNumber!.number,
                          areaCode:_conuntryCode, conuntryISOCode:_countryISOCode ?? '',usePassword:true);
                    }
                  } else if (resp.code == Net.LOGIC_ERROR_NO_RECORD) {
                    //不存在，跳注册
                    RegisterPage.show(Constant.context, phone:_phoneNumber!.number,
                        areaCode:_conuntryCode, conuntryISOCode:_countryISOCode);
                  }
                },
                child: Button(
                  title: K.getTranslation('next_step'),
                  buttonSize: ButtonSize.Big,
                )),
          ],
        ),
      ),
    );
  }
}
