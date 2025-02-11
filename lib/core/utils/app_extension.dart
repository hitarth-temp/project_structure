import 'package:flutter/material.dart';

extension ContextUtil on BuildContext {
  /// hide keyboard
  void hideKeyboard() {
    if (mounted) {
      FocusScope.of(this).requestFocus(FocusNode());
    }
  }
}

extension StringUtils on String? {
  bool isNotNullOrEmpty() {
    String? value = this;
    if (value != null && value.isNotEmpty) {
      return true;
    }
    return false;
  }
}
