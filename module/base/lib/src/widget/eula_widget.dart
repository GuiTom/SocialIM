import 'package:base/src/widget/web_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../locale/k.dart';

class EulaWidget extends StatefulWidget {
  final ValueChanged<bool> onValueChanged;

  const EulaWidget({super.key, required this.onValueChanged});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EulaWidget> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 12,
        ),
        GestureDetector(
          onTap: () {
            _agreed = !_agreed;
            setState(() {});
            widget.onValueChanged(_agreed);
          },
          child: _agreed
              ? const Icon(Icons.check_box)
              : const Icon(Icons.check_box_outline_blank),
        ),
        const SizedBox(
          width: 12,
        ),
        GestureDetector(
          onTap: () {
            WebPage.show(
              context,
              title: K.getTranslation('eula'),
              webUrl: ui.window.locale.languageCode == 'zh'
                  ? 'https://docs.qq.com/doc/DRUhXSVN4dGJUYkVr'
                  : 'https://docs.google.com/document/d/1kHykh-T6b_p2kS1SSLf21OqXmZHwjS_tV4z7vQkKVJc/edit?usp=sharing',
            );
          },
          child: Text.rich(
            TextSpan(
              text: K.getTranslation('agree'),
              style: const TextStyle(
                color: Color(0xFF616161),
              ),
              children: [
                TextSpan(
                  text: ' 《${K.getTranslation('eula')}》',
                  style: TextStyle(
                    color: Color(0xFF5151FF),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
