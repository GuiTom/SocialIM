import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/src/password_setting_page.dart';
import 'login_api.dart';
import './widget/get_sms_code_widget.dart';
import 'dart:ui' as ui;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'locale/k.dart';
import 'package:base/src/locale/k.dart' as BaseK;
class RegisterPage extends StatefulWidget {
  static Future show(BuildContext context, {String? phone, String? areaCode,
      String? conuntryISOCode,String ?email}) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => RegisterPage(
          phone: phone,
          areaCode: areaCode,
          conuntryISOCode: conuntryISOCode,
          email: email,
        ),
        settings: const RouteSettings(name: '/RegisterPage'),
      ),
    );
  }

  final String? phone;
  final String? areaCode;
  final String? conuntryISOCode;
  final String? email;
  const RegisterPage({
    super.key,
    required this.phone,
    required this.areaCode,
    required this.conuntryISOCode, this.email,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RegisterPage> {
  final FocusNode _focusNode = FocusNode();
  bool _eulaAgreed = false;

  @override
  void initState() {
    super.initState();
    if(widget.email==null) {
      _countryISOCode = widget.conuntryISOCode;
      _phone = widget.phone;
      _areaCode = widget.areaCode;
    }else {
      _email = widget.email;
    }
    _focusNode.requestFocus();
  }

  String? _email;
   String? _phone;
   String? _areaCode;
   String? _countryISOCode;
  String? _smsCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              K.getTranslation('account_registration'),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          if(_email==null)
          _buildPhoneWidget(),
          if(_email!=null)
            _buildEmailTextField(),
          const SizedBox(
            height: 10,
          ),
          _buildSmsCodeWidget(),
          const SizedBox(
            height: 30,
          ),
          _buildNextStepButton(),
          const Spacer(),
          _buildEulaAgreenWidget(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepButton() {
    return ThrottleInkWell(
        onTap: () async {
          if(!_eulaAgreed){
            ToastUtil.showCenter(msg: BaseK.K.getTranslation('view_and_agree_eula'));
            return;
          }

          if (!Util.isVerifyCode(_smsCode ?? '')) {
            ToastUtil.showCenter(msg: K.getTranslation('enter_4_digital_code'));
            return;
          }
          String? phoneCompleteNumber = null;
          if(_areaCode!=null&&_phone!=null){
            phoneCompleteNumber = '$_areaCode-${_phone}';
          }
          UserInfoResp? resp = await LoginApi.register(
              phoneCompleteNumber: phoneCompleteNumber,email: _email, smsCode: _smsCode);
          if (resp != null) {
            //注册成功，跳密码设置页面
            if (!mounted) return;
            PasswordSettingPage.show(Constant.context);
            if(_countryISOCode!=null) {
              Session.countryIsoCode = _countryISOCode!;
            }
            Session.userInfo = resp!.data;
            eventCenter.emit('userInfoChanged');
          }
        },
        child: Button(
          title: K.getTranslation('next_step'),
          buttonSize: ButtonSize.Big,
          disabled: !_eulaAgreed,
        ));
  }

  Widget _buildEulaAgreenWidget() {
    return EulaWidget(
        onValueChanged: (bool agreed){
          _eulaAgreed = agreed;
          setState(() {

          });
        },
    );
  }
  Widget _buildEmailTextField() {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: TextFormField(
        obscureText: false,
        enabled: false,
        initialValue: _email,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          color: Colors.black,
        ),

        decoration: InputDecoration(
          labelText: K.getTranslation('email_login'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
  Widget _buildSmsCodeWidget() {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: TextFormField(
        obscureText: false,
        focusNode: _focusNode,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          color: Colors.black,
        ),
        onChanged: (value) {
          _smsCode = value;
        },
        decoration: InputDecoration(
          labelText: K.getTranslation('enter_4_digital_code'),
          suffix: _buildGetSmsCodeButton(),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }

  Widget _buildGetSmsCodeButton() {
    return GetSmsCodeWidget(
      areaCode: _areaCode,
      phone: _phone,
      email: _email,
      smsType: 'register',
    );
  }

  Widget _buildPhoneWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntlPhoneField(
        initialValue: _phone,
        initialCountryCode: _countryISOCode,
        decoration: InputDecoration(
          labelText: K.getTranslation('phone_number'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        languageCode: ui.window.locale.languageCode,
        onChanged: (phone) {
          _phone = phone.number;
          _areaCode = phone.countryCode.replaceAll('+', '');
          // dog.d(phone.completeNumber);
        },
        onCountryChanged: (country) {
          _countryISOCode = country.code;
          dog.d('Country changed to: ' + country.name);
        },
        invalidNumberMessage: K.getTranslation('invalid_number'),
      ),
    );
  }
}
