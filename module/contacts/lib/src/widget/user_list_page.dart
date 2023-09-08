import 'package:base/base.dart';
import 'package:base/src/locale/k.dart' as BaseK;
import 'package:base/src/widget/search_bar.dart';
import 'package:flutter/material.dart' hide SearchBar;
import '../locale/k.dart';
import 'package:contacts/src/model/add_friend_repository.dart';
import 'package:contacts/src/contacts_api.dart';

class UserListPage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const UserListPage._(),
        settings: const RouteSettings(name: '/UserListPage'),
      ),
    );
  }

  const UserListPage._({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<UserListPage> with SingleTickerProviderStateMixin {
  final AddFriendRepository _repository = AddFriendRepository();
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(K.getTranslation('add_contacts')),
      ),
      body: _buildUserListView(),
    );
  }

  Widget _buildUserListView() {
    return Column(
      children: [
        SearchBar(
          onSearch: (String value) async {
            _repository.keyWord = value;
            _repository.refresh();
          },
          onCancel: (){
            _repository.keyWord = null;
            _repository.refresh();
          },
          hintText: K.getTranslation('enter_nick_name_hint'),
        ),
        Expanded(
          child: RefreshIndicator(
            key: refreshKey,
            onRefresh: () async {
              await _repository.refresh();
            },
            child: LoadingMoreList<User>(
              ListConfig<User>(
                itemBuilder: (context, item, index) =>
                    _buildRow(context, index, item),
                sourceList: _repository,
                indicatorBuilder: _indicatorBuilder,
                padding: const EdgeInsetsDirectional.all(0),
                //isLastOne: false
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, int index, User item) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (index > 0)
            const Divider(
              height: 5,
            ),
          if (index == 0) const SizedBox(height: 5),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              UserHeadWidget(
                  imageUrl: Util.getHeadIconUrl(item.id.toInt()),
                  uid: item.id.toInt(),
                  size: 50),
              const SizedBox(
                width: 5,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
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
              const Spacer(),
              _buildAddFriendButton(item),
              const SizedBox(
                width: 12,
              ),
              _buildAddFocusButton(item),
              const SizedBox(
                width: 12,
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget _buildAddFriendButton(User item) {
    bool disabled = Session.friendList.contains(item.id.toInt());
    return InkWell(
      onTap: () async {
        if (disabled) return;
        Resp resp = await ContactsAPI.addFriend(item.id.toInt());
        if (resp.code == 1) {
          Session.addFriend(item.id.toInt());
          _repository.setState();
          ToastUtil.showCenter(msg: resp.message);
        }
      },
      child: Button(
        title: K.getTranslation('add_friend'),
        disabled: disabled,
        buttonSize: ButtonSize.Small,
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
    );
  }

  Widget _buildAddFocusButton(User item) {
    bool disabled = Session.focusList.contains(item.id.toInt());
    return InkWell(
      onTap: () async {
        if (disabled) return;
        Resp resp = await ContactsAPI.addFocus(item.id.toInt());
        if (resp.code == 1) {
          Session.addFocus(item.id.toInt());
          _repository.setState();
          ToastUtil.showCenter(msg: resp.message);
        }
      },
      child: Button(
        title: K.getTranslation('add_focus'),
        disabled: disabled,
        buttonSize: ButtonSize.Small,
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        error: BaseK.K.getTranslation('no_data'),
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
        error: BaseK.K.getTranslation('data_error'),
        onTap: () {
          refreshKey.currentState?.show();
        },
      );
    }
    return const LoadingFooter(hasMore: true);
  }
}
