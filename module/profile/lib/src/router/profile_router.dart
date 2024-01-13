import 'package:base/base.dart';
import 'package:flutter/material.dart';
import '../other_profile_page.dart';
import '../profile_page.dart';
import '../profile_pre_enter_page.dart';

class ProfileRouter implements IProfileRouter {
  @override
 Future toProfilePage(
      {int? uid,User?user,bool isSelf = false}){
    return ProfilePage.show(Constant.context, uid, user);
  }
  @override
  Future toOtherProfilePage(
      {int? uid,User?user,bool isSelf = false}){
    return OtherProfilePage.show(Constant.context, uid, user);
  }
  @override
  Future toProfilePreEnterPage(){
    return ProfilePreEnterPage.show(Constant.context);
  }
  @override
  Widget getProfilePage(){
    return const ProfilePage();
  }
}