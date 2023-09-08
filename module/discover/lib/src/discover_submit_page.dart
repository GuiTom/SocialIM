import 'dart:io';

import 'package:base/base.dart';
import 'package:discover/src/discover_api.dart';
import 'package:flutter/material.dart';
import 'package:base/src/locale/k.dart' as BaseK;
import 'package:flutter/services.dart';

import 'locale/k.dart';

class DiscoverSubmitPage extends StatefulWidget {
  const DiscoverSubmitPage({super.key});

  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const DiscoverSubmitPage(),
        settings: const RouteSettings(name: '/DiscoverPage'),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DiscoverSubmitPage> {
  final TextEditingController _controller = TextEditingController(text: '');
  final List<String> _mediaFilePaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: Column(
            children: [
              const SizedBox(height:8),
              _buildButtonRow(),
              _buildTextEditorWidget(),
              if (_mediaFilePaths.isNotEmpty)
                Padding(
                    padding:
                        const EdgeInsetsDirectional.symmetric(horizontal: 20),
                    child: _buildMediaFileRow(_mediaFilePaths)),
              Padding(
                  padding:
                      const EdgeInsetsDirectional.symmetric(horizontal: 20),
                  child: _buildBottomRow()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(BaseK.K.getTranslation('cancel'))),
        const Spacer(),
        InkWell(
          onTap: () async {
            if(_controller.text.isEmpty&&_mediaFilePaths.isEmpty) return;
            Resp resp =
                await DiscoverAPI.submitDynamic(_controller.text, _mediaFilePaths);
            if (resp.code == 1) {
              ToastUtil.showCenter(msg: resp.message);
              if(!mounted) return;
              Navigator.pop(context);
            }
          },
          child: Button(
            padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 12, vertical: 5),
            title: K.getTranslation('submit'),
            buttonSize: ButtonSize.Small,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }

  Widget _buildTextEditorWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: K.getTranslation('dynamic_input_hint'),
        ),
      ),
    );
  }

  Widget _buildMediaFileRow(List<String> paths) {
    return Row(
      children: [
        GestureDetector(
          onTap: () async {
            final imagePicker = ImagePicker();
            XFile? pickedFile = await imagePicker.pickImage(
              imageQuality: 50,
              source: ImageSource.gallery,
            );
            if (pickedFile == null) return;
            _mediaFilePaths.add(pickedFile!.path);
            setState(() {});
          },
          child: Container(
            alignment: AlignmentDirectional.center,
            width: 80,
            height: 80,
            child: const Icon(Icons.add),
          ),
        ),
        ...paths
            .map((e) => Image.file(
                  File(e),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ))
            .toList(),
      ],
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        InkWell(
            onTap: () async {
              final imagePicker = ImagePicker();
              XFile? pickedFile = await imagePicker.pickImage(
                imageQuality: 50,
                source: ImageSource.gallery,
              );
              if (pickedFile == null) return;
              _mediaFilePaths.add(pickedFile!.path);
              setState(() {});
            },
            child: const Icon(Icons.image)),
      ],
    );
  }
}
