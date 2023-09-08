import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

/// 登录背景轮播图组件
class PreloginBackgroundSlide extends StatefulWidget {
  final ILoginBackgroundProvider provider;

  const PreloginBackgroundSlide({Key? key, required this.provider})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PreloginBackgroundSlideState();
}

class _PreloginBackgroundSlideState extends State<PreloginBackgroundSlide>
    with TickerProviderStateMixin, LifecycleAware, LifecycleMixin {
  List<CardItemInfo> _displayInfo = [];
  late ScrollController _usersController;
  static const _animationStartDelayInSeconds = 0; // 0s
  static const _slideOnePageDurationInSeconds = 22; // 22s
  double _currentAnimationDistance = 0.0;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _displayInfo = widget.provider.provideSlideCardInfoList();
    _usersController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: _animationStartDelayInSeconds),
          () {
        if (!_usersController.hasClients || !mounted) {
          dog.d(
              'LoginBackgroundSlide usersController has no clients! is mounted: $mounted');
          return;
        }
        _startAutoScroll(false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollEndNotification && _isActive) {
              /// 解决onNotification中直接animateTo不生效的问题
              Future.delayed(Duration.zero, () {
                _startAutoScroll(false);
              });
            }
            return false;
          },
          child: MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            controller: _usersController,
            itemCount: 0x7FFFFFFF,
            itemBuilder: (context, index) => widget.provider
                .provideSlideCard(_displayInfo[index % _displayInfo.length]),
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            crossAxisCount: 2,
          ),
        ),
        Positioned.fill(
            child: ColoredBox(color: Colors.black.withOpacity(0.75))),
      ],
    );
  }

  @override
  void dispose() {
    _usersController.dispose();
    super.dispose();
  }

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    if (event == LifecycleEvent.active) {
      _isActive = true;
      _startAutoScroll(true);
    } else if (event == LifecycleEvent.invisible ||
        event == LifecycleEvent.inactive) {
      _isActive = false;
      if (_usersController.hasClients) {
        /// 使用jumpTo会有点卡
        _usersController.animateTo(0,
            duration: const Duration(milliseconds: 1), curve: Curves.linear);
      }
    }
  }

  void _startAutoScroll(bool reset) {
    if (_usersController.hasClients) {
      if (reset) {
        _currentAnimationDistance = 0.0;
      }
      _currentAnimationDistance += Util.height;
      _usersController.animateTo(_currentAnimationDistance,
          duration: const Duration(seconds: _slideOnePageDurationInSeconds),
          curve: Curves.linear);
    }
  }
}

abstract class ILoginBackgroundProvider {
  /// 提供登录背景轮播图卡片布局
  Widget provideSlideCard(CardItemInfo info);

  /// 提供登录背景
  List<CardItemInfo> provideSlideCardInfoList();
}

/// 登录背景轮播图的卡片信息
class CardItemInfo {
  final int age;
  final String src;

  /// 图片长宽比
  final double ratio;

  CardItemInfo(this.age, this.src, [this.ratio = 1.0]);
}

/// 目前只需要这一个实现类就够了，如果某个Locale的包的配置和这个不相同，可以实现ILoginBackgroundProvider
class LoginBackgroundProvider implements ILoginBackgroundProvider {
  static LoginBackgroundProvider? _i;
  final List<String> _images = [
    'male_01.webp',
    'female_01.webp',
    'female_02.webp',
    'male_02.webp',
    'female_03.webp',
    'female_04.webp',
    'female_05.webp',
    'female_06.webp',
    'female_07.webp',
    'male_03.webp',
    'female_08.webp',
    'female_09.webp',
    'female_10.webp',
    'female_11.webp',
    'female_12.webp',
    'female_13.webp',
    'male_04.webp',
    'female_14.webp',
    'female_15.webp',
    'female_16.webp',
    'female_17.webp',
    'male_05.webp',
    'female_18.webp',
  ];

  LoginBackgroundProvider._instance();

  factory LoginBackgroundProvider() =>
      _i ??= LoginBackgroundProvider._instance();

  @override
  Widget provideSlideCard(CardItemInfo info) {
    return AspectRatio(
      aspectRatio: info.ratio,
      child: Image.asset(info.src, fit: BoxFit.fill, package: 'login'),
    );
  }

  @override
  List<CardItemInfo> provideSlideCardInfoList() {
    return _images
        .map((e) => CardItemInfo(24, 'assets/user_covers/$e'))
        .toList();
  }
}
