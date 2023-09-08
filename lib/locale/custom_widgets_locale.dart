// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Localized values for widgets.
///
/// Currently this class just maps [locale] to [textDirection]. All locales
/// are [TextDirection.ltr] except for locales with the following
/// [Locale.languageCode] values, which are [TextDirection.rtl]:
///
///   * ar - Arabic
///   * fa - Farsi
///   * he - Hebrew
///   * ps - Pashto
///   * sd - Sindhi
///   * ur - Urdu
class CCGlobalWidgetsLocalizations implements WidgetsLocalizations {
  /// Construct an object that defines the localized values for the widgets
  /// library for the given `locale`.
  ///
  /// [LocalizationsDelegate] implementations typically call the static [load]
  /// function, rather than constructing this class directly.
  CCGlobalWidgetsLocalizations(this.locale) {
    final String language = locale.languageCode.toLowerCase();
    _textDirection = _rtlLanguages.contains(language) ? TextDirection.rtl : TextDirection.ltr;
  }

  // See http://en.wikipedia.org/wiki/Right-to-left
  static const List<String> _rtlLanguages = <String>[
    'ar', // Arabic
    'fa', // Farsi
    'he', // Hebrew
    'ps', // Pashto
    'ur', // Urdu
  ];

  /// The locale for which the values of this class's localized resources
  /// have been translated.
  final Locale locale;

  @override
  TextDirection get textDirection => _textDirection;
  late TextDirection _textDirection;

  /// Creates an object that provides localized resource values for the
  /// lowest levels of the Flutter framework.
  ///
  /// This method is typically used to create a [LocalizationsDelegate].
  /// The [WidgetsApp] does so by default.
  static Future<WidgetsLocalizations> load(Locale locale) {
    return SynchronousFuture<WidgetsLocalizations>(CCGlobalWidgetsLocalizations(locale));
  }

  /// A [LocalizationsDelegate] that uses [CCGlobalWidgetsLocalizations.load]
  /// to create an instance of this class.
  ///
  /// [WidgetsApp] automatically adds this value to [WidgetApp.localizationsDelegates].
  static const LocalizationsDelegate<WidgetsLocalizations> delegate = WidgetsLocalizationsDelegate(null);

  static LocalizationsDelegate<WidgetsLocalizations> overridden(Locale locale){
    return  WidgetsLocalizationsDelegate(locale);
  }
}

class WidgetsLocalizationsDelegate extends LocalizationsDelegate<WidgetsLocalizations> {
  final Locale? overriddenLocale;
  const WidgetsLocalizationsDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WidgetsLocalizations> load(Locale locale) => CCGlobalWidgetsLocalizations.load(overriddenLocale??locale);

  @override
  bool shouldReload(WidgetsLocalizationsDelegate old) => true;

  @override
  String toString() => 'BBGlobalWidgetsLocalizations.delegate(all locales)';
}
