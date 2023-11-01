import 'dart:io';

import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
class Constant {
  Constant._();
  static String get serverUrl {
    if (isDebug) {
      if (PrefsHelper.getValue('server_env_is_debug', true)) {
        return debugServertUrl;
      } else {
        return releaseServerUrl;
      }
    } else {
      return releaseServerUrl;
    }
  }

  static String get socketUrl {
    if (isDebug) {
      if (PrefsHelper.getValue('server_env_is_debug', true)) {
        return debugSocketUrl;
      } else {
        return releaseSocketUrl;
      }
    } else {
      return releaseSocketUrl;
    }
  }

  static const String debugSocketUrl = 'ws://192.168.1.12:8086/ws';

  static const String releaseSocketUrl = 'ws://13.212.217.161/ws';

  static const String debugServertUrl = 'http://192.168.1.12:8080';

  static const String releaseServerUrl = 'http://13.212.217.161';
  static const String agroaAppId = "0a3d1efd4a7d4ed4a057a0ee869cfcfb";
  static bool get isDebug {
    if (const bool.fromEnvironment('dart.vm.product')&&!const bool.fromEnvironment('debug_mode')) {
      // 发布（release）环境
      return false;
    } else {
      // 调试（debug）环境
      return true;
    }
  }

  static Future initDiertory() async {
    temporaryDirectory = await getTemporaryDirectory();
    documentsDirectory = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid) {
      externalStorageDirectory = await getExternalStorageDirectory();
    }
  }
  static set globalConfig(GlobalConfig config){
      latestVersionCodeAndroid = config.latestVersionCodeAndroid;
      latestVersionCodeIOS = config.latestVersionCodeIOS;
      downloadPageAndriod = config.downloadPageAndroid;
      downloadPageIOS = config.downloadPageIos;
      customerServicePhone = config.customerServicePhone;
      customerServiceWechat = config.customerServiceWechat;
  }
  static int latestVersionCodeAndroid = 0;
  static int latestVersionCodeIOS = 0;
  static String downloadPageAndriod = '';
  static String downloadPageIOS = '';
  static String customerServicePhone = '';
  static String customerServiceWechat = '';
  static Directory? documentsDirectory;
  static Directory? temporaryDirectory;
  static Directory? externalStorageDirectory;
  static int totalUnReadMsgCount = 0;
  static String pushToken = '';
  static bool isIos = false;
  static late BuildContext context;
}
