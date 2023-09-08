import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';


abstract class IContactsRouter extends IModuleRouter {
  Future toContactsPage({required tabIndex});
  Widget getContactsPage();
}
