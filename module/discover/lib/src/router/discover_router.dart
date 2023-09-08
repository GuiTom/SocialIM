import 'package:base/base.dart';
import 'package:discover/src/blacklist/dynamic_blacklist_page.dart';
import 'package:discover/src/widget/my_discovers_page.dart';

import 'package:flutter/material.dart';

import '../discover_page.dart';
class DiscoverRouter implements IDiscoverRouter {
  @override
  Future toDiscoverPage({required tabIndex}) {
    return DiscoverPage.show(
      Constant.context,
      tabIndex,
    );
  }
  @override
  Future toMyDiscoverPage() {
    return MyDiscoversPage.show(
      Constant.context,
    );
  }
  GlobalKey<State> globalKey = GlobalKey<DiscoverPageState>();
  @override
  Widget getDiscoverPage(){
    return  DiscoverPage(key:globalKey);
  }
  @override
  Widget getDynamicBlackListPage(){
    return  const DynamicBlackListPage();
  }



}
