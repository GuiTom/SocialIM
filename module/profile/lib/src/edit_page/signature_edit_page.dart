import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:profile/src/profile_api.dart';
import '../locale/k.dart';
import 'package:base/src/locale/k.dart' as BaseK;
class SigntureEditPage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const SigntureEditPage(),
        settings: const RouteSettings(name: '/SigntureEditPage'),
      ),
    );
  }

  const SigntureEditPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SigntureEditPage> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(K.getTranslation('signature_edit')),
        actions: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 20,
            child: InkWell(
                onTap: () async {
                  Resp resp = await ProfileApi.setUerInfo(
                      {'signature': _nicknameController.text});
                  if (resp.code == 1) {
                    ToastUtil.showCenter(msg: resp.message);
                    if(!mounted) return;
                    Session.signature = _nicknameController.text;
                    Navigator.pop(context);
                  }
                },
                child:  Text(BaseK.K.getTranslation('confirm'))),
          ),
        ],
      ),
      body: Container(
        height: 40,
        margin: const EdgeInsetsDirectional.only(top: 20),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
        color: Colors.white,
        child: TextField(
          controller: _nicknameController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: K.getTranslation('enter_signature_tip'),
          ),
          onSubmitted: (value) {
            if (value.length > 20) {
              ToastUtil.showTop(msg: K.getTranslation('enter_signature_length_tip'));
              return;
            }
            ProfileApi.setUerInfo({'signature': value});
          },
        ),
      ),
    );
  }
}
