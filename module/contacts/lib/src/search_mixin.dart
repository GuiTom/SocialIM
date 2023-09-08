import 'package:base/base.dart';
import 'package:flutter/material.dart';

mixin OnSearchMinxin<T extends StatefulWidget> on State<T> {
  List<User>? list;
  List<User>? allList;
  final GlobalKey<RefreshIndicatorState> refreshKey =
  GlobalKey<RefreshIndicatorState>();
  String keyWorld = '';
  void onSearch(String value) {
    keyWorld = value;
    if(value.isNotEmpty) {

      list = allList?.where((element) => element.name.toLowerCase().contains(value.toLowerCase())).toList();
    }else{

      list = allList;
    }
    setState(() {});
  }
  void refresh() {
    refreshKey.currentState?.show();
  }
}
