import 'package:base/base.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:base/src/locale/k.dart' as BaseK;
import 'package:profile/src/blacklist/user_blacklist_page.dart';
import 'package:profile/src/model/user_blacklist_repository.dart';

import '../locale/k.dart';

class BlackListPage extends StatefulWidget with ReloadController {
  @override
  Future<bool> reload() {
    (key as GlobalKey<UserBlackListPageState>)
        .currentState
        ?.refreshKey
        .currentState
        ?.show();

    return Future.value(true);
  }

  const BlackListPage({super.key});

  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const BlackListPage(),
        settings: const RouteSettings(name: '/BlackListPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => BlackListPagePageState();
}

class BlackListPagePageState extends State<BlackListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Future<bool> reload() {
    return Future(() => true);
  }

  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        // elevation: 0,
        title: Text(K.getTranslation('blacklist_setting')),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
          padding: const EdgeInsetsDirectional.only(top: 15),
          child: _buildBody()),
    ));
  }

  Widget _buildBody() {
    IDiscoverRouter discoverRouter = (RouterManager.instance
        .getModuleRouter(ModuleType.Discover) as IDiscoverRouter);
    return Column(
      children: [
        TabBar(
          tabs: [
            K.getTranslation('users'),
            K.getTranslation('works'),
          ].map((e) => Text(e,style: const TextStyle(color:Colors.black),)).toList(),
          controller: _controller,
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: [
              const UserBlackListPage(),
              discoverRouter.getDynamicBlackListPage()
            ],
          ),
        ),
      ],
    );
  }
}
