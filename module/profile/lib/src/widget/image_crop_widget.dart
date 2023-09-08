import 'dart:typed_data';

import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageCropWidget extends StatefulWidget {
  static Future<Uint8List?> show(BuildContext context, Uint8List bytes) {
    return Navigator.of(context).push(
      MaterialPageRoute<Uint8List>(
        builder: (context) => ImageCropWidget(
          bytes: bytes,
        ),
        settings: const RouteSettings(name: '/ImageCropWidget'),
      ),
    );
  }

  final Uint8List bytes;

  const ImageCropWidget({super.key, required this.bytes});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ImageCropWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('裁剪照片'),
        actions: [
          Container(
            alignment: Alignment.center,
            width: 50,
            height: 20,
            child: InkWell(onTap: () {}, child: const Text('确定')),
          ),
        ],
      ),
      body: Container(),
    );
  }

}
