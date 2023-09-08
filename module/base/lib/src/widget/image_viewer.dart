import 'dart:io';

import 'package:base/base.dart';

import 'package:flutter/material.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';

class ImageViewer {
  ImageViewer({
    required this.imageUrls,
    required this.initIndex,
  });

  final List<String> imageUrls;
  @override
  final int initIndex;

  static Future show(BuildContext context,
      {required List<String> imageUrls, required initIndex}) {
    return     Navigator.of(context).push(
      HeroDialogRoute<void>(
        // DisplayGesture is just debug, please remove it when use
        builder: (BuildContext context) => InteractiveviewerGallery<String>(
          sources: imageUrls,
          initIndex: initIndex,
          itemBuilder: (BuildContext context, int index, bool isFocus){
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Center(
                child: Hero(
                  tag: imageUrls[index],
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    width: Util.width,
                    memCacheWidth: Util.width.toInt(),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            );
          },
          onPageChanged: (int pageIndex) {
            print("nell-pageIndex:$pageIndex");
          },
        ),
      ),
    );
  }
}


