import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:live_room/src/live_room_page.dart';
import 'package:live_room/src/widget/create_live_room_bottom_sheet.dart';

import '../game_page.dart';

class LiveRoomRouter implements ILiveRoomRouter {
  @override
  Future toLiveRoomPage(
      {required int roomId,
      required String channelId,
      required int uid,
      required String roomName,
      required String token}) {
    return LiveRoomPage.show(Constant.context,
        roomId: roomId,
        roomName: roomName,
        channelId: channelId,
        token: token,
        uid: uid);
  }
  Future toGamePage(
      {required int gameId,
        required String gameName,
        required String gameUrl}) {
    return GamePage.show(Constant.context,gameId: gameId,gameName:gameName,gameUrl:gameUrl);
  }
  @override
  Future showCreateRoomModalPanel() {
    // return _showBottomSheet(Constant.context);
    return showModalBottomSheet(
        context: Constant.context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(12), right: Radius.circular(12)),
        ),
        builder: (BuildContext context) {
          return const CreateLiveRoomButtonSheet();
        });
  }
  Future _showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 使用isScrollControlled属性
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            // padding: EdgeInsets.only(
            //   bottom: MediaQuery.of(context).viewInsets.bottom,
            // ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text('Bottom Sheet Content'),
                  // SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter text',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
