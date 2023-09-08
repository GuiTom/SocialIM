import 'package:base/base.dart';
import '../discover_api.dart';

class MyDiscoverRepository extends LoadingMoreBase<Dynamic> {

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
    DynamicListResp resp = await DiscoverAPI.getDynamicList(page, _pageSize,Session.uid);

    if (resp.code == 1) {
      addAll(resp.data); //黑名单过滤
      _page = page;
      _hasMore = resp.hasMore;
      return true;
    }
    return false;
  }
}
