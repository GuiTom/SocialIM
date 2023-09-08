import 'package:base/base.dart';
import 'package:discover/src/discover_api.dart';


class DynamicBlackListRepository extends LoadingMoreBase<Dynamic> {
  bool _hasMore = true;

  @override
  bool get hasMore => _hasMore;
  // int _page = 1;
  // final _pageSize = 20;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    isLoading = false;
    // _page = 1;
    _hasMore = true;
    return super.refresh(notifyStateChanged);
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    // final page = isloadMoreAction ? _page + 1 : 1;
    if (!isloadMoreAction) {
      clear();
    }
    DynamicListResp resp = await DiscoverAPI.getDynamicBlackList();

    if (resp.code == 1) {
      addAll(resp.data);
      // _page = page;
      _hasMore = false;
      return true;
    }
    return false;
  }
}
