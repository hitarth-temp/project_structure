import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/enum/language_code.dart';
import 'app_strings.dart';

class AppTranslation extends Translations {
  static Locale get locale => Get.deviceLocale!;

  static Locale fallbackLocale = Locale(LanguageCode.en.name);

  static Map<String, Map<String, String>> translations = {
    for (var lang in LanguageCode.values)
      lang.name: StringConstants.translations[lang]!,
  };

  @override
  Map<String, Map<String, String>> get keys => AppTranslation.translations;
}
