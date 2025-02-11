import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../localization/app_strings.dart';

class AppValidator {
  static bool isEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  static bool isEmail(String em) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(em);
  }

  static bool isMobile(String mobile) {
    String pattern = r'^(05)(5|0|3|6|4|9|1|8|7)([0-9]{7})$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(mobile);
  }

  static bool isPassword(String value) {
    if (value.length < 8) {
      return true;
    }
    return false;
  }

  static String? emptyValidator(String? value, String errorString) {
    if (value?.isEmpty ?? true) {
      return errorString;
    } else {
      return null;
    }
  }
}
