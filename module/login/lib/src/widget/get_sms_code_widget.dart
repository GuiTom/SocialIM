import 'dart:async';

import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../locale/k.dart';
import '../login_api.dart';

class GetSmsCodeWidget extends StatefulWidget {
  final String? areaCode;
  final String? phone;
  final String? email;
  final String smsType;

  const GetSmsCodeWidget(
      {super.key,
      this.areaCode,
      this.phone,
      this.email,
      required this.smsType});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<GetSmsCodeWidget> {
  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(_timer?.isActive ?? false)) {
      return ThrottleInkWell(
        onTap: () async {
          if (widget.email == null) {
            Resp resp = await LoginApi.getSmsCode(
                areaCode: widget.areaCode,
                mobile: widget.phone,
                type: widget.smsType);
            if (resp.code == 1) {
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (timer.tick >= 60) {
                  timer.cancel();
                  setState(() {});
                }
              });
              setState(() {});
            }
            ToastUtil.showCenter(msg: K.getTranslation('sms_code_sended'));
          } else {
            Resp resp = await LoginApi.getEmailCode(
                email: widget.email!, type: widget.smsType);
            if (resp.code == 1) {
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (timer.tick >= 60) {
                  timer.cancel();
                  setState(() {});
                }
              });
              setState(() {});
            }
            ToastUtil.showCenter(msg: K.getTranslation('sms_code_sended'));
          }
        },
        child: Text(
          K.getTranslation('fetch_sms_code'),
          style: widget.email == null && widget.phone == null
              ? const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Color(0x3F111111))
              : const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
      );
    } else {
      return Text(
        K.getTranslation('resend_in_seconds', args: [60 - (_timer?.tick ?? 0)]),
        style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Color(0x3F111111)),
      );
    }
    ;
  }
}
