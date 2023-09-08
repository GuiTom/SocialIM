import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:login/src/register_page.dart';
import 'login_api.dart';
import 'locale/k.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'dart:ui' as ui;
import 'login_page.dart';

class EmailVerifyPage extends StatefulWidget {
  const EmailVerifyPage({super.key});

  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const EmailVerifyPage(),
        settings: const RouteSettings(name: '/EmailVerifyPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EmailVerifyPage> {
  // String? _areaCode;
  final FocusNode _focusNode = FocusNode();
  String? _email;
  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                K.getTranslation('email_login'),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            _buildEmailTextField(),
            const SizedBox(
              height: 30,
            ),
            InkWell(
                onTap: () async {
                  if (_email == null) {
                    ToastUtil.showCenter(
                        msg: K.getTranslation('please_input_email'));
                    return;
                  }

                  if (!Util.isEmail(_email!)) {
                    ToastUtil.showCenter(
                      msg: K.getTranslation('please_input_email'),
                      // Toast 显示位置，可以是 ToastGravity.TOP、ToastGravity.CENTER 或 ToastGravity.BOTTOM
                    );
                    return;
                  }

                  Resp resp = await LoginApi.emailExist(
                      _email!);
                  if (!mounted) return;
                  if (resp.code == 1) {
                    //存在，跳登录
                    if (resp.data == 2) {
                      //没设置密码，跳验证码登录
                      LoginPage.show(Constant.context,email:_email,usePassword:false);
                    } else {
                      LoginPage.show(Constant.context,email:_email,usePassword:true);
                    }
                  } else if (resp.code == Net.LOGIC_ERROR_NO_RECORD) {
                    //不存在，跳注册
                    RegisterPage.show(Constant.context, email: _email);
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
        },
        decoration: InputDecoration(
          labelText:  K.getTranslation('enter_email'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),

        ),
      ),
    );
  }

}
