import 'package:base/base.dart';
import 'package:flutter/material.dart';

abstract class ILiveRoomRouter extends IModuleRouter {
  Future toLiveRoomPage(
      {required int roomId,
        required String channelId,
        required int uid,
        required String roomName,
        required String token});
  Future toGamePage(
      {required int gameId,
        required String gameName,
        required String gameUrl});
  Future showCreateRoomModalPanel();
}
