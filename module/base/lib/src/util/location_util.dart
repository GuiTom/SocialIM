import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class LocationUtil{
  static Future<Placemark?> getLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // 检查是否启用了位置服务
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // 位置服务未启用
        return null;
      }

      // 请求位置权限
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          // 位置权限被拒绝
          return null;
        }
      }
      // 获取当前位置的经纬度
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      // 根据经纬度获取地理信息
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      // 返回国家、省份、城市的字符串
      return placemarks.last;
    } catch (e) {
      // 处理异常
      return null;
    }
  }

}