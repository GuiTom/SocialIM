
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../locale/k.dart';

class ErrorData extends StatelessWidget {
  final String? error;
  final VoidCallback? onTap;

  final Color? fontColor;
  final double top;
  final double bottom;
  final bool needExpand;
  final ScrollPhysics? physics;
  final double? iconSize;
  Widget? errImage;

  ErrorData(
      {Key? key,
      this.error,
      this.onTap,
      this.fontColor,
      this.errImage,
      this.top = 12,
      this.bottom = 120,
      this.needExpand = true,
      this.physics,
      this.iconSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        child: needExpand
            ? SingleChildScrollView(
                physics: physics,
                child: _buildContent(),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            child: (errImage ??
                Image.asset(
                  'assets/error_data.webp',
                  package: 'base',
                  width: iconSize ?? 196,
                  height: iconSize,
                  fit: BoxFit.contain,
                ))),
        Padding(
          padding: EdgeInsetsDirectional.only(
              top: top ,bottom:bottom, start: 16, end: 16),
          child: Text(error ?? K.getTranslation('server_return_error_retry'),
              textAlign: TextAlign.center,
              style: TextStyle(color: fontColor ?? const Color(0xFFE1E1E1))),
        ),
      ],
    );
  }
}
