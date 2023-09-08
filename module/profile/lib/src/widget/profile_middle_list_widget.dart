import 'dart:io';

import 'package:base/base.dart';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';
import '../locale/k.dart';
import '../customer_service_page.dart';

enum ProfileListItemType {
  Identify,
  VersionInfo,
  CustomerService,
}

class ProfileMiddleListWidget extends StatefulWidget {
  const ProfileMiddleListWidget({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfileMiddleListWidget> {
  @override
  void initState() {
    super.initState();
    _getVersionInfo();
  }

  String _versionName = '';
  String _versionCode = '';
  final List<Map<String, dynamic>> _itemDatas = [
    // {
    //   'name': '实名认证',
    //   'type': ProfileListItemType.Identify,
    //   'icon': 'assets/icon_identify.svg'
    // },
    {
      'name': K.getTranslation('customer_service_and_help'),
      'type': ProfileListItemType.CustomerService,
      'icon': 'assets/icon_help_feedback.svg'
    },
    {
      'name': K.getTranslation('version_check'),
      'type': ProfileListItemType.VersionInfo,
      'icon': 'assets/icon_identify.svg'
    },
  ];

  Future<void> _getVersionInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _versionName = packageInfo.version;
      _versionCode = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _itemDatas.mapIndexed((index, element) =>
        _buildListItem(element)).toList(),);
  }

  Widget _buildListItem(Map data) {
    return GestureDetector(
      onTap: () {
        if (data['type'] == ProfileListItemType.Identify) {
          //实名认证
        } else if (data['type'] == ProfileListItemType.CustomerService) {
          //客服和帮助
          CustomerServicePage.show(Constant.context);
        }
        if (data['type'] == ProfileListItemType.VersionInfo) {
          //检查版本
          if ((Platform.isAndroid &&
              TypeUtil.parseInt(_versionCode) <
                  Constant.latestVersionCodeAndroid) ||
              (Platform.isIOS &&
                  TypeUtil.parseInt(_versionCode) <
                      Constant.latestVersionCodeIOS)) {
            if (Platform.isIOS) {
              _launchAppStore();
            } else {
              _launchGooglePlay();
            }
          } else {
            ToastUtil.showCenter(msg: '当前已是最新版本');
          }
        }
      },
      child: Container(
        color: Colors.white,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 12,
            ),
            SvgPicture.asset(
              data['icon'],
              package: 'profile',
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              data['name'],
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            const Spacer(),
            if (data['type'] == ProfileListItemType.VersionInfo)
              Text(_versionName),
            const GoNextIcon(
              size: 36,
            ),
            const SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }

  _launchGooglePlay() async {
    const String appId = 'YOUR_APP_PACKAGE_NAME'; // 将YOUR_APP_PACKAGE_NAME替换为你要跳转的应用的包名
    const url = 'https://play.google.com/store/apps/details?id=$appId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '无法打开Google Play';
    }
  }

  _launchAppStore() async {
    const String appId = 'YOUR_APP_ID'; // 将YOUR_APP_ID替换为你要跳转的应用的App ID
    const url = 'itms-apps://itunes.apple.com/app/id$appId';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '无法打开应用商店';
    }
  }
}
