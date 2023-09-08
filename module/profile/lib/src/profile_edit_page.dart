import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import 'locale/k.dart';
import 'package:base/base.dart';
import 'package:base/src/locale/k.dart' as BaseK;

import 'package:flutter/material.dart';
import 'package:profile/src/edit_page/nick_name_edit_page.dart';
import 'package:profile/src/edit_page/signature_edit_page.dart';
import 'package:profile/src/profile_api.dart';
import 'dart:ui' as ui;
import 'edit_page/area_setting_widget.dart';
import 'package:image/image.dart' as Img;

enum EditItemType {
  userHeader,
  nickName,
  userId,
  sex,
  birthDay,
  phoneNumber,
  emailAddress,
  level,
  wealth,
  area,
  signature,
}

class ProfileEditPage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const ProfileEditPage(),
        settings: const RouteSettings(name: '/ProfileEditPage'),
      ),
    );
  }

  const ProfileEditPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ProfileEditPage> {
  final List<Map<String, dynamic>> _datas = [
    {'name': K.getTranslation('user_head'), 'type': EditItemType.userHeader},
    {'name': K.getTranslation('nickname'), 'type': EditItemType.nickName},
    {'name': K.getTranslation('user_id'), 'type': EditItemType.userId},
    {'name': K.getTranslation('gender'), 'type': EditItemType.sex},
    {'name': K.getTranslation('birthday'), 'type': EditItemType.birthDay},
    if(Session.userInfo.phone.isNotEmpty)
    {
      'name': K.getTranslation('phone_number'),
      'type': EditItemType.phoneNumber
    },
    if(Session.userInfo.email.isNotEmpty)
    {
      'name': K.getTranslation('email_address'),
      'type': EditItemType.emailAddress
    },
    {'name': K.getTranslation('user_level'), 'type': EditItemType.level},
    {'name': K.getTranslation('user_wealth'), 'type': EditItemType.wealth},
    {'name': K.getTranslation('area'), 'type': EditItemType.area},
    {'name': K.getTranslation('signature'), 'type': EditItemType.signature},
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(K.getTranslation('profile_edit')),
          ),
          body: _buildBody(),
        ),
        onWillPop: () async {
          Navigator.pop(context);
          return false;
        });
  }

  Widget _buildBody() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(_datas[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 2,
        );
      },
      itemCount: _datas.length,
    );
  }

  Widget _buildItem(Map<String, dynamic> data) {
    late Widget child;
    if (data['type'] == EditItemType.userHeader) {
      child = _buildUserHeadItem();
    } else if (data['type'] == EditItemType.nickName) {
      child = _buildNickNameItem();
    } else if (data['type'] == EditItemType.userId) {
      child = _buildUserIdItem();
    } else if (data['type'] == EditItemType.sex) {
      child = _buildSexItem();
    } else if (data['type'] == EditItemType.phoneNumber) {
      child = _buildPhoneNumberItem();
    }else if (data['type'] == EditItemType.emailAddress) {
      child = _buildEmailAddressItem();
    } else if (data['type'] == EditItemType.birthDay) {
      child = _buildBirthDayItem();
    } else if (data['type'] == EditItemType.level) {
      child = _buildLevelItem();
    } else if (data['type'] == EditItemType.area) {
      child = _buildAreaItem();
    } else if (data['type'] == EditItemType.signature) {
      child = _buildSignatureItem();
    } else if (data['type'] == EditItemType.wealth) {
      child = _buildWealthItem();
    } else {
      child = const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12),
      height: 50,
      // color:Colors.red,
      child: child,
    );
  }

  Widget _buildUserHeadItem() {
    return ThrottleInkWell(
      onTap: () async {
        final imagePicker = ImagePicker();
        XFile? pickedFile = (await imagePicker.pickImage(
          imageQuality: 50,
          source: ImageSource.gallery,
        ));

        if (pickedFile == null) {
          return;
        }
        var pickedData = await pickedFile.readAsBytes();
        if (!mounted) return;
        Uint8List? croppedImage = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageCropper(
              image: pickedData,
            ),
          ),
        );
        if (croppedImage == null) return;
        // 解码图像
        // 缩放图像
        const needWidth = 200;
        final image = Img.decodeImage(croppedImage);
        if (image!.width > needWidth) {
          double ratio = image.width / needWidth;
          final scaledImage = Img.copyResize(image!,
              width: image.width ~/ ratio, height: image.height ~/ ratio);
          croppedImage = Uint8List.fromList(Img.encodeJpg(scaledImage));
        }
        UploadResp uploadResp = await Net.uploadFile(
            url: System.api('/api/upload/userHead'),
            bytes: croppedImage,
            fileName: '${Session.uid}.jpg',
            pb: true,
            params: {},
            pbMsg: UploadResp.create());
        if (uploadResp.code == 1) {
          if (!mounted) return;
          ToastUtil.showCenter(
              msg: K.getTranslation('user_head_upload_success'));
          String imageUrl = Util.getHeadIconUrl(Session.uid);
          await ImageCacheUtil.removeKey(
              context, imageUrl, [30, 40, 50, 60, 74]);
          if (!mounted) return;
          setState(() {});
        } else {
          ToastUtil.showCenter(msg: uploadResp.message);
        }
      },
      child: Row(
        children: [
          Text(K.getTranslation('user_head')),
          const Spacer(),
          UserHeadWidget(
              imageUrl: Util.getHeadIconUrl(Session.uid),
              size: 30,
              isMale: Session.userInfo.sex == 1),
          const GoNextIcon(
            size: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildNickNameItem() {
    return ThrottleInkWell(
      onTap: () async {
        await NickNameEditPage.show(Constant.context);
        setState(() {});
      },
      child: Row(
        children: [
          Text(K.getTranslation('nickname')),
          const Spacer(),
          Text(Session.userInfo.name),
          const GoNextIcon(
            size: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildUserIdItem() {
    return Row(
      children: [
        Text(K.getTranslation('user_id')),
        const Spacer(),
        Text(Session.uid.toString()),
      ],
    );
  }

  Widget _buildSexItem() {
    return ThrottleInkWell(
      onTap: () async {},
      child: Row(
        children: [
          Text(K.getTranslation('gender')),
          const Spacer(),
          Text(Session.userInfo?.sex == 1
              ? BaseK.K.getTranslation('male')
              : BaseK.K.getTranslation('female')),
        ],
      ),
    );
  }

  Widget _buildPhoneNumberItem() {
    return ThrottleInkWell(
      onTap: () async {
        ILoginRouter loginRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.Login) as ILoginRouter);
        String phone = Session.userInfo.phone.split('-').last;
        String areaCode = Session.userInfo.phone.split('-').first;
        await loginRouter.toSmsVerificationCodePage(
            VerficationType.changePhoneNumberOld,
            K.getTranslation('verification_for_change_phone'),
            phone,
            areaCode,
            Session.countryIsoCode);
        setState(() {});
      },
      child: Row(
        children: [
          Text(K.getTranslation('phone_number')),
          const Spacer(),
          Text('+${Session.userInfo.phone}'),
          const GoNextIcon(
            size: 36,
          ),
        ],
      ),
    );
  }
  Widget _buildEmailAddressItem() {
    return ThrottleInkWell(
      onTap: () async {
        ILoginRouter loginRouter = (RouterManager.instance
            .getModuleRouter(ModuleType.Login) as ILoginRouter);
        await loginRouter.toEmailVerificationCodePage(
            VerficationType.changePhoneNumberOld,
            K.getTranslation('verification_for_change_email'),
            Session.userInfo.email,
            );
        setState(() {});
      },
      child: Row(
        children: [
          Text(K.getTranslation('email_address')),
          const Spacer(),
          Text(Session.userInfo.email),
          const GoNextIcon(
            size: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildBirthDayItem() {
    return ThrottleInkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          locale: ui.window.locale,
          initialDate: Session.birthdayDate,
          firstDate: DateTime(1970),
          lastDate: DateTime(2030),
        );
        if (picked == null) return;
        Resp resp = await ProfileApi.setUerInfo(
            {'bornAt': picked!.millisecondsSinceEpoch});
        if (resp.code == 1) {
          Session.bornAt =
              Int64.parseInt('${picked!.millisecondsSinceEpoch ~/ 1000}');
          setState(() {});
        }
      },
      child: Row(
        children: [
          Text(K.getTranslation('birthday')),
          const Spacer(),
          Text(Session.birthday),
          const GoNextIcon(
            size: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureItem() {
    return ThrottleInkWell(
      onTap: () async {
        await SigntureEditPage.show(Constant.context);
        setState(() {});
      },
      child: Row(
        children: [
          Text(K.getTranslation('signature')),
          const Spacer(),
          Text(Session.userInfo?.signature ?? ''),
          const GoNextIcon(
            size: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelItem() {
    return Row(
      children: [
        Text(K.getTranslation('user_level')),
        const Spacer(),
        Text('${Session.userInfo.level}'),
      ],
    );
  }

  Widget _buildAreaItem() {
    return ThrottleInkWell(
      onTap: () async {
        Map<String, String>? result =
            await AreaSettingWidget.showFromModalBottomSheet(context);
        if (result != null && result!.isNotEmpty) {
          Resp resp = await ProfileApi.setUerInfo({
            'countryName': result!['country'] ?? '',
            'state': result!['state'] ?? '',
            'city': result['city'] ?? ''
          });
          if (resp.code == 1) {
            Session.countryName = result!['country'] ?? '';
            Session.provinceName = result!['state'] ?? '';
            Session.cityName = result!['city'] ?? '';
            setState(() {});
          }
        }
      },
      child: Row(
        children: [
          Text(K.getTranslation('area')),
          const Spacer(),
          Text(
              '${Session.userInfo.countryName} ${Session.userInfo.provinceName} ${Session.userInfo.cityName}'),
          const GoNextIcon(
            size: 36,
          ),
        ],
      ),
    );
  }

  Widget _buildWealthItem() {
    return Row(
      children: [
        Text(K.getTranslation('wealth')),
        const Spacer(),
        Text('${Session.userInfo.wealth}'),
        // const GoNextIcon(
        //   size: 36,
        // ),
      ],
    );
  }
}
