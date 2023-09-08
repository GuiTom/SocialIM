// @dart=2.12
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CommonLoading {

  static bool? _isShow;

  static bool get isShow => _isShow == true;

  static Future<void> show({String? status, Widget? indicator, EasyLoadingMaskType? maskType, bool? dismissOnTap}) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorType = EasyLoadingIndicatorType.ring;

    if (_isShow == null) {
      _isShow = false;
      EasyLoading.addStatusCallback((status) {
        _isShow = status == EasyLoadingStatus.show;
      });
    }

    return EasyLoading.show(status: status, indicator: indicator, maskType: maskType, dismissOnTap: dismissOnTap);
  }

  static Future<void> dismiss({
    bool animation = true,
  }) {
    // cancel timer
    return EasyLoading.dismiss(animation: animation);
  }
}
