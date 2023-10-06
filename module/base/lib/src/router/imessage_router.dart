import 'package:base/base.dart';
import 'package:flutter/material.dart';

abstract class IMessageRouter extends IModuleRouter {
  Widget getSessionListPage(int pageIndex);

  void listenMessage();

  void showRTCCall(BuildContext context, bool isVideo, int targetUid,String senderName);

  void initSessions();

  Future toChatPage(int targetId, String targetName);
}
