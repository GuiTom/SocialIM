import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../model/session.dart';
import  'util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageCacheUtil{
  static Future removeKey(BuildContext context, String imageUrl,List<double> sizes) async{

    //1.移除磁盘缓存
   await DefaultCacheManager()
        .removeFile(imageUrl);
   //2.移除内存缓存(到Framework源码里面去看的)
      CachedNetworkImageProvider provider = CachedNetworkImageProvider(imageUrl);
      // ResizeImageKey
      for (var s in sizes) {
        Size size = Size.square(s);
        final configuration =   ImageConfiguration(
          bundle: DefaultAssetBundle.of(context),
          devicePixelRatio: MediaQuery.maybeOf(context)?.devicePixelRatio ?? 1.0,
          locale: Localizations.maybeLocaleOf(context),
          textDirection: Directionality.maybeOf(context),
          size: size,
          platform: defaultTargetPlatform,
        );
        final key = await ResizeImage.resizeIfNeeded(size.width.toInt(), size.height.toInt(), provider).obtainKey(configuration);
        PaintingBinding.instance.imageCache.evict(key,includeLive: true);
      }
  }


}