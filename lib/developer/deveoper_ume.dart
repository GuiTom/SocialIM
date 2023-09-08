import 'package:base/base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ume/flutter_ume.dart'; // UME framework
import 'package:flutter_ume_kit_ui/flutter_ume_kit_ui.dart';

import 'developer_options_widget.dart'; // UI kits

void runUmeApp(Widget app) {
  if (Constant.isDebug) {
    PluginManager.instance
      ..register(DeveloperOptionsWidget()) // Register plugin kits
      ..register(const WidgetInfoInspector());
    // After flutter_ume 0.3.0
    runApp(UMEWidget(enable: true, child: app));
    // Before flutter_ume 0.3.0
  } else {
    runApp(app);
  }
}
