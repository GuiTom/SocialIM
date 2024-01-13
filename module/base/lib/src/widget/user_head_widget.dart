import 'package:base/base.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class UserHeadWidget extends StatelessWidget {
  final Widget? onLineWidget;
  final String imageUrl;
  final double size;
  final bool? isMale;
  final int? uid;


  const UserHeadWidget(
      {super.key,
      required this.imageUrl,
      required this.size,
      this.onLineWidget,
      this.isMale,
      this.uid});

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(size / 2)),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        cacheKey: imageUrl,
        memCacheHeight: size.toInt(),
        memCacheWidth: size.toInt(),
        placeholder: (context, url) => const CupertinoActivityIndicator(),
        errorWidget: (context, url, error) => _buildEorrorWidget(),
      ),
    );
    if (uid != null) {
      child = InkWell(
        onTap: () {
          IProfileRouter profileRouter = RouterManager.instance.getModuleRouter(ModuleType.Profile) as IProfileRouter;
          profileRouter.toOtherProfilePage(uid:uid!,isSelf:Session.uid == uid);
        },
        child: child,
      );
    }
    return child;
  }

  Widget _buildEorrorWidget() {
    late String iconFile;
    if (isMale == null) iconFile = 'blank_user_head.webp';
    iconFile = (isMale == true)
        ? 'default_head_male.webp'
        : 'default_head_female.webp';
    return Image.asset('packages/base/assets/$iconFile');
  }
}
