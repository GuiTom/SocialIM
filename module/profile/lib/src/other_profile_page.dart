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

class OtherProfilePage extends StatefulWidget {
  static Future show(BuildContext context, int? uid, User? user) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => OtherProfilePage(
          uid: uid,
          user: user,
        ),
        settings: const RouteSettings(name: '/OtherProfilePage'),
      ),
    );
  }

  final User? user;
  final int? uid;

  const OtherProfilePage({super.key, this.user, this.uid});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<OtherProfilePage> {
  User? _user;
  bool _loading = true;
  int? _uid;

  @override
  void initState() {
    super.initState();
    _uid = widget.uid;

    _user = widget.user;

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

                  const SizedBox(
                    height: 30,
                  ),
                  _buildUserLevelInfoRow(),

                  const SizedBox(
                    height: 30,
                  ),
                 _buildChatEntrancesWideget(),
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
        //   IAPPage.show(context);
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
