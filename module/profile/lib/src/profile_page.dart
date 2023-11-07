import 'dart:io';

import 'locale/k.dart';
import 'package:base/src/locale/k.dart' as BaseK;
import 'package:flutter/cupertino.dart';
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profile/src/profile_api.dart';
import 'package:profile/src/profile_edit_page.dart';
import 'package:profile/src/setting_page.dart';
import 'package:profile/src/widget/profile_middle_list_widget.dart';

class ProfilePage extends StatefulWidget {
  static Future show(BuildContext context, int? uid, User? user, bool isSelf) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => ProfilePage(
          uid: uid,
          user: user,
          isSelf: isSelf,
        ),
        settings: const RouteSettings(name: '/ProfilePage'),
      ),
    );
  }

  final User? user;
  final int? uid;
  final bool isSelf;

  const ProfilePage({super.key, this.user, this.uid, required this.isSelf});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ProfilePage> {
  User? _user;
  bool _loading = true;
  int? _uid;

  @override
  void initState() {
    super.initState();
    _uid = widget.uid;
    if (widget.isSelf) {
      _user = widget.user ?? Session.userInfo;
    } else {
      _user = widget.user;
    }
    if (_user == null && _uid! > 0) {
      _loadUserInfo();
    } else {
      _loading = false;
    }
    eventCenter.addListener('userInfoChanged', (type, data) {
      _uid = Session.uid;
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future _loadUserInfo() async {
    UserInfoResp resp = await ProfileApi.getUserInfo(_uid!);
    _user = resp.data;
    _loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Loading();
    }
    if (widget.isSelf && Session.uid == 0) {
      return ThrottleInkWell(
        onTap: () async {},
        child: Center(
          child: Text(
            K.getTranslation('please_login'),
            style: const TextStyle(
                color: Color(0x3F111111), fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            K.getTranslation('somebody_s_profile', args: [
              '${_user!.name.safeSubstring(0, 10)}${_user!.name.length > 10 ? "..." : ""}'
            ]),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          ),
          actions: [
            if (widget.isSelf)
              ThrottleInkWell(
                onTap: () {
                  SettingPage.show(context);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12),
                  child: SvgPicture.asset(
                    'assets/icon_setting.svg',
                    package: 'profile',
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            if (!widget.isSelf)
              ThrottleInkWell(
                onTap: () {
                  showIOSActionSheet(context);
                },
                child: const Icon(Icons.more_horiz_outlined),
              )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constrant) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  _buildUserHeadRow(constrant),
                  const SizedBox(
                    height: 30,
                  ),
                  if (widget.isSelf) _buildContactsEntranceRow(),
                  const SizedBox(
                    height: 30,
                  ),
                  _buildUserLevelInfoRow(),
                  if (widget.isSelf) _buildOtherCloumns(),
                  const SizedBox(
                    height: 30,
                  ),
                  if (!widget.isSelf) _buildChatEntrancesWideget(),
                  const SizedBox(height: 20),
                ],
              );
            }),
          ),
        ));
  }

  void showIOSActionSheet(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(K.getTranslation('select_option')),
          actions: [
            CupertinoActionSheetAction(
              child: Text(K.getTranslation('cancel_focus')),
              onPressed: () async {
                // 执行操作 1
                int otherUid = widget.uid ?? widget.user?.id.toInt() ?? 0;
                if (otherUid > 0) {
                  Resp resp = await ProfileApi.removeFocus(otherUid);
                  if (resp.code == 1) {
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                }
              },
            ),
            CupertinoActionSheetAction(
              child: Text(K.getTranslation('block')),
              onPressed: () async {
                int otherUid = widget.uid ?? widget.user?.id.toInt() ?? 0;
                if (otherUid > 0) {
                  Resp resp = await ProfileApi.removeFriend(otherUid);
                  if (resp.code == 1) {
                    if (!mounted) return;
                    Navigator.pop(context);
                  }
                }
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(
              BaseK.K.getTranslation('cancel'),
              style: const TextStyle(color: Color(0xFF616161)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildContactsEntranceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        K.getTranslation('friends'),
        K.getTranslation('fans'),
        K.getTranslation('my_focus'),
        K.getTranslation('dynamics'),
      ]
          .mapIndexed(
            (i, e) => InkWell(
              onTap: () async {
                if(e!= K.getTranslation('dynamics')) {
                  IContactsRouter relastionshipRouter = RouterManager.instance
                      .getModuleRouter(ModuleType.Contacts) as IContactsRouter;
                  await relastionshipRouter.toContactsPage(tabIndex: i);
                }else {
                  IDiscoverRouter discoverRouter = RouterManager.instance.getModuleRouter(ModuleType.Discover) as IDiscoverRouter;
                  discoverRouter.toMyDiscoverPage();
                }
                setState(() {});
              },
              child: Column(
                children: [
                  Text(
                    [
                      Session.friendList.length,
                      Session.fansList.length,
                      Session.focusList.length,
                      Session.userInfo.worksCount,
                    ][i]
                        .toString(),
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    e,
                    style: const TextStyle(color: Color(0xFF919191)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildOtherCloumns() {
    return Container(
      clipBehavior: Clip.antiAlias,
      margin:
          const EdgeInsetsDirectional.symmetric(horizontal: 6, vertical: 18),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F111111),
              offset: Offset(1, 3),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ]),
      child: const ColoredBox(
        color: Color(0xFFF3F3F3),
        child: ProfileMiddleListWidget(),
      ),
    );
  }

  Widget _buildUserHeadRow(BoxConstraints constrant) {
    return Row(
      children: [
        const SizedBox(width: 12),
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            UserHeadWidget(
              imageUrl: Util.getHeadIconUrl(_user!.id.toInt()),
              size: 80,
              isMale: _user!.sex == 1,
            ),
            if (widget.isSelf)
              ThrottleInkWell(
                onTap: () async {
                  await ProfileEditPage.show(context);
                  _user = Session.userInfo;

                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 5, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.purple[100],
                  ),
                  child: Text(
                    K.getTranslation('profile_edit'),
                    style: const TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: constrant.maxWidth - 120,
              child: Text(
                _user!.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (_user!.id == Session.uid)
              ThrottleInkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: Session.uid.toString()));
                  ToastUtil.showTop(msg: K.getTranslation('userid_copyed'));
                },
                child: Row(
                  children: [
                    Text(
                      'ID: ${_user!.id}',
                      style: const TextStyle(
                          color: Color(0x5f111111),
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SvgPicture.asset(
                      'assets/icon_copy.svg',
                      package: 'profile',
                      width: 18,
                      height: 18,
                    ),
                  ],
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _buildUserLevelInfoRow() {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 6, end: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // 阴影颜色
            spreadRadius: 1, // 阴影扩散的范围
            blurRadius: 2, // 阴影模糊程度
            offset: const Offset(0, 1), // 阴影偏移量
          )
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                Text(
                  K.getTranslation('my_account'),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const SizedBox(
                  width: 20,
                  height: 20,
                ), //这里应该是金币图标，先占个位
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: _buildFortuneLevelWidget(),
              ),
              const SizedBox(
                width: 6,
              ),
              Expanded(
                child: _buildUserLevelWidget(),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildUserLevelWidget() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFFF1F1F1),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 12,
          ),
          Text(
            K.getTranslation('user_level'),
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            '${_user!.level}',
            style: const TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildFortuneLevelWidget() {
    return GestureDetector(
      onTap: (){
        // if(Platform.isIOS) {
          IAPPage.show(context);
        // }
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xFFF1F1F1),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            Text(
              K.getTranslation('gold_coin_count'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '${_user!.coin}',
              style: const TextStyle(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildChatEntrancesWideget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: ThrottleInkWell(
            onTap: () {
              IMessageRouter messageRouter = (RouterManager.instance
                  .getModuleRouter(ModuleType.Message) as IMessageRouter)!;
              messageRouter.toChatPage(_user!.id.toInt(), _user!.name);
            },
            child: Button(
              title: K.getTranslation('private_chat'),
              buttonSize: ButtonSize.Small,
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: ThrottleInkWell(
            onTap: () async {
              int otherUid = widget.uid ?? widget.user?.id.toInt() ?? 0;
              bool disabled = Session.friendList.contains(otherUid);
              if (disabled) return;
              if (otherUid > 0) {
                Resp resp = await ProfileApi.addFriend(otherUid);
                if (resp.code == 1) {
                  ToastUtil.showCenter(msg: resp.message);
                  Session.addFriend(otherUid);
                  setState(() {});
                }
              }
            },
            child: Button(
              title: K.getTranslation('add_friend'),
              buttonSize: ButtonSize.Small,
              disabled: Session.friendList
                  .contains(widget.uid ?? widget.user?.id.toInt() ?? 0),
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: ThrottleInkWell(
            onTap: () async {
              int otherUid = widget.uid ?? widget.user?.id.toInt() ?? 0;
              bool disabled = Session.focusList.contains(otherUid);
              if (disabled) return;
              if (otherUid > 0) {
                Resp resp = await ProfileApi.addFocus(otherUid);
                if (resp.code == 1) {
                  ToastUtil.showCenter(msg: resp.message);
                  Session.addFocus(otherUid);
                  setState(() {});
                }
              }
            },
            child: Button(
              title: K.getTranslation('add_focus'),
              buttonSize: ButtonSize.Small,
              disabled: Session.focusList
                  .contains(widget.uid ?? widget.user?.id.toInt() ?? 0),
            ),
          ),
        ),
        const SizedBox(
          width: 30,
        ),
      ],
    );
  }
}
