import 'package:base/base.dart';
import 'package:flutter/material.dart';

class MyAppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 应用退出到后台时触发的逻辑
      print("App paused: App is in the background");
      SocketRadio.instance.froze();
    } else if (state == AppLifecycleState.resumed) {
      // 应用从后台回到前台时触发的逻辑
      print("App resumed: App is in the foreground");
      SocketRadio.instance.cancelFroze();
      SocketRadio.instance.reconnect();
    }
  }
}
