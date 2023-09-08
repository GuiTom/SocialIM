import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:profile/src/profile_api.dart';
import '../locale/k.dart';
import 'package:base/src/locale/k.dart' as BaseK;
class NickNameEditPage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const NickNameEditPage(),
        settings: const RouteSettings(name: '/NickNameEditPage'),
      ),
    );
  }

  const NickNameEditPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<NickNameEditPage> {
  final TextEditingController _nicknameController =
      TextEditingController(text: Session.userInfo.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(K.getTranslation('nickname_modify')),
        actions: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 20,
            child: InkWell(
                onTap: () async{
                  Resp resp = await ProfileApi.setUerInfo({'name': _nicknameController.text});
                  if(resp.code==1){
                    Session.name = _nicknameController.text;
                    if(!mounted) return;
                    Navigator.pop(context);
                  }
                },
                child: Text(BaseK.K.getTranslation('confirm'))),
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
            hintText: K.getTranslation('enter_nickname'),
          ),
          onSubmitted: (value) {
            if (value.length > 12) {
              ToastUtil.showTop(msg: K.getTranslation('nickname_edit_tip'));
              return;
            }
            ProfileApi.setUerInfo({'name':value});
          },
        ),
      ),
    );
  }
}
