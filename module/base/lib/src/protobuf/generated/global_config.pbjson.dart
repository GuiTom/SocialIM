///
//  Generated code. Do not modify.
//  source: global_config.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use gameInfoDescriptor instead')
const GameInfo$json = const {
  '1': 'GameInfo',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'iconUrl', '3': 3, '4': 1, '5': 9, '10': 'iconUrl'},
    const {'1': 'url', '3': 4, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `GameInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gameInfoDescriptor = $convert.base64Decode('CghHYW1lSW5mbxIOCgJpZBgBIAEoBVICaWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIYCgdpY29uVXJsGAMgASgJUgdpY29uVXJsEhAKA3VybBgEIAEoCVIDdXJs');
@$core.Deprecated('Use globalConfigDescriptor instead')
const GlobalConfig$json = const {
  '1': 'GlobalConfig',
  '2': const [
    const {'1': 'latestVersionCodeAndroid', '3': 1, '4': 1, '5': 5, '10': 'latestVersionCodeAndroid'},
    const {'1': 'latestVersionCodeIOS', '3': 2, '4': 1, '5': 5, '10': 'latestVersionCodeIOS'},
    const {'1': 'downloadPageAndroid', '3': 3, '4': 1, '5': 9, '10': 'downloadPageAndroid'},
    const {'1': 'downloadPageIos', '3': 4, '4': 1, '5': 9, '10': 'downloadPageIos'},
    const {'1': 'customerServicePhone', '3': 5, '4': 1, '5': 9, '10': 'customerServicePhone'},
    const {'1': 'customerServiceWechat', '3': 6, '4': 1, '5': 9, '10': 'customerServiceWechat'},
  ],
};

/// Descriptor for `GlobalConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List globalConfigDescriptor = $convert.base64Decode('CgxHbG9iYWxDb25maWcSOgoYbGF0ZXN0VmVyc2lvbkNvZGVBbmRyb2lkGAEgASgFUhhsYXRlc3RWZXJzaW9uQ29kZUFuZHJvaWQSMgoUbGF0ZXN0VmVyc2lvbkNvZGVJT1MYAiABKAVSFGxhdGVzdFZlcnNpb25Db2RlSU9TEjAKE2Rvd25sb2FkUGFnZUFuZHJvaWQYAyABKAlSE2Rvd25sb2FkUGFnZUFuZHJvaWQSKAoPZG93bmxvYWRQYWdlSW9zGAQgASgJUg9kb3dubG9hZFBhZ2VJb3MSMgoUY3VzdG9tZXJTZXJ2aWNlUGhvbmUYBSABKAlSFGN1c3RvbWVyU2VydmljZVBob25lEjQKFWN1c3RvbWVyU2VydmljZVdlY2hhdBgGIAEoCVIVY3VzdG9tZXJTZXJ2aWNlV2VjaGF0');
@$core.Deprecated('Use globalConfigInfoRespDescriptor instead')
const GlobalConfigInfoResp$json = const {
  '1': 'GlobalConfigInfoResp',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 3, '10': 'code'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'data', '3': 3, '4': 1, '5': 11, '6': '.config.GlobalConfig', '10': 'data'},
    const {'1': 'games', '3': 4, '4': 3, '5': 11, '6': '.config.GameInfo', '10': 'games'},
  ],
};

/// Descriptor for `GlobalConfigInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List globalConfigInfoRespDescriptor = $convert.base64Decode('ChRHbG9iYWxDb25maWdJbmZvUmVzcBISCgRjb2RlGAEgASgDUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB21lc3NhZ2USKAoEZGF0YRgDIAEoCzIULmNvbmZpZy5HbG9iYWxDb25maWdSBGRhdGESJgoFZ2FtZXMYBCADKAsyEC5jb25maWcuR2FtZUluZm9SBWdhbWVz');
