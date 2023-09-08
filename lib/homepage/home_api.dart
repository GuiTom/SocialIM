import 'package:base/base.dart';

import 'protobuf/generated/room.pb.dart';

class HomeApi {
  static Future<LiveRoomListResp> getliveList(
      {required int page, int size = 50}) async {
    return Net.post(url: System.api('/api/room/livelist'),
        pb: true,
        params: {},
        pbMsg: LiveRoomListResp.create());
  }
}