import 'package:base/base.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:base/src/locale/k.dart' as BaseK;
import 'package:profile/src/model/user_blacklist_repository.dart';
import 'package:profile/src/profile_api.dart';

import '../locale/k.dart';

class UserBlackListPage extends StatefulWidget with ReloadController {
  @override
  Future<bool> reload() {
    (key as GlobalKey<UserBlackListPageState>)
        .currentState
        ?.refreshKey
        .currentState
        ?.show();

    return Future.value(true);
  }

  const UserBlackListPage({super.key});

  @override
  State<StatefulWidget> createState() => UserBlackListPageState();
}

class UserBlackListPageState extends State<UserBlackListPage> {
  @override
  Future<bool> reload() {
    return Future(() => true);
  }

  final UserBlackListRepository _repository = UserBlackListRepository();
  final GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
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
    );
  }

  Widget _buildRow(BuildContext context, int index, User item) {
    return GestureDetector(
      onTap: () {
        IMessageRouter messageRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.Message) as IMessageRouter)!;
        messageRouter.toChatPage(item.id.toInt(), item.name);
      },
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        child: Row(
          children: [
            UserHeadWidget(
                imageUrl: Util.getHeadIconUrl(item.id.toInt()), size: 50),
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
              ],
            ),
            const Spacer(),
            GestureDetector(
                onTap: () async {
                  Resp resp = await ProfileApi.removeUserFromBlackList(item.id.toInt());
                  if (resp.code == 1) {
                    ToastUtil.showCenter(msg: resp.message);
                    _repository.remove(item);
                    Session.removeUserBlackList(item.id.toInt());
                    _repository.setState();
                  }
                },
                child: Button(
                  title: K.getTranslation('move_out'),
                  buttonSize: ButtonSize.Small,
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 15, vertical: 5),
                ),),
            const SizedBox(width:5),
          ],
        ),
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
