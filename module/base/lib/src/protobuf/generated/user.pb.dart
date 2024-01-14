//
//  Generated code. Do not modify.
//  source: user.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class User extends $pb.GeneratedMessage {
  factory User({
    $fixnum.Int64? id,
    $core.String? name,
    $core.int? sex,
    $core.int? height,
    $core.String? email,
    $core.String? phone,
    $core.String? headId,
    $core.int? level,
    $fixnum.Int64? createAt,
    $fixnum.Int64? bornAt,
    $core.String? signature,
    $core.String? cityCode,
    $core.String? provinceCode,
    $core.String? countryCode,
    $core.String? cityName,
    $core.String? provinceName,
    $core.String? countryName,
    $core.String? setting,
    $core.bool? passwordSetted,
    $core.bool? toUnRegister,
    $core.String? friendUidListStr,
    $core.String? fansUidListStr,
    $core.String? focusUidListStr,
    $core.String? blackUidListStr,
    $core.String? blackDynIdListStr,
    $core.int? worksCount,
    $fixnum.Int64? monthlyVipExpireAt,
    $fixnum.Int64? yearlyVipExpireAt,
    $core.bool? hasCrown,
    $core.int? coin,
    $core.int? forbidden,
    $core.String? covers,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (sex != null) {
      $result.sex = sex;
    }
    if (height != null) {
      $result.height = height;
    }
    if (email != null) {
      $result.email = email;
    }
    if (phone != null) {
      $result.phone = phone;
    }
    if (headId != null) {
      $result.headId = headId;
    }
    if (level != null) {
      $result.level = level;
    }
    if (createAt != null) {
      $result.createAt = createAt;
    }
    if (bornAt != null) {
      $result.bornAt = bornAt;
    }
    if (signature != null) {
      $result.signature = signature;
    }
    if (cityCode != null) {
      $result.cityCode = cityCode;
    }
    if (provinceCode != null) {
      $result.provinceCode = provinceCode;
    }
    if (countryCode != null) {
      $result.countryCode = countryCode;
    }
    if (cityName != null) {
      $result.cityName = cityName;
    }
    if (provinceName != null) {
      $result.provinceName = provinceName;
    }
    if (countryName != null) {
      $result.countryName = countryName;
    }
    if (setting != null) {
      $result.setting = setting;
    }
    if (passwordSetted != null) {
      $result.passwordSetted = passwordSetted;
    }
    if (toUnRegister != null) {
      $result.toUnRegister = toUnRegister;
    }
    if (friendUidListStr != null) {
      $result.friendUidListStr = friendUidListStr;
    }
    if (fansUidListStr != null) {
      $result.fansUidListStr = fansUidListStr;
    }
    if (focusUidListStr != null) {
      $result.focusUidListStr = focusUidListStr;
    }
    if (blackUidListStr != null) {
      $result.blackUidListStr = blackUidListStr;
    }
    if (blackDynIdListStr != null) {
      $result.blackDynIdListStr = blackDynIdListStr;
    }
    if (worksCount != null) {
      $result.worksCount = worksCount;
    }
    if (monthlyVipExpireAt != null) {
      $result.monthlyVipExpireAt = monthlyVipExpireAt;
    }
    if (yearlyVipExpireAt != null) {
      $result.yearlyVipExpireAt = yearlyVipExpireAt;
    }
    if (hasCrown != null) {
      $result.hasCrown = hasCrown;
    }
    if (coin != null) {
      $result.coin = coin;
    }
    if (forbidden != null) {
      $result.forbidden = forbidden;
    }
    if (covers != null) {
      $result.covers = covers;
    }
    return $result;
  }
  User._() : super();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'User', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'sex', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'email')
    ..aOS(6, _omitFieldNames ? '' : 'phone')
    ..aOS(8, _omitFieldNames ? '' : 'headId', protoName: 'headId')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'level', $pb.PbFieldType.O3)
    ..aInt64(10, _omitFieldNames ? '' : 'createAt', protoName: 'createAt')
    ..aInt64(11, _omitFieldNames ? '' : 'bornAt', protoName: 'bornAt')
    ..aOS(12, _omitFieldNames ? '' : 'signature')
    ..aOS(13, _omitFieldNames ? '' : 'cityCode', protoName: 'cityCode')
    ..aOS(14, _omitFieldNames ? '' : 'provinceCode', protoName: 'provinceCode')
    ..aOS(15, _omitFieldNames ? '' : 'countryCode', protoName: 'countryCode')
    ..aOS(16, _omitFieldNames ? '' : 'cityName', protoName: 'cityName')
    ..aOS(17, _omitFieldNames ? '' : 'provinceName', protoName: 'provinceName')
    ..aOS(18, _omitFieldNames ? '' : 'countryName', protoName: 'countryName')
    ..aOS(19, _omitFieldNames ? '' : 'setting')
    ..aOB(20, _omitFieldNames ? '' : 'passwordSetted', protoName: 'passwordSetted')
    ..aOB(21, _omitFieldNames ? '' : 'toUnRegister', protoName: 'toUnRegister')
    ..aOS(22, _omitFieldNames ? '' : 'friendUidListStr', protoName: 'friendUidListStr')
    ..aOS(23, _omitFieldNames ? '' : 'fansUidListStr', protoName: 'fansUidListStr')
    ..aOS(24, _omitFieldNames ? '' : 'focusUidListStr', protoName: 'focusUidListStr')
    ..aOS(25, _omitFieldNames ? '' : 'blackUidListStr', protoName: 'blackUidListStr')
    ..aOS(26, _omitFieldNames ? '' : 'blackDynIdListStr', protoName: 'blackDynIdListStr')
    ..a<$core.int>(27, _omitFieldNames ? '' : 'worksCount', $pb.PbFieldType.O3, protoName: 'worksCount')
    ..aInt64(28, _omitFieldNames ? '' : 'monthlyVipExpireAt', protoName: 'monthlyVipExpireAt')
    ..aInt64(29, _omitFieldNames ? '' : 'yearlyVipExpireAt', protoName: 'yearlyVipExpireAt')
    ..aOB(30, _omitFieldNames ? '' : 'hasCrown', protoName: 'hasCrown')
    ..a<$core.int>(31, _omitFieldNames ? '' : 'coin', $pb.PbFieldType.O3)
    ..a<$core.int>(32, _omitFieldNames ? '' : 'forbidden', $pb.PbFieldType.O3)
    ..aOS(34, _omitFieldNames ? '' : 'covers')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  User clone() => User()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User)) as User;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get sex => $_getIZ(2);
  @$pb.TagNumber(3)
  set sex($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSex() => $_has(2);
  @$pb.TagNumber(3)
  void clearSex() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get height => $_getIZ(3);
  @$pb.TagNumber(4)
  set height($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get email => $_getSZ(4);
  @$pb.TagNumber(5)
  set email($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEmail() => $_has(4);
  @$pb.TagNumber(5)
  void clearEmail() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get phone => $_getSZ(5);
  @$pb.TagNumber(6)
  set phone($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPhone() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhone() => clearField(6);

  @$pb.TagNumber(8)
  $core.String get headId => $_getSZ(6);
  @$pb.TagNumber(8)
  set headId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasHeadId() => $_has(6);
  @$pb.TagNumber(8)
  void clearHeadId() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get level => $_getIZ(7);
  @$pb.TagNumber(9)
  set level($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(9)
  $core.bool hasLevel() => $_has(7);
  @$pb.TagNumber(9)
  void clearLevel() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get createAt => $_getI64(8);
  @$pb.TagNumber(10)
  set createAt($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(10)
  $core.bool hasCreateAt() => $_has(8);
  @$pb.TagNumber(10)
  void clearCreateAt() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get bornAt => $_getI64(9);
  @$pb.TagNumber(11)
  set bornAt($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(11)
  $core.bool hasBornAt() => $_has(9);
  @$pb.TagNumber(11)
  void clearBornAt() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get signature => $_getSZ(10);
  @$pb.TagNumber(12)
  set signature($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(12)
  $core.bool hasSignature() => $_has(10);
  @$pb.TagNumber(12)
  void clearSignature() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get cityCode => $_getSZ(11);
  @$pb.TagNumber(13)
  set cityCode($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(13)
  $core.bool hasCityCode() => $_has(11);
  @$pb.TagNumber(13)
  void clearCityCode() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get provinceCode => $_getSZ(12);
  @$pb.TagNumber(14)
  set provinceCode($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(14)
  $core.bool hasProvinceCode() => $_has(12);
  @$pb.TagNumber(14)
  void clearProvinceCode() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get countryCode => $_getSZ(13);
  @$pb.TagNumber(15)
  set countryCode($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(15)
  $core.bool hasCountryCode() => $_has(13);
  @$pb.TagNumber(15)
  void clearCountryCode() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get cityName => $_getSZ(14);
  @$pb.TagNumber(16)
  set cityName($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(16)
  $core.bool hasCityName() => $_has(14);
  @$pb.TagNumber(16)
  void clearCityName() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get provinceName => $_getSZ(15);
  @$pb.TagNumber(17)
  set provinceName($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(17)
  $core.bool hasProvinceName() => $_has(15);
  @$pb.TagNumber(17)
  void clearProvinceName() => clearField(17);

  @$pb.TagNumber(18)
  $core.String get countryName => $_getSZ(16);
  @$pb.TagNumber(18)
  set countryName($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(18)
  $core.bool hasCountryName() => $_has(16);
  @$pb.TagNumber(18)
  void clearCountryName() => clearField(18);

  @$pb.TagNumber(19)
  $core.String get setting => $_getSZ(17);
  @$pb.TagNumber(19)
  set setting($core.String v) { $_setString(17, v); }
  @$pb.TagNumber(19)
  $core.bool hasSetting() => $_has(17);
  @$pb.TagNumber(19)
  void clearSetting() => clearField(19);

  @$pb.TagNumber(20)
  $core.bool get passwordSetted => $_getBF(18);
  @$pb.TagNumber(20)
  set passwordSetted($core.bool v) { $_setBool(18, v); }
  @$pb.TagNumber(20)
  $core.bool hasPasswordSetted() => $_has(18);
  @$pb.TagNumber(20)
  void clearPasswordSetted() => clearField(20);

  @$pb.TagNumber(21)
  $core.bool get toUnRegister => $_getBF(19);
  @$pb.TagNumber(21)
  set toUnRegister($core.bool v) { $_setBool(19, v); }
  @$pb.TagNumber(21)
  $core.bool hasToUnRegister() => $_has(19);
  @$pb.TagNumber(21)
  void clearToUnRegister() => clearField(21);

  @$pb.TagNumber(22)
  $core.String get friendUidListStr => $_getSZ(20);
  @$pb.TagNumber(22)
  set friendUidListStr($core.String v) { $_setString(20, v); }
  @$pb.TagNumber(22)
  $core.bool hasFriendUidListStr() => $_has(20);
  @$pb.TagNumber(22)
  void clearFriendUidListStr() => clearField(22);

  @$pb.TagNumber(23)
  $core.String get fansUidListStr => $_getSZ(21);
  @$pb.TagNumber(23)
  set fansUidListStr($core.String v) { $_setString(21, v); }
  @$pb.TagNumber(23)
  $core.bool hasFansUidListStr() => $_has(21);
  @$pb.TagNumber(23)
  void clearFansUidListStr() => clearField(23);

  @$pb.TagNumber(24)
  $core.String get focusUidListStr => $_getSZ(22);
  @$pb.TagNumber(24)
  set focusUidListStr($core.String v) { $_setString(22, v); }
  @$pb.TagNumber(24)
  $core.bool hasFocusUidListStr() => $_has(22);
  @$pb.TagNumber(24)
  void clearFocusUidListStr() => clearField(24);

  @$pb.TagNumber(25)
  $core.String get blackUidListStr => $_getSZ(23);
  @$pb.TagNumber(25)
  set blackUidListStr($core.String v) { $_setString(23, v); }
  @$pb.TagNumber(25)
  $core.bool hasBlackUidListStr() => $_has(23);
  @$pb.TagNumber(25)
  void clearBlackUidListStr() => clearField(25);

  @$pb.TagNumber(26)
  $core.String get blackDynIdListStr => $_getSZ(24);
  @$pb.TagNumber(26)
  set blackDynIdListStr($core.String v) { $_setString(24, v); }
  @$pb.TagNumber(26)
  $core.bool hasBlackDynIdListStr() => $_has(24);
  @$pb.TagNumber(26)
  void clearBlackDynIdListStr() => clearField(26);

  @$pb.TagNumber(27)
  $core.int get worksCount => $_getIZ(25);
  @$pb.TagNumber(27)
  set worksCount($core.int v) { $_setSignedInt32(25, v); }
  @$pb.TagNumber(27)
  $core.bool hasWorksCount() => $_has(25);
  @$pb.TagNumber(27)
  void clearWorksCount() => clearField(27);

  @$pb.TagNumber(28)
  $fixnum.Int64 get monthlyVipExpireAt => $_getI64(26);
  @$pb.TagNumber(28)
  set monthlyVipExpireAt($fixnum.Int64 v) { $_setInt64(26, v); }
  @$pb.TagNumber(28)
  $core.bool hasMonthlyVipExpireAt() => $_has(26);
  @$pb.TagNumber(28)
  void clearMonthlyVipExpireAt() => clearField(28);

  @$pb.TagNumber(29)
  $fixnum.Int64 get yearlyVipExpireAt => $_getI64(27);
  @$pb.TagNumber(29)
  set yearlyVipExpireAt($fixnum.Int64 v) { $_setInt64(27, v); }
  @$pb.TagNumber(29)
  $core.bool hasYearlyVipExpireAt() => $_has(27);
  @$pb.TagNumber(29)
  void clearYearlyVipExpireAt() => clearField(29);

  @$pb.TagNumber(30)
  $core.bool get hasCrown => $_getBF(28);
  @$pb.TagNumber(30)
  set hasCrown($core.bool v) { $_setBool(28, v); }
  @$pb.TagNumber(30)
  $core.bool hasHasCrown() => $_has(28);
  @$pb.TagNumber(30)
  void clearHasCrown() => clearField(30);

  @$pb.TagNumber(31)
  $core.int get coin => $_getIZ(29);
  @$pb.TagNumber(31)
  set coin($core.int v) { $_setSignedInt32(29, v); }
  @$pb.TagNumber(31)
  $core.bool hasCoin() => $_has(29);
  @$pb.TagNumber(31)
  void clearCoin() => clearField(31);

  @$pb.TagNumber(32)
  $core.int get forbidden => $_getIZ(30);
  @$pb.TagNumber(32)
  set forbidden($core.int v) { $_setSignedInt32(30, v); }
  @$pb.TagNumber(32)
  $core.bool hasForbidden() => $_has(30);
  @$pb.TagNumber(32)
  void clearForbidden() => clearField(32);

  @$pb.TagNumber(34)
  $core.String get covers => $_getSZ(31);
  @$pb.TagNumber(34)
  set covers($core.String v) { $_setString(31, v); }
  @$pb.TagNumber(34)
  $core.bool hasCovers() => $_has(31);
  @$pb.TagNumber(34)
  void clearCovers() => clearField(34);
}

class UserListResp extends $pb.GeneratedMessage {
  factory UserListResp({
    $core.int? code,
    $core.String? message,
    $core.Iterable<User>? data,
    $core.bool? hasMore,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (data != null) {
      $result.data.addAll(data);
    }
    if (hasMore != null) {
      $result.hasMore = hasMore;
    }
    return $result;
  }
  UserListResp._() : super();
  factory UserListResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserListResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserListResp', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<User>(3, _omitFieldNames ? '' : 'data', $pb.PbFieldType.PM, subBuilder: User.create)
    ..aOB(4, _omitFieldNames ? '' : 'hasMore', protoName: 'hasMore')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserListResp clone() => UserListResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserListResp copyWith(void Function(UserListResp) updates) => super.copyWith((message) => updates(message as UserListResp)) as UserListResp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserListResp create() => UserListResp._();
  UserListResp createEmptyInstance() => create();
  static $pb.PbList<UserListResp> createRepeated() => $pb.PbList<UserListResp>();
  @$core.pragma('dart2js:noInline')
  static UserListResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserListResp>(create);
  static UserListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<User> get data => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get hasMore => $_getBF(3);
  @$pb.TagNumber(4)
  set hasMore($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHasMore() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasMore() => clearField(4);
}

class UserInfoResp extends $pb.GeneratedMessage {
  factory UserInfoResp({
    $core.int? code,
    $core.String? message,
    User? data,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  UserInfoResp._() : super();
  factory UserInfoResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserInfoResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserInfoResp', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOM<User>(3, _omitFieldNames ? '' : 'data', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserInfoResp clone() => UserInfoResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserInfoResp copyWith(void Function(UserInfoResp) updates) => super.copyWith((message) => updates(message as UserInfoResp)) as UserInfoResp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfoResp create() => UserInfoResp._();
  UserInfoResp createEmptyInstance() => create();
  static $pb.PbList<UserInfoResp> createRepeated() => $pb.PbList<UserInfoResp>();
  @$core.pragma('dart2js:noInline')
  static UserInfoResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserInfoResp>(create);
  static UserInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  User get data => $_getN(2);
  @$pb.TagNumber(3)
  set data(User v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
  @$pb.TagNumber(3)
  User ensureData() => $_ensure(2);
}

class GenerateNameResp extends $pb.GeneratedMessage {
  factory GenerateNameResp({
    $core.int? code,
    $core.String? message,
    $core.String? data,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (data != null) {
      $result.data = data;
    }
    return $result;
  }
  GenerateNameResp._() : super();
  factory GenerateNameResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateNameResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateNameResp', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'data')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateNameResp clone() => GenerateNameResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateNameResp copyWith(void Function(GenerateNameResp) updates) => super.copyWith((message) => updates(message as GenerateNameResp)) as GenerateNameResp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateNameResp create() => GenerateNameResp._();
  GenerateNameResp createEmptyInstance() => create();
  static $pb.PbList<GenerateNameResp> createRepeated() => $pb.PbList<GenerateNameResp>();
  @$core.pragma('dart2js:noInline')
  static GenerateNameResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateNameResp>(create);
  static GenerateNameResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get data => $_getSZ(2);
  @$pb.TagNumber(3)
  set data($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
}

class FriendListResp extends $pb.GeneratedMessage {
  factory FriendListResp({
    $core.int? code,
    $core.String? message,
    $core.Iterable<User>? list,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  FriendListResp._() : super();
  factory FriendListResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FriendListResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FriendListResp', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<User>(3, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FriendListResp clone() => FriendListResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FriendListResp copyWith(void Function(FriendListResp) updates) => super.copyWith((message) => updates(message as FriendListResp)) as FriendListResp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FriendListResp create() => FriendListResp._();
  FriendListResp createEmptyInstance() => create();
  static $pb.PbList<FriendListResp> createRepeated() => $pb.PbList<FriendListResp>();
  @$core.pragma('dart2js:noInline')
  static FriendListResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FriendListResp>(create);
  static FriendListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<User> get list => $_getList(2);
}

class FocusListResp extends $pb.GeneratedMessage {
  factory FocusListResp({
    $core.int? code,
    $core.String? message,
    $core.Iterable<User>? list,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  FocusListResp._() : super();
  factory FocusListResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FocusListResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FocusListResp', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<User>(3, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FocusListResp clone() => FocusListResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FocusListResp copyWith(void Function(FocusListResp) updates) => super.copyWith((message) => updates(message as FocusListResp)) as FocusListResp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FocusListResp create() => FocusListResp._();
  FocusListResp createEmptyInstance() => create();
  static $pb.PbList<FocusListResp> createRepeated() => $pb.PbList<FocusListResp>();
  @$core.pragma('dart2js:noInline')
  static FocusListResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FocusListResp>(create);
  static FocusListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<User> get list => $_getList(2);
}

class FansListResp extends $pb.GeneratedMessage {
  factory FansListResp({
    $core.int? code,
    $core.String? message,
    $core.Iterable<User>? list,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  FansListResp._() : super();
  factory FansListResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FansListResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FansListResp', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<User>(3, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FansListResp clone() => FansListResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FansListResp copyWith(void Function(FansListResp) updates) => super.copyWith((message) => updates(message as FansListResp)) as FansListResp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FansListResp create() => FansListResp._();
  FansListResp createEmptyInstance() => create();
  static $pb.PbList<FansListResp> createRepeated() => $pb.PbList<FansListResp>();
  @$core.pragma('dart2js:noInline')
  static FansListResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FansListResp>(create);
  static FansListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<User> get list => $_getList(2);
}

class UserBlackListResp extends $pb.GeneratedMessage {
  factory UserBlackListResp({
    $core.int? code,
    $core.String? message,
    $core.Iterable<User>? list,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (list != null) {
      $result.list.addAll(list);
    }
    return $result;
  }
  UserBlackListResp._() : super();
  factory UserBlackListResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserBlackListResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserBlackListResp', package: const $pb.PackageName(_omitMessageNames ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..pc<User>(3, _omitFieldNames ? '' : 'list', $pb.PbFieldType.PM, subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserBlackListResp clone() => UserBlackListResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserBlackListResp copyWith(void Function(UserBlackListResp) updates) => super.copyWith((message) => updates(message as UserBlackListResp)) as UserBlackListResp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserBlackListResp create() => UserBlackListResp._();
  UserBlackListResp createEmptyInstance() => create();
  static $pb.PbList<UserBlackListResp> createRepeated() => $pb.PbList<UserBlackListResp>();
  @$core.pragma('dart2js:noInline')
  static UserBlackListResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserBlackListResp>(create);
  static UserBlackListResp? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<User> get list => $_getList(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
