import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_api.dart';
import './widget/get_sms_code_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'locale/k.dart';
import 'dart:ui' as ui;

class LoginPage extends StatefulWidget {
  static Future show(BuildContext context,
      {String? phone, String?email, String? areaCode,
        String? conuntryISOCode, bool usePassword = false}) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) =>
            LoginPage(
              phone: phone,
              email: email,
              areaCode: areaCode,
              conuntryISOCode: conuntryISOCode,
              usePassword: usePassword,
            ),
        settings: const RouteSettings(name: '/LoginPage'),
      ),
    );
  }

  final bool usePassword;
  final String? phone;
  final String? areaCode;
  final String? conuntryISOCode;
  final String? email;

  const LoginPage({super.key,
    required this.phone,
    required this.areaCode,
    required this.conuntryISOCode,
    required this.usePassword, this.email});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LoginPage> {
  // String? _areaCode;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.email == null) {
      _countryISOCode = widget.conuntryISOCode;
      _phone = widget.phone;
      _areaCode = widget.areaCode;
    } else {
      _email = widget.email;
    }
    _focusNode.requestFocus();
  }

  String? _email;
  String? _phone;
  String? _areaCode;
  String? _countryISOCode;
  String? _passwrod;
  String? _smsCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: widget.usePassword ? 20 : 50,
            ),
            if (widget.usePassword)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 20),
                  child: ThrottleInkWell(
                    onTap: () {
                      ILoginRouter loginRouter = (RouterManager.instance
                          .getModuleRouter(ModuleType.Login) as ILoginRouter);
                      loginRouter.toLoginPage(
                          phone: _phone,
                          email:_email,
                          areaCode: _areaCode,
                          conuntryIsoCode: _countryISOCode,
                          usePassword: false);
                    },
                    child: Text(
                      K.getTranslation('sms_code_login'),
                      style: const TextStyle(
                          color: Color(0x3F111111),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _email!=null?K.getTranslation('email_login'):K.getTranslation('phone_number_login'),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            if(widget.email == null)
              _buildPhoneWidget(),
            if(widget.email != null)
              _buildEmailTextField(),

            const SizedBox(
              height: 10,
            ),
            _buildPasswordOrSmsCodeWidget(),
            const SizedBox(
              height: 30,
            ),
            _buildNextStepButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStepButton() {
    return ThrottleInkWell(
        onTap: () async {
          if(_email==null) {
            if (_phone == null) {
              ToastUtil.showCenter(
                  msg: K.getTranslation('please_input_phone_number'));
              return;
            }
            if (!Util.isMobile(_phone!, areaCode: _areaCode!)) {
              ToastUtil.showCenter(msg: K.getTranslation('invalid_number'));

              return;
            }
          }
          if (widget.usePassword && !Util.isVerifyPwd(_passwrod ?? '')) {
            ToastUtil.showCenter(
                msg: K.getTranslation('enter_6_digital_password'));
            return;
          }
          if (!widget.usePassword && !Util.isVerifyCode(_smsCode ?? '')) {
            ToastUtil.showCenter(msg: K.getTranslation('enter_4_digital_code'));
            return;
          }
          UserInfoResp? resp = await LoginApi.login(
              phoneCompleteNumber: '$_areaCode-${_phone}',
              password: widget.usePassword ? Util.cryptPwd(_passwrod!) : null,
              smsCode: widget.usePassword ? null : _smsCode,email: _email);
          if (resp != null) {
            //登录成功，跳首页
            if(_countryISOCode!=null) {
              Session.countryIsoCode = _countryISOCode!;
            }
            Session.userInfo = resp!.data;
            eventCenter.emit('userInfoChanged');

            if (!mounted) return;
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        },
        child: Button(
          title: K.getTranslation('next_step'),
          buttonSize: ButtonSize.Big,
        ));
  }

  Widget _buildPasswordOrSmsCodeWidget() {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: TextFormField(
        obscureText: widget.usePassword,
        keyboardType: TextInputType.number,
        focusNode: _focusNode,
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          color: Colors.black,
        ),
        onChanged: (value) {
          if (widget.usePassword) {
            _passwrod = value;
          } else {
            _smsCode = value;
          }
        },
        decoration: InputDecoration(
          labelText: widget.usePassword
              ? K.getTranslation('input_password')
              : K.getTranslation('enter_4_digital_code'),
          suffix: widget.usePassword ? null : _buildGetSmsCodeButton(),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }

  Widget _buildGetSmsCodeButton() {
    return GetSmsCodeWidget(
      areaCode: _areaCode!,
      phone: _phone!,
      email: _email,
      smsType: 'login',
    );
  }

  Widget _buildPhoneWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntlPhoneField(
        initialValue: _phone,
        initialCountryCode: _countryISOCode,
        enabled: false,
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
          dog.d(phone.completeNumber);
        },
        onCountryChanged: (country) {
          _countryISOCode = country.code;
          dog.d('Country changed to: ' + country.name);
        },
        invalidNumberMessage: K.getTranslation('invalid_number'),
      ),
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
          labelText: K.getTranslation('enter_email'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }
}
