import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'locale/k.dart';
import 'login_api.dart';

class PasswordSettingPage extends StatefulWidget {
  const PasswordSettingPage({super.key});

  static Future show(
    BuildContext context,
  ) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const PasswordSettingPage(),
        settings: const RouteSettings(name: '/PasswordSettingPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<PasswordSettingPage> {
  String? _firstPassword;
  String? _secondPassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              _buildIgnoreButton(),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  K.getTranslation('password_setting'),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              _buildPasswordTextFieldWidget(true),
              const SizedBox(
                height: 30,
              ),
              _buildPasswordTextFieldWidget(false),
              const SizedBox(
                height: 40,
              ),
              _buildNextStepButton(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIgnoreButton() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 20),
        child: ThrottleInkWell(
          onTap: () {
            Session.allowPasswordEmpty = true;

            if (Session.needShowProfilePreset) {
              IProfileRouter profileRouter = (RouterManager.instance
                  .getModuleRouter(ModuleType.Profile) as IProfileRouter)!;
              profileRouter.toProfilePreEnterPage();
              Session.needShowProfilePreset = false;
            } else {
              Navigator.popUntil(context, ModalRoute.withName('/'));

              eventCenter.emit('userInfoChanged');
            }
          },
          child: Text(
            K.getTranslation('skip'),
            style: const TextStyle(
                color: Color(0x3F111111),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordTextFieldWidget(bool isFirst) {
    return Container(
      padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
      child: TextFormField(
        obscureText: true,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 18,
          letterSpacing: 1,
          color: Colors.black,
        ),
        onChanged: (value) {
          if (isFirst) {
            _firstPassword = value;
          } else {
            _secondPassword = value;
          }
        },
        validator: (value) {
          if (isFirst) {
            if (Util.isVerifyPwd(value ?? '')) {
              return K.getTranslation('password_not_long_enough');
            }
          } else {
            if ((_firstPassword?.isNotEmpty ?? false) &&
                (value?.isNotEmpty ?? false) &&
                !_firstPassword!.startsWith(value!)) {
              return K.getTranslation('password_different');
            }
          }
        },
        decoration: InputDecoration(
          labelText: isFirst
              ? K.getTranslation('password_setting')
              : K.getTranslation('password_confirm'),
          border: const OutlineInputBorder(
            borderSide: BorderSide(),
          ),
        ),
      ),
    );
  }

  Widget _buildNextStepButton() {
    return ThrottleInkWell(
        onTap: () async {
          if (_firstPassword != _secondPassword) {
            ToastUtil.showCenter(msg: K.getTranslation('password_different'));
            return;
          }
          if (!Util.isVerifyPwd(_secondPassword ?? '')) {
            ToastUtil.showCenter(
                msg: K.getTranslation('enter_6_digital_password'));
            return;
          }

          Resp? resp = await LoginApi.setPassword(
              uid: Session.uid, password: _secondPassword!);
          if (resp?.code == 1) {
            Session.passwordSetted = true;
            //登录成功，跳首页
            if (!mounted) return;
            if (Session.needShowProfilePreset) {
              IProfileRouter profileRouter = (RouterManager.instance
                  .getModuleRouter(ModuleType.Profile) as IProfileRouter)!;
              profileRouter.toProfilePreEnterPage();
              Session.needShowProfilePreset = false;
            } else {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              eventCenter.emit('userInfoChanged');
            }
          }
        },
        child: Button(
          title: K.getTranslation('next_step'),
          buttonSize: ButtonSize.Big,
        ));
  }
}
