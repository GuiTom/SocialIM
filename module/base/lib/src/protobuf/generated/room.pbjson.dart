///
//  Generated code. Do not modify.
//  source: room.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use rtcTokenRespDescriptor instead')
const RtcTokenResp$json = const {
  '1': 'RtcTokenResp',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'channelId', '3': 3, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RtcTokenResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rtcTokenRespDescriptor = $convert.base64Decode('CgxSdGNUb2tlblJlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIUCgV0b2tlbhgCIAEoCVIFdG9rZW4SHAoJY2hhbm5lbElkGAMgASgJUgljaGFubmVsSWQSGAoHbWVzc2FnZRgEIAEoCVIHbWVzc2FnZQ==');
@$core.Deprecated('Use roomInfoDescriptor instead')
const RoomInfo$json = const {
  '1': 'RoomInfo',
  '2': const [
    const {'1': 'roomId', '3': 1, '4': 1, '5': 5, '10': 'roomId'},
    const {'1': 'creatorUid', '3': 2, '4': 1, '5': 3, '10': 'creatorUid'},
    const {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'channelId', '3': 4, '4': 1, '5': 9, '10': 'channelId'},
    const {'1': 'Users', '3': 5, '4': 1, '5': 9, '10': 'Users'},
  ],
};

/// Descriptor for `RoomInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomInfoDescriptor = $convert.base64Decode('CghSb29tSW5mbxIWCgZyb29tSWQYASABKAVSBnJvb21JZBIeCgpjcmVhdG9yVWlkGAIgASgDUgpjcmVhdG9yVWlkEhIKBG5hbWUYAyABKAlSBG5hbWUSHAoJY2hhbm5lbElkGAQgASgJUgljaGFubmVsSWQSFAoFVXNlcnMYBSABKAlSBVVzZXJz');
@$core.Deprecated('Use roomInfoRespDescriptor instead')
const RoomInfoResp$json = const {
  '1': 'RoomInfoResp',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'data', '3': 2, '4': 1, '5': 11, '6': '.config.RoomInfo', '10': 'data'},
    const {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RoomInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roomInfoRespDescriptor = $convert.base64Decode('CgxSb29tSW5mb1Jlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIkCgRkYXRhGAIgASgLMhAuY29uZmlnLlJvb21JbmZvUgRkYXRhEhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2U=');
@$core.Deprecated('Use liveRoomListRespDescriptor instead')
const LiveRoomListResp$json = const {
  '1': 'LiveRoomListResp',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'data', '3': 2, '4': 3, '5': 11, '6': '.config.RoomInfo', '10': 'data'},
    const {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `LiveRoomListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List liveRoomListRespDescriptor = $convert.base64Decode('ChBMaXZlUm9vbUxpc3RSZXNwEhIKBGNvZGUYASABKAVSBGNvZGUSJAoEZGF0YRgCIAMoCzIQLmNvbmZpZy5Sb29tSW5mb1IEZGF0YRIYCgdtZXNzYWdlGAMgASgJUgdtZXNzYWdl');
