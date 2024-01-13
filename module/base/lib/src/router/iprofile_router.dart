import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';


abstract class IProfileRouter extends IModuleRouter {
  Future toProfilePage(
  {int? uid,User?user,bool isSelf = false});
  Future toOtherProfilePage(
      {int? uid,User?user,bool isSelf = false});
  Future toProfilePreEnterPage();
  Widget getProfilePage();
}
