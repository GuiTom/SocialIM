import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:base/base.dart';
import 'package:flutter/services.dart';
import 'protobuf/generated/room.pb.dart';
import 'widget/home_live_room_item.dart';
import '../locale/k.dart';
import 'home_repository.dart';

class HomeIndexPage extends StatefulWidget with ReloadController {
  @override
  Future<bool> reload() {
    (key as GlobalKey<HomeIndexPageState>)
        .currentState
        ?.refreshKey
        .currentState
        ?.show();

    return Future.value(true);
  }

  const HomeIndexPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeIndexPageState();
  }
}

class HomeIndexPageState extends State<StatefulWidget> {
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  final HomeRepository _repository = HomeRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).padding.top),
              child: _buildUserListView(),
            ),
          )),
    );
  }

  Widget _buildUserListView() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        await _repository.refresh();
      },
      child: LoadingMoreList<HomePageItem>(
        ListConfig<HomePageItem>(
          itemBuilder: (context, item, index) => _buildRow(context, item),
          sourceList: _repository,
          autoLoadMore: false,
          indicatorBuilder: _indicatorBuilder,
          padding: const EdgeInsetsDirectional.all(0),
          //isLastOne: false
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, HomePageItem item) {
    if (item is LiveRoomItem) {
      return _buildPartyListWidget(item, true);
    } else if (item is GameItem) {
      return _buildGameListWidget(item);
    } else if (item is HomeUserItem) {
      return _buildHomeUserItemWidget(item);
    } else if (item is TitleItem) {
      return _buildTitleItem(item);
    }
    return Container();
  }

  Widget _buildTitleItem(TitleItem item) {
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 15),
      child: _buildLabel(item.data),
    );
  }

  Widget _buildHomeUserItemWidget(HomeUserItem item) {
    return ThrottleInkWell(
      onTap: () {
        IProfileRouter profileRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.Profile) as IProfileRouter)!;
        profileRouter.toProfilePage(user: item.data, isSelf: false);
      },
      child: Container(
        height: 80,
        margin: const EdgeInsetsDirectional.only(
            top: 5, bottom: 6, start: 8, end: 8),
        padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 阴影颜色
              spreadRadius: 1, // 阴影扩散的范围
              blurRadius: 2, // 阴影模糊程度
              offset: const Offset(0, 1), // 阴影偏移量
            ),
          ],
        ),
        child: Row(
          children: [
            UserHeadWidget(
                imageUrl: Util.getHeadIconUrl(item.data.id.toInt()),
                size: 50,
                isMale: Session.userInfo.sex == 1),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      item.data.name,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    SexAgeLabelWidget(
                        sex: item.data.sex,
                        age: Util.calculateAge(item.data.bornAt.toInt())),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  item.data.signature,
                  style: const TextStyle(
                      color: Color(0x2F111111),
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
            const Spacer(),
            _buildChatButton(item),
          ],
        ),
      ),
    );
  }

  Widget _buildGameListWidget(GameItem item) {
    return Container(
      margin: const EdgeInsetsDirectional.all(12),
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x1F111111),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 1)
        ],
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: item.data
            .map(
              (element) => _buildGameItemWidget(element),
            )
            .toList(),
      ),
    );
  }

  Widget _buildGameItemWidget(GameInfo info) {
    return ThrottleInkWell(
      onTap: () {
        ILiveRoomRouter liveRoomRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.LiveRoom) as ILiveRoomRouter)!;
        liveRoomRouter.toGamePage(
            gameId: info.id, gameName: info.name, gameUrl: info.url);
      },
      child: Column(
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x3F111111),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 1)
              ],
            ),
            child: CachedNetworkImage(
                imageUrl: info.iconUrl,
                width: (Util.width - 60),
                height: (Util.width - 60) / 2,
                fit: BoxFit.cover,
                placeholder: (
                  BuildContext context,
                  String url,
                ) {
                  return CupertinoActivityIndicator(
                    radius: (Util.width - 60) / 6,
                  );
                }),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            info.name,
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildChatButton(HomeUserItem item) {
    return ThrottleInkWell(
      onTap: () {
        IMessageRouter messageRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.Message) as IMessageRouter)!;
        messageRouter.toChatPage(item.data.id.toInt(), item.data.name);
      },
      child: Image.asset(
        'assets/home/ic_message.webp',
        width: 50,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildPartyListWidget(LiveRoomItem item, bool isResume) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            // color:Colors.red,
            alignment: AlignmentDirectional.center,
            height: 42,
            child: _buildPartyLabel()),
        SizedBox(
          height: 116,
          child: ListView.separated(
              padding: const EdgeInsetsDirectional.only(start: 16, end: 16),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                RoomInfo? indexRoom = index == 0 ? null : item.data[index - 1];
                return HomeLiveRoomItem(
                  roomInfo: indexRoom,
                  index: index,
                  isResume: isResume,
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 7);
              },
              itemCount: item.data.length + 1),
        ),
        const SizedBox(
          // color:Colors.green,
          height: 8,
        ),
        Container(
          alignment: AlignmentDirectional.centerStart,
          padding: const EdgeInsetsDirectional.only(start: 16),
          height: 42,
          // color:Colors.red,
          child: _buildLabel(K.getTranslation('games')),
        ),
      ],
    );
  }

  Widget _buildPartyLabel() {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            _buildLabel(K.getTranslation('live_voice_room')),
            const Spacer(),
            GestureDetector(
              child: const GoNextIcon(size: 24, color: Color(0xFF959595)),
              onTap: () {
                // eventCenter.emit('HomePage.JumpToLivePage'); //跳派对页面
              },
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          color: Color(0xFF313131), fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  Widget _indicatorBuilder(
    BuildContext context,
    IndicatorStatus status,
  ) {
    return Container();
  }
}
