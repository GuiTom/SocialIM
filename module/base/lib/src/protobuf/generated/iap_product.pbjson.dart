//
//  Generated code. Do not modify.
//  source: iap_product.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use iapProductDescriptor instead')
const IapProduct$json = {
  '1': 'IapProduct',
  '2': [
    {'1': 'productId', '3': 1, '4': 1, '5': 9, '10': 'productId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `IapProduct`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iapProductDescriptor = $convert.base64Decode(
    'CgpJYXBQcm9kdWN0EhwKCXByb2R1Y3RJZBgBIAEoCVIJcHJvZHVjdElkEhIKBG5hbWUYAiABKA'
    'lSBG5hbWU=');

@$core.Deprecated('Use iapProductListRespDescriptor instead')
const IapProductListResp$json = {
  '1': 'IapProductListResp',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'data', '3': 3, '4': 3, '5': 11, '6': '.user.IapProduct', '10': 'data'},
    {'1': 'hasMore', '3': 4, '4': 1, '5': 8, '10': 'hasMore'},
  ],
};

/// Descriptor for `IapProductListResp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iapProductListRespDescriptor = $convert.base64Decode(
    'ChJJYXBQcm9kdWN0TGlzdFJlc3ASEgoEY29kZRgBIAEoBVIEY29kZRIYCgdtZXNzYWdlGAIgAS'
    'gJUgdtZXNzYWdlEiQKBGRhdGEYAyADKAsyEC51c2VyLklhcFByb2R1Y3RSBGRhdGESGAoHaGFz'
    'TW9yZRgEIAEoCFIHaGFzTW9yZQ==');

