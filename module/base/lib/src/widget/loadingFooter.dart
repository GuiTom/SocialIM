import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../base.dart';
import '../locale/k.dart';

class LoadingFooter extends StatefulWidget {
  final bool hasMore;
  final String? errorMessage;
  final String? noMoreMsg;
  final VoidCallback? loadMore;
  final Color? activityIndicatorColor;
  const LoadingFooter(
      {super.key,
      this.hasMore = true,
      this.errorMessage,
      this.loadMore,
      this.noMoreMsg,
      this.activityIndicatorColor});

  @override
  State createState() => _LoadingFooterState();
}

class _LoadingFooterState extends State<LoadingFooter> {
  Color? textColor;

  @override
  void initState() {
    super.initState();
    textColor = const Color(0xFF919191);
  }

  @override
  Widget build(BuildContext context) {
    Widget more;

    if (widget.errorMessage != null) {
      String error = widget.errorMessage ?? '';
      if (widget.errorMessage!.isNotEmpty) {
        error += '，';
      }
      error += K.getTranslation('click_to_retry');
      more = InkWell(
          onTap: () {
            if (widget.loadMore != null) {
              widget.loadMore!();
            }
          },
          child: SizedBox(
            height: 50,
            child: Center(
              child: Text(
                error,
                style: TextStyle(color: textColor),
              ),
            ),
          ));
      return more;
    }

    if (widget.hasMore) {
      more = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildActivityIndicator(),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 6.0),
            child: Text(
              K.getTranslation('waitting_load'),
              style: TextStyle(color: textColor),
            ),
          )
        ],
      );
    } else {
      more = Text(
        widget.noMoreMsg ?? K.getTranslation('not_any_more'),
        style: TextStyle(color: textColor),
      );
    }

    return Container(
      height: 50.0,
      width: Util.width,
      alignment: Alignment.center,
      child: more,
    );
  }

  Widget _buildActivityIndicator() {
    if (widget.activityIndicatorColor != null) {
      return CupertinoActivityIndicator(
           color: widget.activityIndicatorColor);
    }
    return const CupertinoActivityIndicator();
  }
}
