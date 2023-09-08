
import 'package:intl/intl.dart';
import '../locale/k.dart';
class TimeUtil{
  static String translatedTimeStr(int millSeconds) {
    if(DateTime.now().millisecondsSinceEpoch-millSeconds<1800*1000) { //
      return K.getTranslation('just_now');
    }else if(DateTime.now().millisecondsSinceEpoch-millSeconds<24*3600*1000){//少于一天
      return DateFormat('HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(millSeconds));
    }else {
     return DateFormat(K.getTranslation('date_str',args:['yyyy', 'M', 'd']))
          .format(DateTime.fromMillisecondsSinceEpoch(millSeconds));
    }
  }
}