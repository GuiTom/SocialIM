
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'boot_api.dart';
import 'developer/deveoper_ume.dart';
import 'app_lifecycle_oberver.dart';
import 'firebase_options.dart';
import 'homepage/widget/unread_dot_container.dart';
import 'locale/k.dart';
import 'boot.dart';
import 'homepage/index.dart';
import 'package:base/base.dart';
import 'dart:ui' as ui;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'locale/localizations.dart';
import 'package:line_icons/line_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:package_info/package_info.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Boot.init();


  runUmeApp(MaterialApp(
    title: 'GamePark',
    debugShowCheckedModeBanner: false,
    navigatorObservers: [defaultLifecycleObserver],
    initialRoute: '/',
    // 设置初始路由名称
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    locale: ui.window.locale,
    supportedLocales: const <Locale>[
      Locale(
        'en',
        'US',
      ),
      Locale(
        'zh',
        'CN',
      )
    ],
    routes: {
      '/': (context) => const MyHomePage(), // 将 HomeScreen 分配给根路由名称'/'
      // 添加其他路由映射，例如 '/details': (context) => DetailsScreen(),
    },
    theme: ThemeData(
      primarySwatch: Colors.purple,
    ),
  ));
  WidgetsBinding.instance.addObserver(MyAppLifecycleObserver());

}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(MyAppLifecycleObserver());
    super.dispose();
  }
  int? _lastUid;
  int a = 1;
  int _selectedIndex = 0;
  final GlobalKey<State> _homeGlobalKey = GlobalKey<HomeIndexPageState>();
  final List<Widget> _pages = [];
  Future<void> _setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }
  void _handleMessage(RemoteMessage message) {//点击系统消息通知横幅进来
      // dog.d('message1:$message');
      FlutterAppBadger.removeBadge();
      if(message.data['pushType']=='chatMessage') {
        String targetName = message?.notification?.title ?? '';
        if (targetName.isNotEmpty) {
          // int targetType = TypeUtil.parseInt(message.data['targetType'],1);
          int srcUid = TypeUtil.parseInt(message.data['srcUid']);
          IMessageRouter messageRouter = (RouterManager.instance
              .getModuleRouter(ModuleType.Message) as IMessageRouter);
          // dog.d('message2:$message');
          messageRouter.toChatPage(srcUid, targetName);
        }
      }
  }

  @override
  void initState() {
    super.initState();
    _setupInteractedMessage();
    _pages.add(
      HomeIndexPage(key: _homeGlobalKey),
    );
    IDiscoverRouter discoverRouter = (RouterManager.instance
        .getModuleRouter(ModuleType.Discover) as IDiscoverRouter);
    _pages.add(discoverRouter.getDiscoverPage());
    IMessageRouter messageRouter = (RouterManager.instance
        .getModuleRouter(ModuleType.Message) as IMessageRouter);
    _pages.add(messageRouter.getSessionListPage(1));
    IContactsRouter contactsRouter = (RouterManager.instance
        .getModuleRouter(ModuleType.Contacts) as IContactsRouter);
    _pages.add(contactsRouter.getContactsPage());
    IProfileRouter profileRouter = (RouterManager.instance
        .getModuleRouter(ModuleType.Profile) as IProfileRouter);
    _pages.add(profileRouter.getProfilePage());
    if(Session.uid>0){
      messageRouter.initSessions();
      SocketRadio.instance.reconnect();
    }
    eventCenter.addListener('userInfoChanged', (type, data) {

      if (_lastUid != Session.uid && Session.uid > 0) {

        messageRouter.initSessions();
        SocketRadio.instance.reconnect();
      } else {
        if (Session.uid <= 0) {
          SocketRadio.instance.close();
        }
      }
      _lastUid = Session.uid;
      if(Constant.pushToken.isNotEmpty){
        BootApi.reportPushToken(Constant.pushToken);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Constant.context = context;

    if (Session.uid == 0) {
      ILoginRouter? loginRouter = RouterManager.instance
          .getModuleRouter(ModuleType.Login) as ILoginRouter?;
      return loginRouter!.getPreLoginPage();
    } else if (!Session.passwordSetted && !Session.allowPasswordEmpty) {
      ILoginRouter? loginRouter = RouterManager.instance
          .getModuleRouter(ModuleType.Login) as ILoginRouter?;
      return loginRouter!
          .getPasswordSettingPage();
    }
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabSelected,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: K.getTranslation('home_page'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.panorama_fish_eye),
            label: K.getTranslation('discover'),
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              alignment: AlignmentDirectional.topEnd,
              children: const [
                Icon(Icons.message),
                PositionedDirectional(end: -15, child: UnReadDotContainer()),
              ],
            ),
            label: K.getTranslation('message_page'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(LineIcons.addressBook),
            label: K.getTranslation('contacts'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.perm_identity),
            label: K.getTranslation('profile_page'),
          ),
        ],
      ),
    );
  }

  void _onTabSelected(int index) {
    if (_selectedIndex == index && _pages[index] is ReloadController) {
      (_pages[index] as ReloadController).reload();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
