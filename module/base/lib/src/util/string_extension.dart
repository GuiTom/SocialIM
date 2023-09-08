import 'package:flutter/painting.dart';
import 'dart:math';


/// String的扩展，String是可空的
extension StringExtension on String? {
  /// 是否为空
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// 是否不为空
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// 是否为空白
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// 是否不为空白
  bool get isNotNullOrBlank => !isNullOrBlank;


  /// 安全截取字符串，支持utf-16(特别是emoji被截断的场景)
  String safeSubstring(int start, [int? end]) {
    if (this == null) return '';

    List<int> runeList = this!.runes.toList();

    if (end == null || end < 0 || end > runeList.length) {
      end = runeList.length;
    }
    return String.fromCharCodes(runeList.sublist(start, end));
  }
  String generateRandomString(int length) {
    // Define the possible characters
    const chars = '0123456789';

    // Create a random number generator
    var rng = Random();

    // Create an empty string
    var result = '';

    // Loop 8 times
    for (var i = 0; i < length; i++) {
      // Pick a random character from the chars string
      var index = rng.nextInt(chars.length);
      var char = chars[index];

      // Append the character to the result string
      result += char;
    }

    // Return the result string
    return result;
  }
  String toCharacterBreakStr() {
    if (this == null) return '';
    if (this!.isEmpty) {
      return this!;
    }
    String breakWord = '';
    for (var element in this!.runes) {
      breakWord += String.fromCharCode(element);
      breakWord += '\u200B';
    }
    return breakWord;
  }

  int get charLength => this?.runes.length ?? 0;

  /// 当前字符在Text里渲染时的size
  Size textSize(
    TextStyle? style, {
    int maxLines = 1,
    String? ellipsis,
    TextAlign textAlign = TextAlign.start,
    TextDirection textDirection = TextDirection.ltr,
    double textScaleFactor = 1.0,
  }) {
    TextPainter painter = TextPainter(
      text: TextSpan(text: this, style: style),
      textAlign: textAlign,
      textDirection: textDirection,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      ellipsis: ellipsis,
    );
    painter.layout();
    return painter.size;
  }
}
