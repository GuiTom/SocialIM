import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../contacts_api.dart';
import '../locale/k.dart';
import '../search_mixin.dart';
import 'package:base/src/locale/k.dart' as BaseK;

class FansSubPage extends StatefulWidget {
  const FansSubPage({super.key});

  @override
  State<StatefulWidget> createState() => FansSubPageState();
}

class FansSubPageState extends State<FansSubPage>
    with SingleTickerProviderStateMixin, OnSearchMinxin {
  late final TabController _tabController;

  bool _isLoading = true;

  int _selectedRow = -1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _requestList();
  }

  void _requestList() async {
    _isLoading = true;
    FriendListResp resp = await ContactsAPI.getFansList();
    if (resp.code == 1) {
      Map<int, bool> blackUidMap = Session.blackUidMap;
      allList = resp.list
          .where((element) => !blackUidMap.containsKey(element.id.toInt()))
          .toList();
      onSearch(keyWorld);
      setState(() {});
    }
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Loading();
    }
    if (allList?.isEmpty ?? false) {
      return ErrorData(
        error: BaseK.K.getTranslation('no_data'),
        onTap: () {
          refreshKey.currentState?.show();
        },
      );
    }
    return _buildUserListView();
  }

  Widget _buildUserListView() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async {
        _requestList();
      },
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _buildRow(context, list![index], index);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 5,
            );
          },
          itemCount: list!.length),
    );
  }

  Widget _buildRow(BuildContext context, User item, int index) {
    return GestureDetector(
      onTap: () {
        IProfileRouter profileRouter = RouterManager.instance
            .getModuleRouter(ModuleType.Profile) as IProfileRouter;
        profileRouter.toOtherProfilePage(
            uid: item.id.toInt(), isSelf: Session.uid == item.id.toInt());
      },
      onLongPressStart: (LongPressStartDetails details) {
        _selectedRow = index;
        setState(() {});
        _showPopupMenu(context, item, details.globalPosition);
      },
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        color: _selectedRow == index ? const Color(0xFFE1E1E1) : Colors.white,
        child: Row(
          children: [
            UserHeadWidget(
                imageUrl: Util.getHeadIconUrl(item.id.toInt()), size: 50),
            const SizedBox(
              width: 5,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  K.getTranslation('now_online'),
                  style:
                      const TextStyle(color: Color(0xFF919191), fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onSearch(String value) {
    keyWorld = value;
    if (value.isNotEmpty) {
      list = allList
          ?.where((element) =>
              element.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    } else {
      list = allList;
    }
    setState(() {});
  }

  void _showPopupMenu(BuildContext context, User item, Offset offset) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromSize(
      Rect.fromLTWH(offset.dx, offset.dy, offset.dx, overlay.size.height),
      overlay.size,
    );
    // 弹出菜单
    showMenu<String>(
      context: context,
      position: position,
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '1',
          child: Text(K.getTranslation('block')),
        ),
      ],
    ).then((String? value) async {
      if (value != null) {
        print('value:$value');
        Resp resp = await ContactsAPI.putUserToBlackList(item.id.toInt());
        if (resp.code == 1) {
          Session.addUserBlackList(item.id.toInt());
          allList?.remove(item);
          list?.remove(item);
          ToastUtil.showCenter(msg: resp.message);
        }
      }
      _selectedRow = -1;
      setState(() {});
    });
  }
}
