import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

var logger = MyLogger();

class MyLogger {
  /// Log a message at level verbose.
  void v(dynamic message) {
    _log(" VERBOSE: $message");
  }

  /// Log a message at level debug.
  void d(dynamic message) {
    _log(" DEBUG: $message");
  }

  /// Log a message at level info.
  void i(dynamic message) {
    _log(" INFO: $message");
  }

  /// Log a message at level warning.
  void w(dynamic message) {
    _log(" WARNING: $message");
  }

  /// Log a message at level error.
  void e(dynamic message, {StackTrace? stackTrace}) {
    _log(" ERROR: $message", stackTrace: stackTrace);
  }

  void _log(dynamic message, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      developer.log(
        "$message , currentRoute: ${Get.currentRoute}",
        stackTrace: stackTrace,
        time: DateTime.now(),
      );
    }
  }

  void log(dynamic message, {StackTrace? stackTrace}) {
    _log(message, stackTrace: stackTrace);
  }
}
