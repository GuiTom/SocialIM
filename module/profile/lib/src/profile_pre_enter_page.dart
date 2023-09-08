import 'dart:typed_data';
import 'package:base/base.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as Img;
import 'package:intl/intl.dart';
import 'package:profile/src/edit_page/area_setting_widget.dart';
import 'package:profile/src/profile_api.dart';
import 'package:profile/src/widget/select_gender_widget.dart';
import 'locale/k.dart';
import 'dart:ui' as ui;
import 'package:base/src/locale/k.dart' as BaseK;
import 'package:geocoding/geocoding.dart';

class ProfilePreEnterPage extends StatefulWidget {
  static Future show(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (context) => const ProfilePreEnterPage(),
        settings: const RouteSettings(name: '/ProfilePreEnterPage'),
      ),
    );
  }

  const ProfilePreEnterPage({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ProfilePreEnterPage> {
  final TextEditingController _nickNameController =
      TextEditingController(text: Session.userInfo.name);
  final TextEditingController _birrthDayController =
      TextEditingController(text: Session.birthday);
  late final TextEditingController _genderController;
  late final TextEditingController _areaController;

  Int64 _selectedBornAt = Session.userInfo.bornAt*1000;
  int _selectedGender = Session.userInfo.sex;
  String _selectedCountry = Session.userInfo.countryName;
  String _selectedCity = Session.userInfo.cityName;
  String _selectedProvince = Session.userInfo.provinceName;
  bool _needSDKLocation = true;
  @override
  void initState() {
    super.initState();
    _genderController = TextEditingController(
        text: _selectedGender == 1
            ? BaseK.K.getTranslation('male')
            : BaseK.K.getTranslation('female'));
    if(_selectedCountry.isNotEmpty||_selectedProvince.isNotEmpty||_selectedCity.isNotEmpty){
      _areaController.text =
      '$_selectedCountry $_selectedProvince $_selectedCity';
    }else {
      _areaController = TextEditingController(
          text: K.getTranslation('locating'));
    }

    _getLocation();
  }

  Future _getLocation() async {

    Placemark? placemark = await LocationUtil.getLocation();

    if (placemark != null&&_needSDKLocation) {
      _selectedCountry = placemark!.country ?? '';
      _selectedProvince = placemark!.administrativeArea ?? '';
      _selectedCity = placemark!.locality ?? '';
      _areaController.text =
      '$_selectedCountry $_selectedProvince $_selectedCity';
      // setState(() {});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            _buildIgnoreButton(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                K.getTranslation('set_your_impress'),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            _buildUserHeadUploadWidget(),
            const SizedBox(
              height: 20,
            ),
            _buildNickNameInputWidget(),
            const SizedBox(
              height: 20,
            ),
            _buildBirthdayInputWidget(),
            const SizedBox(
              height: 20,
            ),
            _buildGenderInputWidet(),
            const SizedBox(
              height: 20,
            ),
            _buildAreaInputWidet(),
            const SizedBox(
              height: 50,
            ),
            _buildConfirmButton(),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildIgnoreButton() {
    return Align(
      alignment: AlignmentDirectional.topEnd,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 20),
        child: ThrottleInkWell(
          onTap: () {
              Session.needShowProfilePreset = false;
              Navigator.popUntil(context, ModalRoute.withName('/'));
              eventCenter.emit('userInfoChanged');
          },
          child: Text(
            K.getTranslation('skip'),
            style: const TextStyle(
                color: Color(0x3F111111),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
  Widget _buildUserHeadUploadWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 30),
      child: GestureDetector(
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
                context, imageUrl, [80]);
            setState(() {});
          } else {
            ToastUtil.showCenter(msg: uploadResp.message);
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            UserHeadWidget(
                imageUrl: Util.getHeadIconUrl(Session.uid), size: 80,isMale:_selectedGender==1),
            SvgPicture.asset(
              'assets/icon_camera_upload.svg',
              width: 32,
              height: 32,
              package: 'profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNickNameInputWidget() {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFA1A1A1)),
      ),
      child: TextField(
        controller: _nickNameController,
        style: const TextStyle(
            color: Color(0xFF313131), fontWeight: FontWeight.bold),
        textAlign: TextAlign.end,
        decoration: InputDecoration(
            prefixText: K.getTranslation('nickname'),
            prefixStyle: const TextStyle(color: Colors.black),
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 8,vertical: 16),
            border: InputBorder.none,
            hintText: K.getTranslation('enter_nickname'),
            suffixIcon: GestureDetector(
              onTap: () async {
                GenerateNameResp resp =
                    await ProfileApi.genName({'sex': _selectedGender});
                if (resp.code == 1) {
                  _nickNameController.text = resp.data;
                  setState(() {});
                }
              },
              child: SvgPicture.asset(
                'assets/icon_refresh.svg',
                package: 'profile',
              ),
            ),
            suffixIconConstraints: BoxConstraints.tight(const Size(36, 24))),
        onSubmitted: (value) {
          if (value.length > 10) {
            ToastUtil.showTop(
                msg: K.getTranslation('enter_signature_length_tip'));
            return;
          }
        },
      ),
    );
  }

  Widget _buildBirthdayInputWidget() {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFA1A1A1)),
      ),
      child: TextField(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            locale: ui.window.locale,
            initialDate: Session.birthdayDate,
            firstDate: DateTime(1970),
            lastDate: DateTime(2030),
          );
          if (picked == null) return;

          _selectedBornAt = Int64.parseInt('${picked!.millisecondsSinceEpoch}');
          _birrthDayController.text = DateFormat(
                  BaseK.K.getTranslation('date_str', args: ['yyyy', 'M', 'd']))
              .format(picked!);
          setState(() {});
        },
        controller: _birrthDayController,
        readOnly: true,
        style: const TextStyle(
            color: Color(0xFF313131), fontWeight: FontWeight.bold),
        textAlign: TextAlign.end,
        decoration: InputDecoration(
            prefixText: K.getTranslation('birthday'),
            prefixStyle: const TextStyle(color: Colors.black),
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 8,vertical: 16),
            border: InputBorder.none,
            hintText: K.getTranslation('enter_your_birthday'),
            suffixIcon: SvgPicture.asset(
              'assets/icon_arror_right.svg',
              package: 'profile',
            ),
            suffixIconConstraints: BoxConstraints.tight(const Size(36, 24))),
        onSubmitted: (value) {},
      ),
    );
  }

  Widget _buildGenderInputWidet() {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFA1A1A1)),
      ),
      child: TextField(
        onTap: () async {
          int? result =
              await SelectGenderWidget.show(context, gender: _selectedGender);
          if (result == null) return;
          _selectedGender = result;
          _genderController.text = _selectedGender == 1
              ? BaseK.K.getTranslation('male')
              : BaseK.K.getTranslation('female');
        },
        controller: _genderController,
        readOnly: true,
        style: const TextStyle(
            color: Color(0xFF313131), fontWeight: FontWeight.bold),
        textAlign: TextAlign.end,
        decoration: InputDecoration(
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Text(K.getTranslation('gender')),
                Image.asset(
                  'assets/icon_star.png',
                  package: 'profile',
                  width: 12,
                  height: 12,
                ),
              ],
            ),
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 8,vertical: 16),
            border: InputBorder.none,
            hintText: K.getTranslation('input_gender'),
            suffixIcon: Align(
              alignment: AlignmentDirectional.centerStart,
              child: SvgPicture.asset(
                'assets/icon_arror_right.svg',
                package: 'profile',
                width: 24,
                height: 24,
              ),
            ),
            suffixIconConstraints: BoxConstraints.tight(const Size(36, 24))),
        onSubmitted: (value) {
          if (value.length > 10) {
            ToastUtil.showTop(
                msg: K.getTranslation('enter_signature_length_tip'));
            return;
          }
        },
      ),
    );
  }

  Widget _buildAreaInputWidet() {
    return Container(
      alignment: AlignmentDirectional.center,
      margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(width: 1, color: const Color(0xFFA1A1A1)),
      ),
      child: TextField(
        onTap: () async {
          Map<String, String>? result =
              await AreaSettingWidget.showFromModalBottomSheet(context);
          if (result != null) {
            _selectedCountry = result!['country'] ?? '';
            _selectedProvince = result!['state'] ?? '';
            _selectedCity = result!['city'] ?? '';
            _areaController.text =
                '$_selectedCountry $_selectedProvince $_selectedCity';
            _needSDKLocation = false;
          }
        },
        controller: _areaController,
        readOnly: true,
        style: const TextStyle(
            color: Color(0xFF313131), fontWeight: FontWeight.bold),
        textAlign: TextAlign.end,
        decoration: InputDecoration(
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 8,
                ),
                Text(K.getTranslation('city')),
              ],
            ),
            contentPadding: const EdgeInsetsDirectional.symmetric(horizontal: 8,vertical: 16),
            border: InputBorder.none,
            hintText: K.getTranslation('input_gender'),
            suffixIcon: Align(
              alignment: AlignmentDirectional.centerStart,
              child: SvgPicture.asset(
                'assets/icon_arror_right.svg',
                package: 'profile',
                width: 24,
                height: 24,
              ),
            ),
            suffixIconConstraints: BoxConstraints.tight(const Size(36, 24))),
        onSubmitted: (value) {
          if (value.length > 10) {
            ToastUtil.showTop(
                msg: K.getTranslation('enter_signature_length_tip'));
            return;
          }
        },
      ),
    );
  }

  Widget _buildConfirmButton() {
    return ThrottleInkWell(
      onTap: () async {
        Resp resp = await ProfileApi.setUerInfo({
          'bornAt': _selectedBornAt,
          'sex': _selectedGender,
          'name': _nickNameController.text,
          'cityName': _selectedCity ?? '',
          'countryName': _selectedCountry ?? '',
          'provinceName': _selectedProvince ?? ''
        });
        // Session.needShowProfilePreset = false;
        if (resp.code == 1) {
          Session.name = _nickNameController.text;
          Session.bornAt = _selectedBornAt ~/ 1000;
          Session.sex = _selectedGender;
          Session.countryName = _selectedCountry;
          Session.provinceName = _selectedProvince;
          Session.cityName = _selectedCity;
          Navigator.popUntil(context, ModalRoute.withName('/'));
          eventCenter.emit('userInfoChanged');
        }
      },
      child: Button(
        title: K.getTranslation('enter_new_world'),
        buttonSize: ButtonSize.Big,
      ),
    );
  }
}
