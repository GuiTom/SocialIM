///
//  Generated code. Do not modify.
//  source: discover.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use dynamicDescriptor instead')
const Dynamic$json = const {
  '1': 'Dynamic',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'uid', '3': 2, '4': 1, '5': 5, '10': 'uid'},
    const {'1': 'nickName', '3': 3, '4': 1, '5': 9, '10': 'nickName'},
    const {'1': 'content', '3': 4, '4': 1, '5': 9, '10': 'content'},
    const {'1': 'attachment', '3': 5, '4': 1, '5': 9, '10': 'attachment'},
    const {'1': 'likeInfo', '3': 6, '4': 1, '5': 9, '10': 'likeInfo'},
    const {'1': 'firstCommentInfo', '3': 7, '4': 1, '5': 9, '10': 'firstCommentInfo'},
    const {'1': 'commentCount', '3': 8, '4': 1, '5': 5, '10': 'commentCount'},
    const {'1': 'createAt', '3': 9, '4': 1, '5': 3, '10': 'createAt'},
  ],
};

/// Descriptor for `Dynamic`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dynamicDescriptor = $convert.base64Decode('CgdEeW5hbWljEg4KAmlkGAEgASgDUgJpZBIQCgN1aWQYAiABKAVSA3VpZBIaCghuaWNrTmFtZRgDIAEoCVIIbmlja05hbWUSGAoHY29udGVudBgEIAEoCVIHY29udGVudBIeCgphdHRhY2htZW50GAUgASgJUgphdHRhY2htZW50EhoKCGxpa2VJbmZvGAYgASgJUghsaWtlSW5mbxIqChBmaXJzdENvbW1lbnRJbmZvGAcgASgJUhBmaXJzdENvbW1lbnRJbmZvEiIKDGNvbW1lbnRDb3VudBgIIAEoBVIMY29tbWVudENvdW50EhoKCGNyZWF0ZUF0GAkgASgDUghjcmVhdGVBdA==');
@$core.Deprecated('Use dynamicListRespDescriptor instead')
const DynamicListResp$json = const {
  '1': 'DynamicListResp',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'data', '3': 3, '4': 3, '5': 11, '6': '.user.Dynamic', '10': 'data'},
    const {'1': 'hasMore', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `DynamicListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dynamicListRespDescriptor = $convert.base64Decode('Cg9EeW5hbWljTGlzdFJlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdlEiEKBGRhdGEYAyADKAsyDS51c2VyLkR5bmFtaWNSBGRhdGESGAoHaGFzTW9yZRgEIAEoCFIHaGFzTW9yZQ==');
@$core.Deprecated('Use commentDescriptor instead')
const Comment$json = const {
  '1': 'Comment',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'dynamicId', '3': 2, '4': 1, '5': 5, '10': 'dynamicId'},
    const {'1': 'senderUid', '3': 3, '4': 1, '5': 5, '10': 'senderUid'},
    const {'1': 'senderName', '3': 5, '4': 1, '5': 9, '10': 'senderName'},
    const {'1': 'content', '3': 6, '4': 1, '5': 9, '10': 'content'},
    const {'1': 'replayTargetName', '3': 7, '4': 1, '5': 9, '10': 'replayTargetName'},
    const {'1': 'likeInfo', '3': 8, '4': 1, '5': 9, '10': 'likeInfo'},
    const {'1': 'createAt', '3': 9, '4': 1, '5': 3, '10': 'createAt'},
  ],
};

/// Descriptor for `Comment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentDescriptor = $convert.base64Decode('CgdDb21tZW50Eg4KAmlkGAEgASgFUgJpZBIcCglkeW5hbWljSWQYAiABKAVSCWR5bmFtaWNJZBIcCglzZW5kZXJVaWQYAyABKAVSCXNlbmRlclVpZBIeCgpzZW5kZXJOYW1lGAUgASgJUgpzZW5kZXJOYW1lEhgKB2NvbnRlbnQYBiABKAlSB2NvbnRlbnQSKgoQcmVwbGF5VGFyZ2V0TmFtZRgHIAEoCVIQcmVwbGF5VGFyZ2V0TmFtZRIaCghsaWtlSW5mbxgIIAEoCVIIbGlrZUluZm8SGgoIY3JlYXRlQXQYCSABKANSCGNyZWF0ZUF0');
@$core.Deprecated('Use submitCommentRespDescriptor instead')
const SubmitCommentResp$json = const {
  '1': 'SubmitCommentResp',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'data', '3': 3, '4': 1, '5': 11, '6': '.user.Comment', '10': 'data'},
  ],
};

/// Descriptor for `SubmitCommentResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitCommentRespDescriptor = $convert.base64Decode('ChFTdWJtaXRDb21tZW50UmVzcBISCgRjb2RlGAEgASgFUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USIQoEZGF0YRgDIAEoCzINLnVzZXIuQ29tbWVudFIEZGF0YQ==');
@$core.Deprecated('Use commentListRespDescriptor instead')
const CommentListResp$json = const {
  '1': 'CommentListResp',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'data', '3': 3, '4': 3, '5': 11, '6': '.user.Comment', '10': 'data'},
    const {'1': 'hasMore', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `CommentListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commentListRespDescriptor = $convert.base64Decode('Cg9Db21tZW50TGlzdFJlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZXNzYWdlEiEKBGRhdGEYAyADKAsyDS51c2VyLkNvbW1lbnRSBGRhdGESGAoHaGFzTW9yZRgEIAEoCFIHaGFzTW9yZQ==');
