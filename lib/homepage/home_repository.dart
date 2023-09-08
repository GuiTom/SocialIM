import 'package:base/base.dart';
import '../locale/k.dart';
import 'config_api.dart';
import 'home_api.dart';

abstract class HomePageItem {}

class HomeUserItem extends HomePageItem {
  final User data;
  final int position;

  HomeUserItem(this.data, this.position);
}

class LiveRoomItem extends HomePageItem {
  List<RoomInfo> data;

  LiveRoomItem(
    this.data,
  );
}

class TitleItem extends HomePageItem {
  String data;

  TitleItem(
    this.data,
  );
}

class GameItem extends HomePageItem {
  List<GameInfo> data;

  GameItem(
    this.data,
  );
}

class HomeRepository extends LoadingMoreBase<HomePageItem> {
  bool _hasMore = true;

  @override
  bool get hasMore => _hasMore;
  int _page = 0;
  String? keyWord;
  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    isLoading = false;
    _hasMore = true;
    _page = 0;

    return super.refresh(notifyStateChanged);
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    if (!isloadMoreAction) {
      clear();
    }

    LiveRoomListResp resp = await HomeApi.getliveList(page: 1, size: 20);
    LiveRoomItem partyItem = LiveRoomItem(resp.data);
    add(partyItem);
    if(keyWord?.isNotEmpty??false){
      UserListResp userListResp = await HomeApi.searchUsers(keyWord!,
            _page + 1,20);
      if (userListResp.code == 1) {
        _page = _page + 1;
        _hasMore = userListResp.hasMore;
        addAll(userListResp.data
            .mapIndexed((index, element) => HomeUserItem(element, index)));
        return true;
      }
    }else {
      UserListResp userListResp = await HomeApi.getUserList(
          sex: Session.userInfo.sex == 1 ? 2 : 1, page: _page + 1, size: 20);
      if (userListResp.code == 1) {
        _page = _page + 1;
        if(_page==1) {
          add(TitleItem(K.getTranslation('make_friends')));
        }
        _hasMore = userListResp.hasMore;
        addAll(userListResp.data
            .mapIndexed((index, element) => HomeUserItem(element, index)));
        return true;
      }
    }
    // GlobalConfigInfoResp globalConfigInfoResp = await ConfigApi.getGlobalConfig();
    // if(globalConfigInfoResp.code==1){
    //   Constant.globalConfig = globalConfigInfoResp.data;
    //   add(GameItem(globalConfigInfoResp.games));
    // }

    return Future.value(true);
  }
}
