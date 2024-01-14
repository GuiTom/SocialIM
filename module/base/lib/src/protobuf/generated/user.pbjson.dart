//
//  Generated code. Do not modify.
//  source: user.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'sex', '3': 3, '4': 1, '5': 5, '10': 'sex'},
    {'1': 'height', '3': 4, '4': 1, '5': 5, '10': 'height'},
    {'1': 'email', '3': 5, '4': 1, '5': 9, '10': 'email'},
    {'1': 'phone', '3': 6, '4': 1, '5': 9, '10': 'phone'},
    {'1': 'headId', '3': 8, '4': 1, '5': 9, '10': 'headId'},
    {'1': 'level', '3': 9, '4': 1, '5': 5, '10': 'level'},
    {'1': 'createAt', '3': 10, '4': 1, '5': 3, '10': 'createAt'},
    {'1': 'bornAt', '3': 11, '4': 1, '5': 3, '10': 'bornAt'},
    {'1': 'signature', '3': 12, '4': 1, '5': 9, '10': 'signature'},
    {'1': 'cityCode', '3': 13, '4': 1, '5': 9, '10': 'cityCode'},
    {'1': 'provinceCode', '3': 14, '4': 1, '5': 9, '10': 'provinceCode'},
    {'1': 'countryCode', '3': 15, '4': 1, '5': 9, '10': 'countryCode'},
    {'1': 'cityName', '3': 16, '4': 1, '5': 9, '10': 'cityName'},
    {'1': 'provinceName', '3': 17, '4': 1, '5': 9, '10': 'provinceName'},
    {'1': 'countryName', '3': 18, '4': 1, '5': 9, '10': 'countryName'},
    {'1': 'setting', '3': 19, '4': 1, '5': 9, '10': 'setting'},
    {'1': 'passwordSetted', '3': 20, '4': 1, '5': 8, '10': 'passwordSetted'},
    {'1': 'toUnRegister', '3': 21, '4': 1, '5': 8, '10': 'toUnRegister'},
    {'1': 'friendUidListStr', '3': 22, '4': 1, '5': 9, '10': 'friendUidListStr'},
    {'1': 'fansUidListStr', '3': 23, '4': 1, '5': 9, '10': 'fansUidListStr'},
    {'1': 'focusUidListStr', '3': 24, '4': 1, '5': 9, '10': 'focusUidListStr'},
    {'1': 'blackUidListStr', '3': 25, '4': 1, '5': 9, '10': 'blackUidListStr'},
    {'1': 'blackDynIdListStr', '3': 26, '4': 1, '5': 9, '10': 'blackDynIdListStr'},
    {'1': 'worksCount', '3': 27, '4': 1, '5': 5, '10': 'worksCount'},
    {'1': 'monthlyVipExpireAt', '3': 28, '4': 1, '5': 3, '10': 'monthlyVipExpireAt'},
    {'1': 'yearlyVipExpireAt', '3': 29, '4': 1, '5': 3, '10': 'yearlyVipExpireAt'},
    {'1': 'hasCrown', '3': 30, '4': 1, '5': 8, '10': 'hasCrown'},
    {'1': 'coin', '3': 31, '4': 1, '5': 5, '10': 'coin'},
    {'1': 'forbidden', '3': 32, '4': 1, '5': 5, '10': 'forbidden'},
    {'1': 'covers', '3': 34, '4': 1, '5': 9, '10': 'covers'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgDUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEhAKA3NleBgDIAEoBV'
    'IDc2V4EhYKBmhlaWdodBgEIAEoBVIGaGVpZ2h0EhQKBWVtYWlsGAUgASgJUgVlbWFpbBIUCgVw'
    'aG9uZRgGIAEoCVIFcGhvbmUSFgoGaGVhZElkGAggASgJUgZoZWFkSWQSFAoFbGV2ZWwYCSABKA'
    'VSBWxldmVsEhoKCGNyZWF0ZUF0GAogASgDUghjcmVhdGVBdBIWCgZib3JuQXQYCyABKANSBmJv'
    'cm5BdBIcCglzaWduYXR1cmUYDCABKAlSCXNpZ25hdHVyZRIaCghjaXR5Q29kZRgNIAEoCVIIY2'
    'l0eUNvZGUSIgoMcHJvdmluY2VDb2RlGA4gASgJUgxwcm92aW5jZUNvZGUSIAoLY291bnRyeUNv'
    'ZGUYDyABKAlSC2NvdW50cnlDb2RlEhoKCGNpdHlOYW1lGBAgASgJUghjaXR5TmFtZRIiCgxwcm'
    '92aW5jZU5hbWUYESABKAlSDHByb3ZpbmNlTmFtZRIgCgtjb3VudHJ5TmFtZRgSIAEoCVILY291'
    'bnRyeU5hbWUSGAoHc2V0dGluZxgTIAEoCVIHc2V0dGluZxImCg5wYXNzd29yZFNldHRlZBgUIA'
    'EoCFIOcGFzc3dvcmRTZXR0ZWQSIgoMdG9VblJlZ2lzdGVyGBUgASgIUgx0b1VuUmVnaXN0ZXIS'
    'KgoQZnJpZW5kVWlkTGlzdFN0chgWIAEoCVIQZnJpZW5kVWlkTGlzdFN0chImCg5mYW5zVWlkTG'
    'lzdFN0chgXIAEoCVIOZmFuc1VpZExpc3RTdHISKAoPZm9jdXNVaWRMaXN0U3RyGBggASgJUg9m'
    'b2N1c1VpZExpc3RTdHISKAoPYmxhY2tVaWRMaXN0U3RyGBkgASgJUg9ibGFja1VpZExpc3RTdH'
    'ISLAoRYmxhY2tEeW5JZExpc3RTdHIYGiABKAlSEWJsYWNrRHluSWRMaXN0U3RyEh4KCndvcmtz'
    'Q291bnQYGyABKAVSCndvcmtzQ291bnQSLgoSbW9udGhseVZpcEV4cGlyZUF0GBwgASgDUhJtb2'
    '50aGx5VmlwRXhwaXJlQXQSLAoReWVhcmx5VmlwRXhwaXJlQXQYHSABKANSEXllYXJseVZpcEV4'
    'cGlyZUF0EhoKCGhhc0Nyb3duGB4gASgIUghoYXNDcm93bhISCgRjb2luGB8gASgFUgRjb2luEh'
    'wKCWZvcmJpZGRlbhggIAEoBVIJZm9yYmlkZGVuEhYKBmNvdmVycxgiIAEoCVIGY292ZXJz');

@$core.Deprecated('Use userListRespDescriptor instead')
const UserListResp$json = {
  '1': 'UserListResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'data', '3': 3, '4': 3, '5': 11, '6': '.user.User', '10': 'data'},
    {'1': 'hasMore', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `UserListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userListRespDescriptor = $convert.base64Decode(
    'CgxVc2VyTGlzdFJlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdlEh4KBGRhdGEYAyADKAsyCi51c2VyLlVzZXJSBGRhdGESGAoHaGFzTW9yZRgEIAEoCFIH'
    'aGFzTW9yZQ==');

@$core.Deprecated('Use userInfoRespDescriptor instead')
const UserInfoResp$json = {
  '1': 'UserInfoResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'data', '3': 3, '4': 1, '5': 11, '6': '.user.User', '10': 'data'},
  ],
};

/// Descriptor for `UserInfoResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userInfoRespDescriptor = $convert.base64Decode(
    'CgxVc2VySW5mb1Jlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdlEh4KBGRhdGEYAyABKAsyCi51c2VyLlVzZXJSBGRhdGE=');

@$core.Deprecated('Use generateNameRespDescriptor instead')
const GenerateNameResp$json = {
  '1': 'GenerateNameResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'data', '3': 3, '4': 1, '5': 9, '10': 'data'},
  ],
};

/// Descriptor for `GenerateNameResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateNameRespDescriptor = $convert.base64Decode(
    'ChBHZW5lcmF0ZU5hbWVSZXNwEhIKBGNvZGUYASABKAVSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCV'
    'IHbWVzc2FnZRISCgRkYXRhGAMgASgJUgRkYXRh');

@$core.Deprecated('Use friendListRespDescriptor instead')
const FriendListResp$json = {
  '1': 'FriendListResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'list', '3': 3, '4': 3, '5': 11, '6': '.user.User', '10': 'list'},
  ],
};

/// Descriptor for `FriendListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List friendListRespDescriptor = $convert.base64Decode(
    'Cg5GcmllbmRMaXN0UmVzcBISCgRjb2RlGAEgASgFUgRjb2RlEhgKB21lc3NhZ2UYAiABKAlSB2'
    '1lc3NhZ2USHgoEbGlzdBgDIAMoCzIKLnVzZXIuVXNlclIEbGlzdA==');

@$core.Deprecated('Use focusListRespDescriptor instead')
const FocusListResp$json = {
  '1': 'FocusListResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'list', '3': 3, '4': 3, '5': 11, '6': '.user.User', '10': 'list'},
  ],
};

/// Descriptor for `FocusListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List focusListRespDescriptor = $convert.base64Decode(
    'Cg1Gb2N1c0xpc3RSZXNwEhIKBGNvZGUYASABKAVSBGNvZGUSGAoHbWVzc2FnZRgCIAEoCVIHbW'
    'Vzc2FnZRIeCgRsaXN0GAMgAygLMgoudXNlci5Vc2VyUgRsaXN0');

@$core.Deprecated('Use fansListRespDescriptor instead')
const FansListResp$json = {
  '1': 'FansListResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'list', '3': 3, '4': 3, '5': 11, '6': '.user.User', '10': 'list'},
  ],
};

/// Descriptor for `FansListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fansListRespDescriptor = $convert.base64Decode(
    'CgxGYW5zTGlzdFJlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdlEh4KBGxpc3QYAyADKAsyCi51c2VyLlVzZXJSBGxpc3Q=');

@$core.Deprecated('Use userBlackListRespDescriptor instead')
const UserBlackListResp$json = {
  '1': 'UserBlackListResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'list', '3': 3, '4': 3, '5': 11, '6': '.user.User', '10': 'list'},
  ],
};

/// Descriptor for `UserBlackListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userBlackListRespDescriptor = $convert.base64Decode(
    'ChFVc2VyQmxhY2tMaXN0UmVzcBISCgRjb2RlGAEgASgFUgRjb2RlEhgKB21lc3NhZ2UYAiABKA'
    'lSB21lc3NhZ2USHgoEbGlzdBgDIAMoCzIKLnVzZXIuVXNlclIEbGlzdA==');

