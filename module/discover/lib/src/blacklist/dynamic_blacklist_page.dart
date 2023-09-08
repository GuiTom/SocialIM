import 'package:base/base.dart';
import 'package:discover/src/discover_api.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:base/src/locale/k.dart' as BaseK;

import '../dynamic_detail_page.dart';
import '../locale/k.dart';
import '../model/dynamic_blacklist_repository.dart';

class DynamicBlackListPage extends StatefulWidget with ReloadController {
  @override
  Future<bool> reload() {
    (key as GlobalKey<DynamicBlackListPageState>)
        .currentState
        ?.refreshKey
        .currentState
        ?.show();

    return Future.value(true);
  }

  const DynamicBlackListPage({super.key});


  @override
  State<StatefulWidget> createState() => DynamicBlackListPageState();
}

class DynamicBlackListPageState extends State<DynamicBlackListPage> {
  @override
  Future<bool> reload() {
    return Future(() => true);
  }

  final DynamicBlackListRepository _repository = DynamicBlackListRepository();
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


  Widget _buildRow(BuildContext context, int index,Dynamic item) {
    return GestureDetector(
      onTap: (){
         DynamicDetailPage.show(Constant.context, item);
      },
      child: Container(
        padding: const EdgeInsetsDirectional.all(12),
        child: Row(
          children: [
            UserHeadWidget(
                imageUrl: Util.getHeadIconUrl(item.id.toInt()), size: 50),
            const SizedBox(width: 5,),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.content),
                const SizedBox(height: 5,),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                Resp resp = await DiscoverAPI.removeUserFromBlackList(item.id.toInt());
                if (resp.code == 1) {
                  ToastUtil.showCenter(msg: resp.message);
                  _repository.remove(item);
                  Session.removeDynBlackList(item.id.toInt());
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
