import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:base/src/locale/k.dart' as BaseK;

class SelectGenderWidget extends StatefulWidget {
  final int? gender;
  final ValueChanged<int>? onGenderCallback;

  const SelectGenderWidget({Key? key, this.gender, this.onGenderCallback})
      : super(key: key);

  @override
  State createState() => _SelectGenderState();

  static Future<int?> show(BuildContext context,
      {int? gender, ValueChanged<int>? onGenderCallback}) {
    return showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectGenderWidget(
              gender: gender, onGenderCallback: onGenderCallback);
        });
  }
}

class _SelectGenderState extends State<SelectGenderWidget> {
  int? _gender = 0;

  @override
  void initState() {
    super.initState();
    _gender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(24), topEnd: Radius.circular(24)),
        ),
        padding: const EdgeInsetsDirectional.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('选择性别',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('选择性别后不能修改哟',
                style: TextStyle(color: Color(0xFF313131))),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildGenderItem(1),
                const SizedBox(
                  width: 20,
                ),
                _buildGenderItem(2),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            _buildConfirmButton(),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return InkWell(
      onTap: () async {
        Navigator.pop(context, _gender);
      },
      child: Button(
        title: BaseK.K.getTranslation('confirm'),
        buttonSize: ButtonSize.Big,
      ),
    );
  }

  Widget _buildGenderItem(int index) {
    String headResName =
        index == 1 ? 'default_head_male.webp' : 'default_head_female.webp';
    return InkWell(
      onTap: () {
        _gender = index;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsetsDirectional.all(20),
        decoration: BoxDecoration(
          color: _gender == index?const Color(0xFFF1F1F1):Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFA1A1A1),width: 3,),),
        child: Image.asset(
          'assets/$headResName',
          package: 'base',
          width: 80,
          height: 80,
        ),
      ),
    );
  }
}
