import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnReadDotWidget extends StatelessWidget {
  final int count;

  const UnReadDotWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 16,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 5),
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.red,
      ),
      child: Text(
        count<100?'$count':'99+',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}
