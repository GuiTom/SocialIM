//@dart=2.12
import 'dart:convert';

import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../locale/k.dart';
import 'package:base/src/locale/k.dart' as BaseK;
/// 输入框
class CountEditWidget extends StatefulWidget {


  const CountEditWidget({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => CountEditState();

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      builder: (_) => const CountEditWidget(
      ),
    );
  }
}

class CountEditState extends State<CountEditWidget> {
  FocusNode? _focusNode;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
        text: '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottom),
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: 56.0,
        color: Colors.white,
        alignment: AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(

            keyboardAppearance: Brightness.light,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintStyle: const TextStyle(
                color: Color(0xFFBABABA),
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintText:
                  K.getTranslation('enter_what_you_want_say'),
              isDense: true,
              counterText: '',
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.start,
            maxLines: 1,
            minLines: 1,
            maxLength: 50,
            style: const TextStyle(
              fontSize: 14.0,
              color: Color(0xFF313131),
            ),
            focusNode: _focusNode,
            controller: _textController,
            autocorrect: true,
            autofocus: true,
            onSubmitted: (String content) {
              _onConfirm();
            },
          ),
        ),
        InkWell(
          onTap:(){
            _onConfirm();
          },
          child: Button(
            title:BaseK.K.getTranslation('confirm'),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 12,vertical: 4),
            buttonSize: ButtonSize.Small,
          ),
        ),
      ],
    );
  }

  void _onConfirm() {
    final String content = _textController.text;

    Navigator.pop(context, content);
  }
}


