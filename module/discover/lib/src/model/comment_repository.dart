import 'package:base/base.dart';

import '../discover_api.dart';


class CommentRepository extends LoadingMoreBase<Comment> {
  bool _hasMore = true;

  @override
  bool get hasMore => _hasMore;
  int _page = 1;
  final _pageSize = 20;
  late int dynamicId;
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
    CommentListResp resp = await DiscoverAPI.getCommentList(dynamicId,page, _pageSize);

    if (resp.code == 1) {
      addAll(resp.data);
      _page = page;
      _hasMore = resp.hasMore;
      return true;
    }
    return false;
  }
}
