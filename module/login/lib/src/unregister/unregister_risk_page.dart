import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/src/old_email_verfication_page.dart';
import '../locale/k.dart';
import '../login_api.dart';
import '../old_sms_verfication_page.dart';

class UnRegisterRiskPage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const UnRegisterRiskPage(),
        settings: const RouteSettings(name: '/UnRegisterRiskPage'),
      ),
    );
  }

  const UnRegisterRiskPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<UnRegisterRiskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(K.getTranslation('risk_warning')),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: 20,top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                K.getTranslation('risk_points_title'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20,),
              Text(
                K.getTranslation('risk_1'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8,),
              Text(
                K.getTranslation('risk_1_detail'),
                style: const TextStyle(color: Color(0xFF919191)),
              ),
              const SizedBox(height: 20,),
              Text(
                K.getTranslation('risk_2'),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8,),
              Text(
                K.getTranslation('risk_2_detail'),
                style: const TextStyle(color: Color(0xFF919191)),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  if(Session.userInfo.phone.isNotEmpty) {
                    String areaCode = Session.userInfo.phone
                        .split('-')
                        .first;
                    String phone = Session.userInfo.phone
                        .split('-')
                        .last;
                    OldSmsVerficationPage.show(
                        Constant.context,
                        VerficationType.unRegisterAccount,
                        K.getTranslation('unregister_verfication'),
                        phone,
                        areaCode,
                        Session.countryIsoCode,
                            (String completePhoneNumber, String smsCode) async {
                          Resp resp = await LoginApi.unRegister(
                              smsCode: smsCode!);
                          if (resp.code == 1) {
                            if (!mounted) return;
                            Navigator.popUntil(context, ModalRoute.withName(
                                '/'));
                            ToastUtil.showCenter(
                                msg: K.getTranslation(
                                    'unregister_success_tip'));
                            Session.logOut();
                          }
                        });
                  }else {
                    String email = Session.userInfo.email;
                    OldEmailVerficationPage.show(
                        Constant.context,
                        VerficationType.unRegisterAccount,
                        K.getTranslation('unregister_verfication'),
                        email,
                            (String completePhoneNumber, String smsCode) async {
                          Resp resp = await LoginApi.unRegister(
                              smsCode: smsCode!);
                          if (resp.code == 1) {
                            if (!mounted) return;
                            Navigator.popUntil(context, ModalRoute.withName(
                                '/'));
                            ToastUtil.showCenter(
                                msg: K.getTranslation(
                                    'unregister_success_tip'));
                            Session.logOut();
                          }
                        });
                  }
                },
                child: Button(
                    title: K.getTranslation('risk_confirm'),
                    margin: const EdgeInsetsDirectional.only(end:20),
                    buttonSize: ButtonSize.Big),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
