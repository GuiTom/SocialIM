import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';

class UnReadDotContainer extends StatefulWidget {
  const UnReadDotContainer({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<UnReadDotContainer> {
  @override
  void initState() {
    super.initState();

    eventCenter.addListener('unReadCountChange', _onReadCountChange);
  }

  void _onReadCountChange(type, data) {
    setState(() {});
  }

  @override
  void dispose() {
    eventCenter.removeListener('unReadCountChange', _onReadCountChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Constant.totalUnReadMsgCount <= 0) return const SizedBox.shrink();
    return UnconstrainedBox(
      alignment: AlignmentDirectional.topEnd,
      child: UnReadDotWidget(count: Constant.totalUnReadMsgCount),
    );
  }
}
