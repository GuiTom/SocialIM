// import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../base.dart';

class LocalIconLabel extends StatelessWidget {
  final String assetName;
  final double? width;
  final double? height;
  final Color? color;
  final bool? matchTextDirection;

  const LocalIconLabel(
    this.assetName, {
    Key? key,
    double? size,
    double? width,
    double? height,
    this.color,
    this.matchTextDirection,
  })  : width = width ?? size,
        height = height ?? size,
        super(key: key);

  @override
  Widget build(BuildContext context) {

    if (assetName.endsWith('svg')) {
      return SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        color: color,
        matchTextDirection: matchTextDirection ?? false,
      );
    } else {
      return Image.asset(
        assetName,
        width: width,
        height: height,
        color: color,
        matchTextDirection: matchTextDirection ?? false,
      );
    }
  }
}

/// 向右的箭头
class GoNextIcon extends LocalIconLabel {
  const GoNextIcon({
    Key? key,
    double size = 24,
    Color? color,
  }) : super(
          'packages/base/assets/ic_go_next.svg',
          key: key,
          size: size,
          color: color,
          matchTextDirection: true,
        );
}

/// 向右的箭头，比较粗的, 见家族任务列表
class GoNextBoldIcon extends LocalIconLabel {
  const GoNextBoldIcon({
    Key? key,
    double size = 16,
    Color? color,
  }) : super(
          'assets/images/ic_go_next_bold.svg',
          key: key,
          size: size,
          color: color,
          matchTextDirection: true,
        );
}

/// 向右的箭头，比较粗的, 并且在中间
class GoNexNormalIcon extends LocalIconLabel {
  const GoNexNormalIcon({
    Key? key,
    double size = 12,
    Color? color,
  }) : super(
    'assets/images/ic_go_next_nomal.svg',
    key: key,
    size: size,
    color: color,
    matchTextDirection: true,
  );
}

/// 帮助/问号按钮
class HelpIconButton extends StatelessWidget {
  const HelpIconButton({
    Key? key,
    this.onTap,
    this.size = 20,
    this.color,
  }) : super(key: key);

  final OnTapThrottle? onTap;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ThrottleInkWell(
      onTap: onTap,
      shape: const CircleBorder(),
      child: LocalIconLabel(
        'assets/images/ic_help_icon.svg',
        size: size,
        color: color,
      ),
    );
  }
}

/// 加号
class LocalAddIcon extends LocalIconLabel {
  const LocalAddIcon({
    Key? key,
    double size = 20,
    Color? color,
  }) : super(
          'assets/images/ic_add.svg',
          key: key,
          size: size,
          color: color,
        );
}

/// 锁的Icon，默认白色
class LocalLockIcon extends LocalIconLabel {
  const LocalLockIcon({
    Key? key,
    double size = 20,
    Color? color,
  }) : super(
          'assets/images/ic_lock.svg',
          key: key,
          size: size,
          color: color,
        );
}