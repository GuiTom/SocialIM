import 'dart:io';
import 'package:base/base.dart';
import 'package:flutter/material.dart';

import '../locale/k.dart';

class WebPage extends StatefulWidget {
  static Future show(
    BuildContext context, {
    required String title,
    required String webUrl,
  }) {
    return Navigator.of(context).push(MaterialPageRoute<bool>(
      builder: (context) => WebPage(
        webUrl: webUrl,
        title: title,
      ),
      settings: const RouteSettings(name: '/WebPage'),
    ));
  }

  const WebPage({
    super.key,
    required this.webUrl,
    required this.title,
  });

  final String webUrl;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<WebPage> {
  final GlobalKey webViewKey = GlobalKey();
  String? _webUrl;
  int _progress = 0;
  InAppWebViewController? _webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          allowFileAccessFromFileURLs: true,
          allowUniversalAccessFromFileURLs: true,
          mediaPlaybackRequiresUserGesture: false),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void initState() {
    super.initState();
    _webUrl = widget.webUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: Colors.black,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(child: _buildBody(),),
    );
  }

  Widget _buildBody() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        InAppWebView(
          key: webViewKey,
          // contextMenu: contextMenu,
          initialUrlRequest: URLRequest(url: Uri.parse(_webUrl!)),
          // initialFile: "assets/index.html",
          initialUserScripts: UnmodifiableListView<UserScript>([]),
          initialOptions: options,
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
          onLoadStart: (controller, url) {},
          androidOnPermissionRequest: (controller, origin, resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {},
          onLoadError: (controller, url, code, message) {
            dog.d('errorMes:$message');
          },
          onProgressChanged: (controller, progress) {
            _progress = progress;
            // dog.d('progress:$_progress');
            setState(() {});
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) {},
          onConsoleMessage: (controller, consoleMessage) {},
        ),
        if (_progress < 100)
          PositionedDirectional(
            start: 0,
            end: 0,
            child: LinearProgressIndicator(
                value: _progress * 0.01,
                backgroundColor: Colors.blue,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple)),
          ),
      ],
    );
  }
}
