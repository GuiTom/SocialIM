import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:base/base.dart';
import 'package:flutter/material.dart';

import '../room_api.dart';
import '../locale/k.dart';
class CreateLiveRoomButtonSheet extends StatefulWidget {
  const CreateLiveRoomButtonSheet({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CreateLiveRoomButtonSheet> {
  late String _roomName;

  @override
  void initState() {
    super.initState();
    _roomName = K.getTranslation('the_room_of',args:[Session.userInfo.name]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 12,
        right: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          ThrottleInkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.close,
                size: 24,
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
              _roomName,
            style: const TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          Text(
            K.getTranslation('invite_someone_to'),
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            K.getTranslation('room_name'),
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0x1F111111),
            ),
            child: TextField(
              controller: TextEditingController(text: _roomName),
              maxLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                hintText: K.getTranslation('input_room_name'),
              ),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              onSubmitted: (String value) {
                _roomName = value;
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ThrottleInkWell(
            onTap: () async {
              String channleId = ''.generateRandomString(5);
              RtcTokenResp? resp = await RoomApi.getRoomToken(
                  channleId, Session.uid, ClientRoleType.clientRoleBroadcaster);
              if (resp?.code == 1) {
                if (!mounted) return;
                Navigator.pop(context);
                ILiveRoomRouter? liveRoomRouter = (RouterManager.instance
                    .getModuleRouter(ModuleType.LiveRoom) as ILiveRoomRouter)!;
                liveRoomRouter?.toLiveRoomPage(
                    roomId: 0,
                    channelId: channleId,
                    uid: Session.uid,
                    roomName: _roomName!,
                    token: resp!.token);
              }
            },
            child: Button(title: K.getTranslation('create'), buttonSize: ButtonSize.Big),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
