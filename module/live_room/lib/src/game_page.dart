import 'dart:io';
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'locale/k.dart';
import 'package:dhttpd/dhttpd.dart';
class GamePage extends StatefulWidget {
  static Future show(
    BuildContext context, {
    required int gameId,
    required String gameName,
    required String gameUrl,
  }) {
    return Navigator.of(context).push(MaterialPageRoute<bool>(
      builder: (context) => GamePage(
        gameUrl: gameUrl,
        gameId: gameId,
        gameName: gameName,
      ),
      settings: const RouteSettings(name: '/GamePage'),
    ));
  }

  const GamePage(
      {super.key,
      required this.gameUrl,
      required this.gameId,
      required this.gameName});

  final String gameUrl;
  final int gameId;
  final String gameName;

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<GamePage> {
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
  Dhttpd? _server;

  @override
  void initState() {
    super.initState();
    _downloadZip(widget.gameUrl);
  }

  @override
  void dispose() {
    _server?.destroy();
    super.dispose();
  }

  Future _downloadZip(String url) async {
    String fileName = url.split('/').last;
    String fileNoExtName = fileName.split('.').first;
    String basePath =  Constant.documentsDirectory!.path;
    String savePath = '${Constant.documentsDirectory!.path}/$fileName';

    String indexPath = '$basePath/$fileNoExtName/index.html';
    if (File(indexPath).existsSync()) {
     _server = await Dhttpd.start(path:basePath,port:8080);
      _webUrl = '${_server!.urlBase}$fileNoExtName';
      _progress = 100;
      setState(() {});
      return;
    }
    bool? success = await Net.download(url, savePath, (count, total) {
      if (total > 0) {
        _progress = count * 90 ~/ total;
        // print('progress:$_progress');
        setState(() {});
      }
    });
    if (success == true) {
      final zipFile = File(savePath);
      String dstPath =
          Constant.documentsDirectory!.path;
      final destinationDir = Directory(dstPath);
      try {
        await ZipFile.extractToDirectory(
            zipFile: zipFile, destinationDir: destinationDir,onExtracting: (zipEntry, progress){
              if(zipEntry.name.contains('__MACOSX')){
                return ZipFileOperation.skipItem;
              }
          return ZipFileOperation.includeItem;
        });
        _server = await Dhttpd.start(path:basePath,port:8080);
        _webUrl = '${_server!.urlBase}$fileNoExtName';
        _progress = 100;
        zipFile.delete(recursive: true);
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Text(
              widget.gameName,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w900),
            ),
            Text(
              widget.gameName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        if (_progress >= 100)
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
              // _progress = progress;
              // dog.d('progress:$_progress');
              // setState(() {});
            },
            onUpdateVisitedHistory: (controller, url, androidIsReload) {},
            onConsoleMessage: (controller, consoleMessage) {},
          ),
        if (_progress < 100)
          Container(
            color: Colors.black,
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 20,
                  alignment: AlignmentDirectional.center,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1E1E1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: EdgeInsetsDirectional.only(
                    start: 2,
                    end: (Util.width - 44) * (100.0 - _progress) * 0.01 + 2,
                    top: 2,
                    bottom: 2,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  '${K.getTranslation('loading')}...${_progress}%',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
