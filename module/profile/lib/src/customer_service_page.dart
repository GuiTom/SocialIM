import 'package:base/base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'locale/k.dart';

class CustomerServicePage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const CustomerServicePage(),
        settings: const RouteSettings(name: '/CustomerServicePage'),
      ),
    );
  }

  const CustomerServicePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<CustomerServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          K.getTranslation('customer_service_and_Help'),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
          top: 50,
        ),
        child: Column(
          children: [
            if (Constant.customerServicePhone.isNotEmpty) _buildPhoneWidget(),
            const SizedBox(
              height: 30,
            ),
            if (Constant.customerServiceWechat.isNotEmpty) _buildWechatWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildWechatWidget() {
    return ThrottleInkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: Constant.customerServicePhone));
        ToastUtil.showTop(msg: K.getTranslation('wechat_number_copyed'));
      },
      child: Row(
        children: [
          Image.asset(
            'assets/icon_wechat.webp',
            package: 'profile',
            width: 30,
            height: 30,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            '${K.getTranslation('wechat_number')}: ${Constant.customerServiceWechat}',
            style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal),
          ),
          const SizedBox(
            width: 5,
          ),
          SvgPicture.asset(
            'assets/icon_copy.svg',
            package: 'profile',
            width: 18,
            height: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneWidget() {
    return GestureDetector(
      onTap: () {
        _launchPhone(Constant.customerServicePhone);
      },
      child: Row(
        children: [
          Image.asset(
            'assets/icon_phone.webp',
            package: 'profile',
            width: 24,
            height: 24,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            Constant.customerServicePhone,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw K.getTranslation('can_not_call');
    }
  }
}
