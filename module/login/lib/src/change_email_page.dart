import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_api.dart';
import './widget/get_sms_code_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'locale/k.dart';
import 'dart:ui' as ui;

class ChangeEmailPage extends StatefulWidget {
  static Future show(BuildContext context, VerficationType type,
      String pageTitle, String email) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => ChangeEmailPage(
          pageTitle: pageTitle,
          email: email,
          type: type,
        ),
        settings: const RouteSettings(name: '/ChangeEmailPage'),
      ),
    );
  }

  final String pageTitle;

  final VerficationType type;
  final String email;

  const ChangeEmailPage({
    super.key,
    required this.pageTitle,
    required this.email,
    required this.type,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChangeEmailPage> {
  // String? _areaCode;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.requestFocus();
  }

  String? _email;

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
              widget.pageTitle,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
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
    );
  }

  Widget _buildNextStepButton() {
    return ThrottleInkWell(
        onTap: () async {
          if (_email == null) {
            ToastUtil.showCenter(
                msg: K.getTranslation('please_input_new_email'));
            return;
          }
          if (!Util.isEmail(_email!)) {
            ToastUtil.showCenter(msg: K.getTranslation('invalid_email'));
            return;
          }
          if (!Util.isVerifyCode(_smsCode ?? '')) {
            ToastUtil.showCenter(msg: K.getTranslation('enter_4_digital_code'));
            return;
          }

          Resp resp =
              await LoginApi.changeEmail(smsCode: _smsCode!, newEmail: _email);
          if (resp.code == 1) {
            Session.email = _email!;
            if (!mounted) return;
            Navigator.popUntil(
                context,
                (route) => ['/ProfileEditPage', '/SettingPage']
                    .contains(route.settings.name));
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
        obscureText: false,
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
      email: _email,
      smsType: widget.type.name,
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: TextFormField(
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        focusNode: _focusNode,
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          color: Colors.black,
        ),
        onChanged: (value) {
          _email = value;
          setState(() {});
        },
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
