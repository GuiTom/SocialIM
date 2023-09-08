import 'dart:io';

import 'package:base/base.dart';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewer extends StatelessWidget {
  ImageViewer({
    required this.imageUrls,
    required this.initIndex,
  });

  final List<String> imageUrls;
  @override
  final int initIndex;


  static Future show(BuildContext context,
      {required List<String> imageUrls, required initIndex}) {
    return Navigator.of(context).push(MaterialPageRoute<bool>(
      builder: (context) => ImageViewer(
        imageUrls: imageUrls,
        initIndex: initIndex,
      ),
      settings: const RouteSettings(name: '/ImageViewer'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Navigator.pop(context);
      },
      onLongPressStart: (LongPressStartDetails details){
        print(details);
      },
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(imageUrls[initIndex]),
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[initIndex]),
          );
        },
        itemCount: imageUrls.length,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 40.0,
            height: 40.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
        // backgroundDecoration: widget.backgroundDecoration,
        pageController: PageController(),
        onPageChanged: (int index){

        },
      ),
    );
  }
}
