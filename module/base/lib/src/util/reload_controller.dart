import 'package:flutter/cupertino.dart';

mixin ReloadController on StatefulWidget{
 Future<bool> reload(){
    return Future.value(true);
  }
}