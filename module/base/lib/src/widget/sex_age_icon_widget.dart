import 'package:flutter/material.dart';

import '../../base.dart';

class SexAgeLabelWidget extends StatelessWidget {
  const SexAgeLabelWidget({
    Key? key,
    required this.sex,
    required this.age,
  }) : super(key: key);

  final int sex;
  final int age;

  @override
  Widget build(BuildContext context) {
    final isMale = sex == 1;
    final colors = isMale
        ? const [Color(0xFF798AFF), Color(0xFF79C6FF)]
        : const [Color(0xFFFFA3A8), Color(0xFFFF89D9)];
    final sexIcon = isMale
        ? 'packages/base/assets/ic_sex_male.svg'
        : 'packages/base/assets/ic_sex_female.svg';
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: AlignmentDirectional.centerStart,
          end: AlignmentDirectional.centerEnd,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          LocalIconLabel(sexIcon, size: 11),
          Text(
            '$age',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
