import 'package:base/base.dart';
import 'package:discover/src/widget/comment_edit_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base/src/locale/k.dart' as BaseK;
import 'package:flutter/services.dart';
import 'context_menu_mixin.dart';
import 'discover_api.dart';
import 'locale/k.dart';
import 'model/comment_repository.dart';

class DynamicDetailPage extends StatefulWidget {
  final Dynamic item;

  const DynamicDetailPage({super.key, required this.item});

  static Future<bool?> show(BuildContext context, Dynamic item) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => DynamicDetailPage(
          item: item,
        ),
        settings: const RouteSettings(name: '/DynamicDetailPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DynamicDetailPage> with ContextMenuMixin{
  final CommentRepository _repository = CommentRepository();
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _repository.dynamicId = widget.item.id.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFE1E1E1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () async {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back, color: Colors.black)),
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
      body: SafeArea(
        child: _buildDynmicInfo(context, widget.item),
      ),
    );
  }

  Widget _buildDynmicInfo(BuildContext context, Dynamic item) {
    return Padding(
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
              _buildNickNameAndContentTimeWidget(item),
              const Spacer(),

                InkWell(
                    onTap: () {
                      showIOSActionSheet(context, item);
                    },
                    child: const Icon(Icons.more_vert_outlined))
            ],
          ),
          Text(item.content),
          const SizedBox(
            height: 12,
          ),
          if (item.attachment.isNotEmpty) ...[
            _buildImages(item),
            const SizedBox(height: 12)
          ],
          if (widget.item.commentCount > 0)
            Text(K.getTranslation('comment_count',
                args: [widget.item.commentCount])),
          if (widget.item.commentCount > 0) _buildCommentListView(),
          _buildBottomLikeAndCommentButtons(item),
        ],
      ),
    );
  }

  Widget _buildImages(Dynamic item) {
    return Wrap(
      runSpacing: 3,
      spacing: 3,
      children: TypeUtil.parseList(item.attachment, (e) => e)
          .mapIndexed(
            (index,e) => GestureDetector(
              onTap:(){
               List<String> imageUrls = TypeUtil.parseList(item.attachment,
                      (e) => System.file('/file/$e'),);
               ImageViewer.show(context, imageUrls: imageUrls, initIndex: index);
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
            ),
          )
          .toList(),
    );
  }


  Widget _buildNickNameAndContentTimeWidget(Dynamic item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.nickName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          TimeUtil.translatedTimeStr(item.createAt.toInt()),
        )
      ],
    );
  }

  Widget _buildBottomLikeAndCommentButtons(Dynamic item) {
    List<Map<String, dynamic>> likeList =
        TypeUtil.parseList(item.likeInfo, (e) => e);
    bool liked =
        likeList.firstWhereOrNull((element) => element['uid'] == Session.uid) !=
            null;
    return Container(
      padding:
          const EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () async {
              if (liked) {
                Resp resp =
                    await DiscoverAPI.dynamicCancelLike(item.id.toInt());
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  liked ? 'assets/icon_liked.png' : 'assets/icon_unliked.png',
                  package: 'discover',
                  width: 24,
                  height: 24,
                ),
                Text(K.getTranslation('like'),
                    style: const TextStyle(color: Color(0xFF616161))),
              ],
            ),
          ),
          GestureDetector(
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
                  _repository.add(resp.data);
                  _repository.setState();
                  setState(() {});
                }
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/icon_comment.png',
                  package: 'discover',
                  width: 24,
                  height: 24,
                ),
                Text(
                  K.getTranslation('submit_comment'),
                  style: const TextStyle(color: Color(0xFF616161)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommentListView() {
    return Expanded(
      child: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await _repository.refresh();
        },
        child: LoadingMoreList<Comment>(
          ListConfig<Comment>(
            itemBuilder: (context, item, index) =>
                _buildRow(context, index, item),
            sourceList: _repository,
            indicatorBuilder: _indicatorBuilder,
            padding: const EdgeInsetsDirectional.all(0),
            //isLastOne: false
          ),
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, int index, Comment item) {
    bool liked =
        TypeUtil.parseMap(item.likeInfo).containsKey(Session.uid.toString());
    return Container(
      padding: const EdgeInsetsDirectional.only(bottom: 6, top: 6),
      child: Row(
        children: [
          UserHeadWidget(
              imageUrl: Util.getHeadIconUrl(item.senderUid), size: 50),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.senderName,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
                Text(
                    item.replayTargetName.isNotEmpty
                        ? '@${item.replayTargetName}: ${item.content}'
                        : item.content,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF616161))),
                Row(
                  children: [
                    Text(
                      TimeUtil.translatedTimeStr(item.createAt.toInt()),
                      style: const TextStyle(color: Color(0xFF919191)),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () async {
                        String? content = await CountEditWidget.show(context);
                        if (content?.isNotEmpty ?? false) {
                          SubmitCommentResp resp =
                              await DiscoverAPI.submitCommentReply(
                                  widget.item.id.toInt(),
                                  content!,
                                  item.senderName);
                          if (resp.code == 1) {
                            _repository.add(resp.data);
                            _repository.setState();
                          }
                        }
                      },
                      child: Text(
                        K.getTranslation('reply'),
                        style: const TextStyle(
                            color: Color(0xFF919191), fontSize: 12),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              Map likeInfo = TypeUtil.parseMap(item.likeInfo);
              if (likeInfo[Session.uid.toString()] == null) {
                Resp resp = await DiscoverAPI.commentAddLike(item.id.toInt());
                if (resp.code == 1) {
                  likeInfo[Session.uid.toString()] = Session.userInfo.name;
                  item.likeInfo = TypeUtil.parseString(likeInfo);
                  setState(() {});
                }
              } else {
                Resp resp =
                    await DiscoverAPI.commentCancelLike(item.id.toInt());
                if (resp.code == 1) {
                  likeInfo.remove(Session.uid.toString());
                  item.likeInfo = TypeUtil.parseString(likeInfo);
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
        ],
      ),
    );
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


