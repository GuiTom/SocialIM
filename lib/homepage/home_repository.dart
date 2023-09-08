import 'package:base/base.dart';
import '/homepage/protobuf/generated/room.pb.dart';
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
  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    isLoading =false;
    _hasMore = true;
    return super.refresh(notifyStateChanged);
  }
  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async{

    if (!isloadMoreAction) {
      clear();
    }

    LiveRoomListResp resp = await HomeApi.getliveList(page: 1,size: 10);
    LiveRoomItem partyItem = LiveRoomItem(resp.data);
    add(partyItem);
    GlobalConfigInfoResp globalConfigInfoResp = await ConfigApi.getGlobalConfig();
    if(globalConfigInfoResp.code==1){
      Constant.globalConfig = globalConfigInfoResp.data;
      add(GameItem(globalConfigInfoResp.games));
    }
    // add(TitleItem(K.getTranslation('make_friends')));
    return Future.value(true);

  }
}
