import 'package:flutter/foundation.dart';

/// Application logger for debug and error logging
class AppLogger {
  AppLogger._();

  static const String _tag = 'VaultKey';

  /// Log debug message
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] DEBUG: $message');
    }
  }

  /// Log info message
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] INFO: $message');
    }
  }

  /// Log warning message
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] WARNING: $message');
    }
  }

  /// Log error message with optional stack trace
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] ERROR: $message');
      if (error != null) {
        debugPrint('[${tag ?? _tag}] Exception: $error');
      }
      if (stackTrace != null) {
        debugPrint('[${tag ?? _tag}] StackTrace: $stackTrace');
      }
    }
  }

  /// Log method entry for tracing
  static void trace(String methodName, {String? tag}) {
    if (kDebugMode) {
      debugPrint('[${tag ?? _tag}] TRACE: Entering $methodName');
    }
  }
}
