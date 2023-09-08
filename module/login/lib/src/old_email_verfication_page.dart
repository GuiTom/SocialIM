import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_api.dart';
import './widget/get_sms_code_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'locale/k.dart';
import 'dart:ui' as ui;

class OldEmailVerficationPage extends StatefulWidget {
  static Future show(
      BuildContext context,
      VerficationType type,
      String pageTitle,
      String email,
      void Function(String completePhoneNumber, String smsCode) callback) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => OldEmailVerficationPage(
          pageTitle: pageTitle,
          type: type,
          email: email,
          callback: callback,
        ),
        settings: const RouteSettings(name: '/OldEmailVerficationPage'),
      ),
    );
  }

  final void Function(String phone, String smsCode) callback;
  final String pageTitle;
  final String email;
  final VerficationType type;


  const OldEmailVerficationPage({
    super.key,
    required this.pageTitle,
    required this.type,
    required this.email,
    required this.callback,

  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<OldEmailVerficationPage> {
  // String? _areaCode;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _email = widget.email;

    _focusNode.requestFocus();
  }

  late String _email;

  String? _smsCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
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
              height: 30,
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
          if (_email == null) {
            ToastUtil.showCenter(
                msg: K.getTranslation('please_input_email'));
            return;
          }
          if (!Util.isEmail(_email)) {
            ToastUtil.showCenter(msg: K.getTranslation('invalid_email'));
            return;
          }
          if (!Util.isVerifyCode(_smsCode ?? '')) {
            ToastUtil.showCenter(msg: K.getTranslation('enter_4_digital_code'));
            return;
          }
          Resp resp = await LoginApi.checkEmailCode(
              smsCode: _smsCode,
              email: _email,
              type: widget.type.name);
          if (resp.code == 1) {
            ToastUtil.showCenter(msg: resp.message);
            widget.callback(_email, _smsCode!);
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
        focusNode: _focusNode,
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
        enabled: false,
        initialValue: _email,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          color: Colors.black,
        ),
        onChanged: (value) {
          _email = value;
        },
        decoration: InputDecoration(
          labelText:  K.getTranslation('current_email'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),

        ),
      ),
    );
  }
}
