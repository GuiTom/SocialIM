///
//  Generated code. Do not modify.
//  source: global_config.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class GameInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GameInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'config'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'iconUrl', protoName: 'iconUrl')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'url')
    ..hasRequiredFields = false
  ;

  GameInfo._() : super();
  factory GameInfo({
    $core.int? id,
    $core.String? name,
    $core.String? iconUrl,
    $core.String? url,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (name != null) {
      _result.name = name;
    }
    if (iconUrl != null) {
      _result.iconUrl = iconUrl;
    }
    if (url != null) {
      _result.url = url;
    }
    return _result;
  }
  factory GameInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GameInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GameInfo clone() => GameInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GameInfo copyWith(void Function(GameInfo) updates) => super.copyWith((message) => updates(message as GameInfo)) as GameInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GameInfo create() => GameInfo._();
  GameInfo createEmptyInstance() => create();
  static $pb.PbList<GameInfo> createRepeated() => $pb.PbList<GameInfo>();
  @$core.pragma('dart2js:noInline')
  static GameInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GameInfo>(create);
  static GameInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
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
  $core.String get iconUrl => $_getSZ(2);
  @$pb.TagNumber(3)
  set iconUrl($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIconUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearIconUrl() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get url => $_getSZ(3);
  @$pb.TagNumber(4)
  set url($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearUrl() => clearField(4);
}

class GlobalConfig extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GlobalConfig', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'config'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latestVersionCodeAndroid', $pb.PbFieldType.O3, protoName: 'latestVersionCodeAndroid')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latestVersionCodeIOS', $pb.PbFieldType.O3, protoName: 'latestVersionCodeIOS')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'downloadPageAndroid', protoName: 'downloadPageAndroid')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'downloadPageIos', protoName: 'downloadPageIos')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customerServicePhone', protoName: 'customerServicePhone')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'customerServiceWechat', protoName: 'customerServiceWechat')
    ..hasRequiredFields = false
  ;

  GlobalConfig._() : super();
  factory GlobalConfig({
    $core.int? latestVersionCodeAndroid,
    $core.int? latestVersionCodeIOS,
    $core.String? downloadPageAndroid,
    $core.String? downloadPageIos,
    $core.String? customerServicePhone,
    $core.String? customerServiceWechat,
  }) {
    final _result = create();
    if (latestVersionCodeAndroid != null) {
      _result.latestVersionCodeAndroid = latestVersionCodeAndroid;
    }
    if (latestVersionCodeIOS != null) {
      _result.latestVersionCodeIOS = latestVersionCodeIOS;
    }
    if (downloadPageAndroid != null) {
      _result.downloadPageAndroid = downloadPageAndroid;
    }
    if (downloadPageIos != null) {
      _result.downloadPageIos = downloadPageIos;
    }
    if (customerServicePhone != null) {
      _result.customerServicePhone = customerServicePhone;
    }
    if (customerServiceWechat != null) {
      _result.customerServiceWechat = customerServiceWechat;
    }
    return _result;
  }
  factory GlobalConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GlobalConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GlobalConfig clone() => GlobalConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GlobalConfig copyWith(void Function(GlobalConfig) updates) => super.copyWith((message) => updates(message as GlobalConfig)) as GlobalConfig; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GlobalConfig create() => GlobalConfig._();
  GlobalConfig createEmptyInstance() => create();
  static $pb.PbList<GlobalConfig> createRepeated() => $pb.PbList<GlobalConfig>();
  @$core.pragma('dart2js:noInline')
  static GlobalConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GlobalConfig>(create);
  static GlobalConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get latestVersionCodeAndroid => $_getIZ(0);
  @$pb.TagNumber(1)
  set latestVersionCodeAndroid($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatestVersionCodeAndroid() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatestVersionCodeAndroid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get latestVersionCodeIOS => $_getIZ(1);
  @$pb.TagNumber(2)
  set latestVersionCodeIOS($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatestVersionCodeIOS() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatestVersionCodeIOS() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get downloadPageAndroid => $_getSZ(2);
  @$pb.TagNumber(3)
  set downloadPageAndroid($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDownloadPageAndroid() => $_has(2);
  @$pb.TagNumber(3)
  void clearDownloadPageAndroid() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get downloadPageIos => $_getSZ(3);
  @$pb.TagNumber(4)
  set downloadPageIos($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDownloadPageIos() => $_has(3);
  @$pb.TagNumber(4)
  void clearDownloadPageIos() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get customerServicePhone => $_getSZ(4);
  @$pb.TagNumber(5)
  set customerServicePhone($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCustomerServicePhone() => $_has(4);
  @$pb.TagNumber(5)
  void clearCustomerServicePhone() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get customerServiceWechat => $_getSZ(5);
  @$pb.TagNumber(6)
  set customerServiceWechat($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCustomerServiceWechat() => $_has(5);
  @$pb.TagNumber(6)
  void clearCustomerServiceWechat() => clearField(6);
}

class GlobalConfigInfoResp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GlobalConfigInfoResp', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'config'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..aOM<GlobalConfig>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', subBuilder: GlobalConfig.create)
    ..pc<GameInfo>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'games', $pb.PbFieldType.PM, subBuilder: GameInfo.create)
    ..hasRequiredFields = false
  ;

  GlobalConfigInfoResp._() : super();
  factory GlobalConfigInfoResp({
    $fixnum.Int64? code,
    $core.String? message,
    GlobalConfig? data,
    $core.Iterable<GameInfo>? games,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (message != null) {
      _result.message = message;
    }
    if (data != null) {
      _result.data = data;
    }
    if (games != null) {
      _result.games.addAll(games);
    }
    return _result;
  }
  factory GlobalConfigInfoResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GlobalConfigInfoResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GlobalConfigInfoResp clone() => GlobalConfigInfoResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GlobalConfigInfoResp copyWith(void Function(GlobalConfigInfoResp) updates) => super.copyWith((message) => updates(message as GlobalConfigInfoResp)) as GlobalConfigInfoResp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GlobalConfigInfoResp create() => GlobalConfigInfoResp._();
  GlobalConfigInfoResp createEmptyInstance() => create();
  static $pb.PbList<GlobalConfigInfoResp> createRepeated() => $pb.PbList<GlobalConfigInfoResp>();
  @$core.pragma('dart2js:noInline')
  static GlobalConfigInfoResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GlobalConfigInfoResp>(create);
  static GlobalConfigInfoResp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get code => $_getI64(0);
  @$pb.TagNumber(1)
  set code($fixnum.Int64 v) { $_setInt64(0, v); }
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
  GlobalConfig get data => $_getN(2);
  @$pb.TagNumber(3)
  set data(GlobalConfig v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
  @$pb.TagNumber(3)
  GlobalConfig ensureData() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.List<GameInfo> get games => $_getList(3);
}

