import 'package:base/base.dart';
import '../discover_api.dart';

class DiscoverRepository extends LoadingMoreBase<Dynamic> {
  bool _hasMore = true;

  @override
  bool get hasMore => _hasMore;
  int _page = 1;
  final _pageSize = 20;

  @override
  Future<bool> refresh([bool notifyStateChanged = false]) {
    isLoading = false;
    _page = 1;
    _hasMore = true;
    return super.refresh(notifyStateChanged);
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    final page = isloadMoreAction ? _page + 1 : 1;
    if (!isloadMoreAction) {
      clear();
    }
    DynamicListResp resp = await DiscoverAPI.getDynamicList(page, _pageSize);

    if (resp.code == 1) {
      Map<int, bool> blackDynMap = Session.blackDynMap;
      Map<int, bool> blackUidMap = Session.blackUidMap;
      addAll(resp.data.where((element) =>
          !blackDynMap.containsKey(element.id.toInt()) &&
          !blackUidMap.containsKey(element.uid))); //黑名单过滤
      _page = page;
      _hasMore = resp.hasMore;
      return true;
    }
    return false;
  }
}
