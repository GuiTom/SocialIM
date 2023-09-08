import 'package:base/base.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_room/live_room.dart';
import 'package:login/login.dart';
import 'package:message/message.dart';
import 'package:profile/profile.dart';
import 'package:contacts/contacts.dart';
import 'package:discover/discover.dart';

import 'boot_api.dart';
import 'dart:io';

class Boot {
  static Future init() async{
    await Constant.initDiertory();
    await PrefsHelper.init();
    await initRouterManager();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // 设置状态栏颜色为透明
    ));
   Constant.isIos = Platform.isIOS;
    IMessageRouter messageRouter = (RouterManager.instance
        .getModuleRouter(ModuleType.Message) as IMessageRouter)!;
    messageRouter.listenMessage();
    initFireBase();

  }
  static initRouterManager() async{
    RouterManager.instance.addModuleRouter(ModuleType.Login, LoginRouter());
    RouterManager.instance.addModuleRouter(ModuleType.Message, MessageRouter());
    RouterManager.instance.addModuleRouter(ModuleType.Profile, ProfileRouter());
    RouterManager.instance.addModuleRouter(ModuleType.LiveRoom, LiveRoomRouter());
    RouterManager.instance.addModuleRouter(ModuleType.Contacts, ContactsRouter());
    RouterManager.instance.addModuleRouter(ModuleType.Discover, DiscoverRouter());
  }

  static initFireBase() async{
      // await setupFlutterNotifications();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    dog.d('fcmToken:$fcmToken');
    Constant.pushToken = fcmToken??'';
    BootApi.reportPushToken(Constant.pushToken);
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      dog.d('fcmToken:$fcmToken');
      Constant.pushToken = fcmToken;
      BootApi.reportPushToken(Constant.pushToken);
    })
        .onError((err) {
      // Error getting token.
      dog.d('err:$err');
    });
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus == AuthorizationStatus.authorized||settings.authorizationStatus == AuthorizationStatus.provisional){
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print('Message also contained a notification: ${message.notification}');
        }
      });
    }
    eventCenter.addListener('logout', (type, data) {
      Constant.pushToken = '';
      BootApi.reportPushToken(Constant.pushToken);
    });

  }
}
