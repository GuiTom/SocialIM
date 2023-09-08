//@dart=2.12

import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../protobuf/generated/room.pb.dart';
import '../../locale/k.dart';
class HomeLiveRoomItem extends StatefulWidget {
  const HomeLiveRoomItem(
      {Key? key,
      required this.roomInfo,
      required this.index,
      required this.isResume})
      : super(key: key);
  final RoomInfo? roomInfo;
  final int index;
  final bool isResume;

  @override
  State<StatefulWidget> createState() => HomePartyState();
}

class HomePartyState extends State<HomeLiveRoomItem> {
  late int index;
  late bool isResume;

  @override
  void initState() {
    super.initState();
    index = widget.index;
    isResume = widget.isResume;
  }

  @override
  Widget build(BuildContext context) {
    return ThrottleInkWell(
      onTap: () async {
        if (widget.roomInfo == null) {
          ILiveRoomRouter liveRoomRouter = (RouterManager.instance
              .getModuleRouter(ModuleType.LiveRoom) as ILiveRoomRouter);
          liveRoomRouter.showCreateRoomModalPanel();
        } else {
          RtcTokenResp resp = await Net.post(
              url: System.api('/api/room/token'),
              pb: true,
              params: {
                "uid": Session.uid,
                "channelId": widget.roomInfo!.channelId,
                "role": 1
              },
              pbMsg: RtcTokenResp.create());
          if (resp.code == 1) {
            //跳转live页面
            ILiveRoomRouter liveRoomRouter = (RouterManager.instance
                .getModuleRouter(ModuleType.LiveRoom) as ILiveRoomRouter);
            liveRoomRouter.toLiveRoomPage(
                roomId: widget.roomInfo!.roomId,
                channelId: widget.roomInfo!.channelId,
                uid: Session.uid,
                roomName: widget.roomInfo!.name,
                token: resp.token);
          } else {
            ToastUtil.showCenter(msg: resp.message);
          }
        }
      },
      child: AbsorbPointer(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 94,
              height: 116,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFFFFFF), width: 1),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    blurRadius: 8.0,
                    spreadRadius: 0.0,
                    offset: Offset(0.0, 1.0),
                    color: Color(0x0d000000),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(1, 1, 1, 0),
              child: Container(
                  width: 92,
                  height: 57,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                    gradient: LinearGradient(
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.center,
                        colors: _getGradientColors(index % 5)),
                  )),
            ),
            if (widget.roomInfo == null) _buildCreateButton(),
            if (widget.roomInfo != null) _buildLiveRoomItem(widget.roomInfo!),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: 94,
      height: 116,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(14, 14, 14, 7),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
                    gradient: LinearGradient(
                        begin: AlignmentDirectional.topStart,
                        end: AlignmentDirectional.bottomEnd,
                        colors: [
                          const Color(0xFFF4CBFF).withOpacity(0.28),
                          const Color(0xFF9C8DFF).withOpacity(0.69)
                        ])),
                child: Image.asset('assets/home/ic_create_room.webp'),
              )),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
            child: Text(
             K.getTranslation('create_room'),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF313131), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveRoomItem(RoomInfo roomData) {
    return SizedBox(
      width: 94,
      height: 116,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 3),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 74,
                  height: 74,
                  padding: const EdgeInsetsDirectional.all(1.6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(37),
                    gradient: const LinearGradient(
                      begin: AlignmentDirectional.topStart,
                      end: AlignmentDirectional.bottomEnd,
                      colors: [Color(0xFFD577FF), Color(0xFFAB42FF)],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36.2),
                    ),
                  ),
                ),
                _buildUserAvatar(roomData),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
            child: Text(
              roomData.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF313131), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(RoomInfo roomData) {
    return UserHeadWidget(
        imageUrl: Util.getHeadIconUrl(roomData.creatorUid.toInt()),
        size: 74,
        onLineWidget: _buildOnlineIcon(),
        isMale: Session.userInfo.sex == 1);
  }

  Widget _buildOnlineIcon() {
    return PositionedDirectional(
      end: 0,
      bottom: 0,
      child: Stack(alignment: Alignment.center, children: [
        Container(
          width: 20.8,
          height: 20.8,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
                colors: [Color(0xFFB77DFF), Color(0xFF7658FF)],
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd),
            border: Border.all(
              color: const Color(0xFFFFFFFF),
              width: 1.6,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
        ),
        Lottie.asset('home/animation_live.json',
            width: 22,
            height: 22,
            repeat: true,
            animate: isResume,
            package: ''),
      ]),
    );
  }

  List<Color> _getGradientColors(int index) {
    return const [
      [Color(0x1AFFD60A), Color(0x00ffffff)],
      [Color(0x1AFF0A3D), Color(0x00ffffff)],
      [Color(0x1ACB0AFF), Color(0x00ffffff)],
      [Color(0x1A0A8AFF), Color(0x00ffffff)],
      [Color(0x1A2FFF0A), Color(0x00ffffff)]
    ][index];
  }
}
