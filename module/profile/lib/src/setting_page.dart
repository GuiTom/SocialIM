import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'blacklist/blacklist_page.dart';
import 'locale/k.dart';
import 'package:base/src/locale/k.dart' as BaseK;
enum SettingItemType {
  emailChange,
  phoneNumberChange,
  modifyPassword,
  notification,
  privacy,
  blacklist,
  aboutAs,
  unRegisterAccount
}

class SettingPage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const SettingPage(),
        settings: const RouteSettings(name: '/SettingPage'),
      ),
    );
  }

  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
  }

  final List<Map<String, dynamic>> _settings = [
    if (Session.userInfo.email.isNotEmpty)
      {
        'name': K.getTranslation('change_email'),
        'type': SettingItemType.emailChange
      },
    if (Session.userInfo.phone.isNotEmpty)
      {
        'name': K.getTranslation('change_phone_nummer'),
        'type': SettingItemType.phoneNumberChange
      },
    {
      'name': K.getTranslation('modify_login_password'),
      'type': SettingItemType.modifyPassword
    },
    // {'name': K.getTranslation('notification_setting'), 'type': SettingItemType.Notification},
    // {'name': K.getTranslation('privacy_setting'), 'type': SettingItemType.Privacy},
    // {'name': K.getTranslation('about_us'), 'type': SettingItemType.AboutAs},
    {
      'name': K.getTranslation('blacklist_setting'),
      'type': SettingItemType.blacklist
    },
    {
      'name': K.getTranslation('unregister_account'),
      'type': SettingItemType.unRegisterAccount
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          K.getTranslation('setting'),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
              // padding: const EdgeInsetsDirectional.only(start: 12),
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data = _settings[index];
                return ThrottleInkWell(
                  onTap: () {
                    _handleClick(_settings[index]);
                  },
                  child: Container(
                    color: Colors.white,
                    height: 50,
                    padding: const EdgeInsetsDirectional.symmetric(
                        vertical: 6, horizontal: 12),
                    child: Row(
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        const GoNextIcon(
                          size: 36,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                if (index <= 1) {
                  return const SizedBox.shrink();
                } else {
                  return const SizedBox(height: 20);
                }
              },
              itemCount: _settings.length),
        ),
        _buildLogoutWideget(),
        const SizedBox(height: 20,)
      ],
    );
  }
  Widget _buildLogoutWideget() {
    return ThrottleInkWell(
      onTap: () async {
        final result = await showOkCancelAlertDialog(
            context: context,
            title: K.getTranslation('logout_warning'),
            okLabel: BaseK.K.getTranslation('confirm'),
            cancelLabel: BaseK.K.getTranslation('cancel'),
            style: AdaptiveStyle.iOS);
        if (result == OkCancelResult.ok) {
          if(mounted) {
            Navigator.popUntil(context, ModalRoute.withName(
                '/'));
          }
          Session.logOut();
        }
      },
      child: Button(
        title: K.getTranslation('logout'),
        buttonSize: ButtonSize.Big,
      ),
    );
  }
  void _handleClick(Map<String, dynamic> data) {
    if (data['type'] == SettingItemType.modifyPassword) {
      //修改密码
      if (Session.userInfo.email.isNotEmpty) {
        ILoginRouter loginRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.Login) as ILoginRouter);
        String email = Session.userInfo.email;

        loginRouter.toEmailVerificationCodePage(
          VerficationType.changePassword,
          K.getTranslation('verification_for_modify_password'),
          email,
        );
      } else {
        ILoginRouter loginRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.Login) as ILoginRouter);
        String phone = Session.userInfo.phone.split('-').last;
        String areaCode = Session.userInfo.phone.split('-').first;
        loginRouter.toSmsVerificationCodePage(
            VerficationType.changePassword,
            K.getTranslation('verification_for_modify_password'),
            phone,
            areaCode,
            Session.countryIsoCode);
      }
    } else if (data['type'] == SettingItemType.phoneNumberChange) {
      //换绑手机
      ILoginRouter loginRouter = (RouterManager.instance
          .getModuleRouter(ModuleType.Login) as ILoginRouter);
      String phone = Session.userInfo.phone.split('-').last;
      String areaCode = Session.userInfo.phone.split('-').first;
      loginRouter.toSmsVerificationCodePage(
        VerficationType.changePhoneNumberOld,
        K.getTranslation('verification_for_change_phone'),
        phone,
        areaCode,
        Session.countryIsoCode,
      );
    } else if (data['type'] == SettingItemType.emailChange) {
      //换绑手机
      ILoginRouter loginRouter = (RouterManager.instance
          .getModuleRouter(ModuleType.Login) as ILoginRouter);
      String email = Session.userInfo.email;
      loginRouter.toEmailVerificationCodePage(
        VerficationType.changeEmailOld,
        K.getTranslation('verification_for_change_email'),
        email
      );
    } else if (data['type'] == SettingItemType.blacklist) {
      //黑名单
      BlackListPage.show(context);
    } else if (data['type'] == SettingItemType.unRegisterAccount) {
      //注销账号
      ILoginRouter loginRouter = (RouterManager.instance
          .getModuleRouter(ModuleType.Login) as ILoginRouter);
      loginRouter.toUnRegisterRiskPage();
    }
  }
}
