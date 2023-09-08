import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';


abstract class IDiscoverRouter extends IModuleRouter {
  Future toDiscoverPage({required tabIndex});
  Future toMyDiscoverPage();
  Widget getDiscoverPage();
  Widget getDynamicBlackListPage();
}
