import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_api.dart';
import './widget/get_sms_code_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'locale/k.dart';
import 'dart:ui' as ui;

class ChangePhoneNumberPage extends StatefulWidget {
  static Future show(
      BuildContext context,
      VerficationType type,
      String pageTitle,
      String areaCode,
      String conuntryISOCode) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => ChangePhoneNumberPage(
          pageTitle: pageTitle,
          areaCode: areaCode,
          type: type,
          conuntryISOCode: conuntryISOCode,

        ),
        settings: const RouteSettings(name: '/ChangePhoneNumberPage'),
      ),
    );
  }

  final String pageTitle;

  final VerficationType type;
  final String areaCode;
  final String conuntryISOCode;

  const ChangePhoneNumberPage({
    super.key,
    required this.pageTitle,
    required this.areaCode,
    required this.conuntryISOCode,

    required this.type,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChangePhoneNumberPage> {
  // String? _areaCode;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _countryISOCode = widget.conuntryISOCode;
    _phone = '';
    _areaCode = widget.areaCode;
    _focusNode.requestFocus();
  }

  late String _phone;
  late String _areaCode;
  late String _countryISOCode;
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
          _buildPhoneWidget(),
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
          if (_phone == null) {
            ToastUtil.showCenter(
                msg: K.getTranslation('please_input_phone_number'));
            return;
          }
          if (!Util.isMobile(_phone, areaCode: _areaCode)) {
            ToastUtil.showCenter(msg: K.getTranslation('invalid_number'));
            return;
          }
          if (!Util.isVerifyCode(_smsCode ?? '')) {
            ToastUtil.showCenter(msg: K.getTranslation('enter_4_digital_code'));
            return;
          }
          String newCompletePhoneNumber = '$_areaCode-$_phone';
          Resp resp = await LoginApi.changePhoneNumber(
              smsCode: _smsCode!, newCompletePhoneNumber: newCompletePhoneNumber);
          if (resp.code == 1) {
             Session.phone = newCompletePhoneNumber;
            if(!mounted) return;
            Navigator.popUntil(context, (route) => ['/ProfileEditPage','/SettingPage'].contains(route.settings.name));
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
      areaCode: _areaCode,
      phone: _phone,
      smsType: widget.type.name,
    );
  }

  Widget _buildPhoneWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IntlPhoneField(
        initialValue: _phone,
        focusNode:_focusNode,
        initialCountryCode: _countryISOCode,
        decoration: InputDecoration(
          labelText:  K.getTranslation('new_phone_number'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
        languageCode: ui.window.locale.languageCode,
        onChanged: (phone) {
          _phone = phone.number;
          _areaCode = phone.countryCode.replaceAll('+', '');
          setState(() {});
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
}
