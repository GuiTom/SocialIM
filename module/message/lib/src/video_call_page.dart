import 'package:base/base.dart';
import 'package:flutter/material.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key, required this.isVideo});

  final bool isVideo;

  @override
  State<StatefulWidget> createState() {
    return _State();
  }

  // static Future show(BuildContext context, bool isVideo) {
  //   return showMaterialModalBottomSheet(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return VideoCallPage(
  //           isVideo: isVideo,
  //         );
  //       });
  // }
}

class _State extends State<VideoCallPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: Util.height,
    );
  }
}
