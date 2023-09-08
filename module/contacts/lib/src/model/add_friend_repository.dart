import 'package:base/base.dart';

import '../contacts_api.dart';

class AddFriendRepository extends LoadingMoreBase<User> {
  String ?keyWord;
  bool _hasMore = true;
  @override
  bool get hasMore => _hasMore;
  int _page = 1;
  final _pageSize = 20;
  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    isLoading =false;
    _page = 1;
    _hasMore = true;
    return super.refresh(notifyStateChanged);
  }
  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async{
    final page = isloadMoreAction ? _page + 1 : 1;
    if (!isloadMoreAction) {

      clear();
    }
    UserListResp resp;
    if(keyWord?.isNotEmpty??false){
      resp = await ContactsAPI.searchUsers(keyWord!,page, _pageSize);
    }else {
      resp = await ContactsAPI.getUserList(page, _pageSize);
    }


    if(resp.code==1){
      addAll(resp.data);
      _page = page;
      _hasMore = resp.hasMore;
      return true;
    }
    return false;

  }
}
