// @dart=2.12
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({
    Key? key,
    this.label = 'Loading...',
    this.progress,
    this.color,
    this.strokeWidth = 3.0,
  }) : super(key: key);

  final String label;
  final double? progress;
  final Color? color;
  final double strokeWidth;

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          value: widget.progress,
          strokeWidth: widget.strokeWidth,
          valueColor: AlwaysStoppedAnimation(
              widget.color ?? Theme.of(context).primaryColor)),
    );
  }
}
