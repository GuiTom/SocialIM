import 'package:permission_handler/permission_handler.dart';
import '../../base.dart';
class PermissionUtil{
// 检测麦克风权限并执行相应操作
 static Future<PermissionStatus> checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      // 麦克风权限已经被授予
      dog.d('麦克风权限已被授予');
      // 执行麦克风相关操作
    } else if (status.isDenied) {
      // 麦克风权限被拒绝，可以再次请求
      dog.d('麦克风权限被拒绝');
      status = await _requestMicrophonePermission();
    } else if (status.isPermanentlyDenied) {
      // 麦克风权限被永久拒绝，需要用户手动授予权限
      dog.d('麦克风权限被永久拒绝');
      // 引导用户打开应用设置页面，让用户手动授予权限
    }
    return status;
  }

// 请求麦克风权限的方法
 static Future<PermissionStatus> _requestMicrophonePermission() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      // 麦克风权限已经被授予
      dog.d('麦克风权限已被授予');
      // 执行麦克风相关操作
    } else if (status.isDenied) {
      // 麦克风权限被拒绝，但是可以再次请求
      dog.d('麦克风权限被拒绝');

    } else if (status.isPermanentlyDenied) {
      // 麦克风权限被永久拒绝，需要用户手动授予权限
      dog.d('麦克风权限被永久拒绝');
      // 引导用户打开应用设置页面，让用户手动授予权限
    }
    return status;
  }
  

}