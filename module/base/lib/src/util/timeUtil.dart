import 'package:intl/intl.dart';
import '../locale/k.dart';

class TimeUtil {
  static String translatedTimeStr(int millSeconds) {
    if (DateTime
        .now()
        .millisecondsSinceEpoch - millSeconds < 1800 * 1000) { //
      return K.getTranslation('just_now');
    } else if (DateTime
        .now()
        .millisecondsSinceEpoch - millSeconds < 24 * 3600 * 1000) { //少于一天
      return DateFormat('HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(millSeconds));
    } else {
      return DateFormat(K.getTranslation('date_str', args: ['yyyy', 'M', 'd']))
          .format(DateTime.fromMillisecondsSinceEpoch(millSeconds));
    }
  }

  static DateTime addOneMonth(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;

    // 计算下个月的月份和年份
    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }

    // 确保不会超出下个月的最大天数
    int maxDayInNextMonth = DateTime(year, month + 1, 0).day;
    if (day > maxDayInNextMonth) {
      day = maxDayInNextMonth;
    }

    return DateTime(
        year, month, day, dateTime.hour, dateTime.minute, dateTime.second);
  }
  static DateTime addOneYear(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    // 计算下一年的年份
    year++;
    // 确保不会超出下一年的最大天数
    int maxDayInNextYear = DateTime(year + 1, 0, 0).day;
    if (day > maxDayInNextYear) {
      day = maxDayInNextYear;
    }
    return DateTime(year, month, day, dateTime.hour, dateTime.minute, dateTime.second);
  }
}