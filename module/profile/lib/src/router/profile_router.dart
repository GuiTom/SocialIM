import 'package:base/base.dart';
import 'package:flutter/material.dart';
import '../profile_page.dart';
import '../profile_pre_enter_page.dart';

class ProfileRouter implements IProfileRouter {
  @override
 Future toProfilePage(
      {int? uid,User?user,bool isSelf = false}){
    return ProfilePage.show(Constant.context, uid, user,isSelf);
  }
  @override
  Future toProfilePreEnterPage(){
    return ProfilePreEnterPage.show(Constant.context);
  }
  @override
  Widget getProfilePage(){
    return const ProfilePage(isSelf:true);
  }
}