import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login/src/email_verify_page.dart';
import 'package:login/src/phone_number_verify_page.dart';
import './widget/prelogin_background_slide.dart';
import 'package:base/base.dart';
import 'locale/k.dart';
import 'dart:ui' as ui;

enum LoginButtonId {
  Phone,
  Email,
}

class PreLoginPage extends StatefulWidget {
  const PreLoginPage({super.key});

  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const PreLoginPage(),
        settings: const RouteSettings(name: '/LoginPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<PreLoginPage> {
  // bool _eulaAgreed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          PreloginBackgroundSlide(provider: LoginBackgroundProvider()),
          // 滚动的图片墙背景
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'GamePark',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 90,
              ),
              ..._buildLoginButtons(),
              const SizedBox(
                height: 40,
              ),
              // _buildEulaAgreenWidget(),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildLoginButtons() {
    return [
      {
        'id': LoginButtonId.Email,
        'title': K.getTranslation('use_email_tologin'),
        'textColor':Colors.white,
      },
      if (ui.window.locale.countryCode == 'CN')
        {
          'id': LoginButtonId.Phone,
          'title': K.getTranslation('use_phone_tologin'),
          'colors':[Colors.white,Colors.white],
          'textColor':Colors.black,
        },
    ]
        .mapIndexed(
          (index, e) => ThrottleTapDetector(
            onTap: () {
              if (e['id'] == LoginButtonId.Phone) {
                PhoneNumberVerifyPage.show(context);
              } else if (e['id'] == LoginButtonId.Email) {
                EmailVerifyPage.show(context);
              }
            },
            child: Button(
              title: e['title'] as String,
              colors: e['colors'] as List<Color>?,
              textColor: e['textColor'] as Color?,
              buttonSize: ButtonSize.Big,
              borderRadius: 12,
              padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 12, vertical: 8),
            ),
          ),
        )
        .toList()
        .addJoin((index, element) => const ThrottleTapDetector(
              child: SizedBox(
                height: 30,
              ),
            ))
        .toList();
  }
// Widget _buildEulaAgreenWidget() {
//   return EulaWidget(
//     onValueChanged: (bool agreed){
//       _eulaAgreed = agreed;
//       setState(() {
//       });
//     },
//   );
// }
}
