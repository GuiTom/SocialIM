import 'package:base/base.dart';
import 'package:discover/src/dynamic_detail_page.dart';
import 'package:discover/src/model/my_discover_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../context_menu_mixin.dart';
import '../discover_api.dart';
import 'package:base/src/locale/k.dart' as BaseK;
import '../widget/comment_edit_widget.dart';
import '../discover_submit_page.dart';
import '../locale/k.dart';

class MyDiscoversPage extends StatefulWidget with ReloadController {
  @override
  Future<bool> reload() {
    (key as GlobalKey<MyDiscoversPageState>)
        .currentState
        ?.refreshKey
        .currentState
        ?.show();

    return Future.value(true);
  }

  const MyDiscoversPage({super.key});

  static GlobalKey<State> globalKey = GlobalKey<MyDiscoversPageState>();

  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => MyDiscoversPage(
          key: globalKey,
        ),
        settings: const RouteSettings(name: '/MyDiscoversPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => MyDiscoversPageState();
}

class MyDiscoversPageState extends State<MyDiscoversPage> with ContextMenuMixin {
  @override
  Future<bool> reload() {
    return Future(() => true);
  }

  final MyDiscoverRepository _repository = MyDiscoverRepository();
  final GlobalKey<RefreshIndicatorState> refreshKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(K.getTranslation('my_works')),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            actions: [
              InkWell(
                onTap: () async {
                  await DiscoverSubmitPage.show(context);
                  await refreshKey.currentState?.show();
                },
                child: const Padding(
                  padding: EdgeInsetsDirectional.only(end: 8),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
              padding: const EdgeInsetsDirectional.only(top: 15),
              child: _buildBody()),
        ));
  }

  Widget _buildBody() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await _repository.refresh();
      },
      child: LoadingMoreList<Dynamic>(
        ListConfig<Dynamic>(
          itemBuilder: (context, item, index) =>
              _buildRow(context, index, item),
          sourceList: _repository,
          indicatorBuilder: _indicatorBuilder,
          padding: const EdgeInsetsDirectional.all(0),
          //isLastOne: false
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, int index, Dynamic item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        bool? result = await DynamicDetailPage.show(Constant.context, item);
        if (result == true) {
          _repository.remove(item);
        }
        _repository.setState();
      },
      child: Padding(
        padding:
        const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                UserHeadWidget(
                    imageUrl: Util.getHeadIconUrl(item.uid),
                    size: 60,
                    uid: item.uid),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nickName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      TimeUtil.translatedTimeStr(item.createAt.toInt()),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                    onTap: () {
                      showIOSActionSheet(context, item, needPopPage: false,
                          onComplete: () {
                            refreshKey.currentState?.show();
                          });
                    },
                    child: const Icon(Icons.more_vert_outlined)),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),
            Text(item.content),
            const SizedBox(
              height: 12,
            ),
            Wrap(
              runSpacing: 3,
              spacing: 3,
              children: TypeUtil.parseList(item.attachment, (e) => e)
                  .mapIndexed((index, e) => GestureDetector(
                onTap: () {
                  ImageViewer.show(context,
                      imageUrls: TypeUtil.parseList(item.attachment,
                              (e) => System.file('/file/$e')),
                      initIndex: index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: System.file('/file/$e'),
                    width: 80,
                    // height: 80,
                    memCacheWidth: 80,
                    // memCacheHeight: 80,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ))
                  .toList(),
            ),
            const SizedBox(height: 5),
            _buildLikeAndCommentButtonRow(item),
            const SizedBox(height: 4),
            if (item.firstCommentInfo.isNotEmpty) ..._buildFirstComment(item),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeAndCommentButtonRow(Dynamic item) {
    List<Map<String, dynamic>> likeList =
    TypeUtil.parseList(item.likeInfo, (e) => e);
    bool liked =
        likeList.firstWhereOrNull((element) => element['uid'] == Session.uid) !=
            null;
    return Row(
      children: [
        InkWell(
          onTap: () async {
            if (liked) {
              Resp resp = await DiscoverAPI.dynamicCancelLike(item.id.toInt());
              if (resp.code == 1) {
                likeList
                    .removeWhere((element) => element['uid'] == Session.uid);
                item.likeInfo = TypeUtil.parseString(likeList);
                setState(() {});
              }
            } else {
              Resp resp = await DiscoverAPI.dynamicAddLike(item.id.toInt());
              if (resp.code == 1) {
                likeList
                    .add({'uid': Session.uid, 'name': Session.userInfo.name});
                item.likeInfo = TypeUtil.parseString(likeList);
                setState(() {});
              }
            }
          },
          child: Image.asset(
            liked ? 'assets/icon_liked.png' : 'assets/icon_unliked.png',
            package: 'discover',
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '${likeList.length}',
          style: const TextStyle(color: Color(0xFF919191), fontSize: 12),
        ),
        const SizedBox(
          width: 12,
        ),
        InkWell(
          onTap: () async {
            String? content = await CountEditWidget.show(context);
            if (content != null) {
              SubmitCommentResp resp =
              await DiscoverAPI.submitComment(item.id.toInt(), content);
              if (resp.code == 1) {
                if (item.firstCommentInfo.isEmpty) {
                  item.firstCommentInfo = TypeUtil.parseString({
                    'Id': resp.data.id.toInt(),
                    'SenderName': Session.userInfo.name,
                    'Content': content
                  });
                }
                item.commentCount += 1;
                _repository.setState();
              }
            }
          },
          child: Image.asset(
            'assets/icon_comment.png',
            package: 'discover',
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          '${item.commentCount}',
          style: const TextStyle(color: Color(0xFF919191), fontSize: 12),
        ),
      ],
    );
  }

  List<Widget> _buildFirstComment(Dynamic item) {
    Map<String, dynamic> comment = TypeUtil.parseMap(item.firstCommentInfo);
    return <Widget>[
      Row(
        children: [
          Text(
            '${comment['SenderName']}:',
            style: const TextStyle(
              color: Color(0xFF6666EE),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            comment['Content'] ?? '',
            style: const TextStyle(
              color: Color(0xFF616161),
              fontSize: 12,
            ),
          ),
        ],
      ),
      if (item.commentCount > 0)
        Text(
          '${K.getTranslation('view_more_comment')}>>',
          style: const TextStyle(color: Color(0xFF919191), fontSize: 14),
        ),
    ];
  }

  Widget _indicatorBuilder(BuildContext context, IndicatorStatus status) {
    if (status == IndicatorStatus.loadingMoreBusying) {
      return LoadingFooter(
        hasMore: _repository.hasMore,
      );
    } else if (status == IndicatorStatus.fullScreenBusying) {
      return const Loading();
    } else if (status == IndicatorStatus.noMoreLoad) {
      return const LoadingFooter(
        hasMore: false,
      );
    } else if (status == IndicatorStatus.fullScreenError) {
      return ErrorData(
        error: BaseK.K.getTranslation('data_error'),
        onTap: () async {
          await refreshKey.currentState?.show();
        },
      );
    } else if (status == IndicatorStatus.error) {
      return LoadingFooter(
          errorMessage: BaseK.K.getTranslation('error_data'),
          loadMore: _repository.loadMore);
    } else if (status == IndicatorStatus.empty) {
      return ErrorData(
        error: BaseK.K.getTranslation('no_data'),
        onTap: () {
          refreshKey.currentState?.show();
        },
      );
    }
    return const LoadingFooter(hasMore: true);
  }
}
