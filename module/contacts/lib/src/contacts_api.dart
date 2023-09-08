import 'package:base/base.dart';

class ContactsAPI {

  static Future<FriendListResp> getFriends() async {
    String url = System.api('/api/user/getFriends');
    Map<String, dynamic> params = {
      'uid': Session.uid,
    };
    FriendListResp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: FriendListResp.create());
    return resp;
  }
  static Future<FriendListResp> getFansList() async {
    String url = System.api('/api/user/getFansList');
    Map<String, dynamic> params = {
      'uid': Session.uid,
    };
    FriendListResp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: FriendListResp.create());
    return resp;
  }
  static Future<FocusListResp> getFocusList() async {
    String url = System.api('/api/user/getFocusList');
    Map<String, dynamic> params = {'uid': Session.uid};
    FocusListResp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: FocusListResp.create());
    return resp;
  }
  static Future<Resp> addFriend(int otherUid) async {
    String url = System.api('/api/user/addFriend');
    Map<String, dynamic> params = {'uid': Session.uid, 'otherUid': otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> removeFriend(int otherUid) async {
    String url = System.api('/api/user/removeFriend');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  static Future<Resp> removeFocus(int otherUid) async {
    String url = System.api('/api/user/removeFocus');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
  }
  //拉黑某人
  static putUserToBlackList(int otherUid) async {
    Resp resp = await Net.post(
        url: System.api('/api/user/putUserToBlackList'),
        pb: true,
        params: {
          'otherUid': otherUid,
          'uid': Session.uid,
        },
        pbMsg: Resp.create());
    if (resp.code != 1) {
      ToastUtil.showCenter(msg: resp.message);
    }
    return resp;
  }
  static Future<Resp> addFocus(int otherUid) async {
    String url = System.api('/api/user/addFocus');
    Map<String, dynamic> params = {'uid':Session.uid,'otherUid':otherUid};
    Resp resp = await Net.post(
        url: url, pb: true, params: params, pbMsg: Resp.create());
    return resp;
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

  static Future<UserListResp> getUserList(int pageNo, int pageSize) async {
    UserListResp userListResp = await Net.post(
        url: System.api('/api/user/list'),
        pb: true,
        params: {
          'sex': 0,
          'uid': Session.uid,
          'pageNo': pageNo,
          'pageSize': pageSize
        },
        pbMsg: UserListResp.create());
    if (userListResp.code != 1) {
      ToastUtil.showCenter(msg: userListResp.message);
    }
    return userListResp;
  }
}
