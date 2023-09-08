///
//  Generated code. Do not modify.
//  source: discover.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

class Dynamic extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Dynamic', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'user'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'uid', $pb.PbFieldType.O3)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nickName', protoName: 'nickName')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'attachment')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'likeInfo', protoName: 'likeInfo')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'firstCommentInfo', protoName: 'firstCommentInfo')
    ..a<$core.int>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'commentCount', $pb.PbFieldType.O3, protoName: 'commentCount')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createAt', protoName: 'createAt')
    ..hasRequiredFields = false
  ;

  Dynamic._() : super();
  factory Dynamic({
    $fixnum.Int64? id,
    $core.int? uid,
    $core.String? nickName,
    $core.String? content,
    $core.String? attachment,
    $core.String? likeInfo,
    $core.String? firstCommentInfo,
    $core.int? commentCount,
    $fixnum.Int64? createAt,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (uid != null) {
      _result.uid = uid;
    }
    if (nickName != null) {
      _result.nickName = nickName;
    }
    if (content != null) {
      _result.content = content;
    }
    if (attachment != null) {
      _result.attachment = attachment;
    }
    if (likeInfo != null) {
      _result.likeInfo = likeInfo;
    }
    if (firstCommentInfo != null) {
      _result.firstCommentInfo = firstCommentInfo;
    }
    if (commentCount != null) {
      _result.commentCount = commentCount;
    }
    if (createAt != null) {
      _result.createAt = createAt;
    }
    return _result;
  }
  factory Dynamic.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Dynamic.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Dynamic clone() => Dynamic()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Dynamic copyWith(void Function(Dynamic) updates) => super.copyWith((message) => updates(message as Dynamic)) as Dynamic; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Dynamic create() => Dynamic._();
  Dynamic createEmptyInstance() => create();
  static $pb.PbList<Dynamic> createRepeated() => $pb.PbList<Dynamic>();
  @$core.pragma('dart2js:noInline')
  static Dynamic getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Dynamic>(create);
  static Dynamic? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get uid => $_getIZ(1);
  @$pb.TagNumber(2)
  set uid($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get nickName => $_getSZ(2);
  @$pb.TagNumber(3)
  set nickName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNickName() => $_has(2);
  @$pb.TagNumber(3)
  void clearNickName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get attachment => $_getSZ(4);
  @$pb.TagNumber(5)
  set attachment($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAttachment() => $_has(4);
  @$pb.TagNumber(5)
  void clearAttachment() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get likeInfo => $_getSZ(5);
  @$pb.TagNumber(6)
  set likeInfo($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLikeInfo() => $_has(5);
  @$pb.TagNumber(6)
  void clearLikeInfo() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get firstCommentInfo => $_getSZ(6);
  @$pb.TagNumber(7)
  set firstCommentInfo($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFirstCommentInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearFirstCommentInfo() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get commentCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set commentCount($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCommentCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearCommentCount() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createAt => $_getI64(8);
  @$pb.TagNumber(9)
  set createAt($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreateAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreateAt() => clearField(9);
}

class DynamicListResp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DynamicListResp', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..pc<Dynamic>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.PM, subBuilder: Dynamic.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hasMore', protoName: 'hasMore')
    ..hasRequiredFields = false
  ;

  DynamicListResp._() : super();
  factory DynamicListResp({
    $core.int? code,
    $core.String? message,
    $core.Iterable<Dynamic>? data,
    $core.bool? hasMore,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (message != null) {
      _result.message = message;
    }
    if (data != null) {
      _result.data.addAll(data);
    }
    if (hasMore != null) {
      _result.hasMore = hasMore;
    }
    return _result;
  }
  factory DynamicListResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DynamicListResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DynamicListResp clone() => DynamicListResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DynamicListResp copyWith(void Function(DynamicListResp) updates) => super.copyWith((message) => updates(message as DynamicListResp)) as DynamicListResp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DynamicListResp create() => DynamicListResp._();
  DynamicListResp createEmptyInstance() => create();
  static $pb.PbList<DynamicListResp> createRepeated() => $pb.PbList<DynamicListResp>();
  @$core.pragma('dart2js:noInline')
  static DynamicListResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DynamicListResp>(create);
  static DynamicListResp? _defaultInstance;

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
  $core.List<Dynamic> get data => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get hasMore => $_getBF(3);
  @$pb.TagNumber(4)
  set hasMore($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHasMore() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasMore() => clearField(4);
}

class Comment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Comment', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.O3)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'dynamicId', $pb.PbFieldType.O3, protoName: 'dynamicId')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderUid', $pb.PbFieldType.O3, protoName: 'senderUid')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderName', protoName: 'senderName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'content')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'replayTargetName', protoName: 'replayTargetName')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'likeInfo', protoName: 'likeInfo')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createAt', protoName: 'createAt')
    ..hasRequiredFields = false
  ;

  Comment._() : super();
  factory Comment({
    $core.int? id,
    $core.int? dynamicId,
    $core.int? senderUid,
    $core.String? senderName,
    $core.String? content,
    $core.String? replayTargetName,
    $core.String? likeInfo,
    $fixnum.Int64? createAt,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (dynamicId != null) {
      _result.dynamicId = dynamicId;
    }
    if (senderUid != null) {
      _result.senderUid = senderUid;
    }
    if (senderName != null) {
      _result.senderName = senderName;
    }
    if (content != null) {
      _result.content = content;
    }
    if (replayTargetName != null) {
      _result.replayTargetName = replayTargetName;
    }
    if (likeInfo != null) {
      _result.likeInfo = likeInfo;
    }
    if (createAt != null) {
      _result.createAt = createAt;
    }
    return _result;
  }
  factory Comment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Comment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Comment clone() => Comment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Comment copyWith(void Function(Comment) updates) => super.copyWith((message) => updates(message as Comment)) as Comment; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Comment create() => Comment._();
  Comment createEmptyInstance() => create();
  static $pb.PbList<Comment> createRepeated() => $pb.PbList<Comment>();
  @$core.pragma('dart2js:noInline')
  static Comment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Comment>(create);
  static Comment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get dynamicId => $_getIZ(1);
  @$pb.TagNumber(2)
  set dynamicId($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDynamicId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDynamicId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get senderUid => $_getIZ(2);
  @$pb.TagNumber(3)
  set senderUid($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSenderUid() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderUid() => clearField(3);

  @$pb.TagNumber(5)
  $core.String get senderName => $_getSZ(3);
  @$pb.TagNumber(5)
  set senderName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasSenderName() => $_has(3);
  @$pb.TagNumber(5)
  void clearSenderName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(4);
  @$pb.TagNumber(6)
  set content($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(4);
  @$pb.TagNumber(6)
  void clearContent() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get replayTargetName => $_getSZ(5);
  @$pb.TagNumber(7)
  set replayTargetName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(7)
  $core.bool hasReplayTargetName() => $_has(5);
  @$pb.TagNumber(7)
  void clearReplayTargetName() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get likeInfo => $_getSZ(6);
  @$pb.TagNumber(8)
  set likeInfo($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(8)
  $core.bool hasLikeInfo() => $_has(6);
  @$pb.TagNumber(8)
  void clearLikeInfo() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get createAt => $_getI64(7);
  @$pb.TagNumber(9)
  set createAt($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreateAt() => $_has(7);
  @$pb.TagNumber(9)
  void clearCreateAt() => clearField(9);
}

class SubmitCommentResp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SubmitCommentResp', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..aOM<Comment>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', subBuilder: Comment.create)
    ..hasRequiredFields = false
  ;

  SubmitCommentResp._() : super();
  factory SubmitCommentResp({
    $core.int? code,
    $core.String? message,
    Comment? data,
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
    return _result;
  }
  factory SubmitCommentResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitCommentResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitCommentResp clone() => SubmitCommentResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitCommentResp copyWith(void Function(SubmitCommentResp) updates) => super.copyWith((message) => updates(message as SubmitCommentResp)) as SubmitCommentResp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SubmitCommentResp create() => SubmitCommentResp._();
  SubmitCommentResp createEmptyInstance() => create();
  static $pb.PbList<SubmitCommentResp> createRepeated() => $pb.PbList<SubmitCommentResp>();
  @$core.pragma('dart2js:noInline')
  static SubmitCommentResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitCommentResp>(create);
  static SubmitCommentResp? _defaultInstance;

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
  Comment get data => $_getN(2);
  @$pb.TagNumber(3)
  set data(Comment v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
  @$pb.TagNumber(3)
  Comment ensureData() => $_ensure(2);
}

class CommentListResp extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CommentListResp', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'user'), createEmptyInstance: create)
    ..a<$core.int>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'code', $pb.PbFieldType.O3)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..pc<Comment>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.PM, subBuilder: Comment.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hasMore', protoName: 'hasMore')
    ..hasRequiredFields = false
  ;

  CommentListResp._() : super();
  factory CommentListResp({
    $core.int? code,
    $core.String? message,
    $core.Iterable<Comment>? data,
    $core.bool? hasMore,
  }) {
    final _result = create();
    if (code != null) {
      _result.code = code;
    }
    if (message != null) {
      _result.message = message;
    }
    if (data != null) {
      _result.data.addAll(data);
    }
    if (hasMore != null) {
      _result.hasMore = hasMore;
    }
    return _result;
  }
  factory CommentListResp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommentListResp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommentListResp clone() => CommentListResp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommentListResp copyWith(void Function(CommentListResp) updates) => super.copyWith((message) => updates(message as CommentListResp)) as CommentListResp; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CommentListResp create() => CommentListResp._();
  CommentListResp createEmptyInstance() => create();
  static $pb.PbList<CommentListResp> createRepeated() => $pb.PbList<CommentListResp>();
  @$core.pragma('dart2js:noInline')
  static CommentListResp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommentListResp>(create);
  static CommentListResp? _defaultInstance;

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
  $core.List<Comment> get data => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get hasMore => $_getBF(3);
  @$pb.TagNumber(4)
  set hasMore($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHasMore() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasMore() => clearField(4);
}

