import 'package:base/base.dart';

class HomeApi {
  static Future<LiveRoomListResp> getliveList(
      {required int page, int size = 50}) async {
    return Net.post(
        url: System.api('/api/room/livelist'),
        pb: true,
        params: {},
        pbMsg: LiveRoomListResp.create());
  }

  static Future<UserListResp> getUserList(
      {required int sex, required int page, int size = 50}) async {
    return Net.post(
        url: System.api('/api/user/list'),
        pb: true,
        params: {
          'uid': Session.uid,
          'sex': sex,
          "pageNo": page,
          "pageSize": size
        },
        pbMsg: UserListResp.create());
  }
  static Future<UserListResp> searchUsers(String keyWord,int pageNo, int pageSize) async {
    String url = System.api('/api/user/searchUsers');
    Map<String, dynamic> params = {
      'uid': Session.uid,
      'keyword':keyWord,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    UserListResp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: UserListResp.create());
    return resp;
  }
}
