import 'dart:async';

import 'package:flutter/services.dart';

import '../constants/app_constants.dart';

/// Clipboard helper with auto-clear functionality for security
class ClipboardHelper {
  ClipboardHelper._();

  static Timer? _clearTimer;

  /// Copy text to clipboard and auto-clear after duration
  static Future<void> copyWithAutoClear(
    String text, {
    Duration? clearAfter,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));

    // Cancel any existing timer
    _clearTimer?.cancel();

    // Set new timer to clear clipboard
    _clearTimer = Timer(
      clearAfter ?? AppConstants.clipboardClearDuration,
      () async {
        await Clipboard.setData(const ClipboardData(text: ''));
      },
    );
  }

  /// Copy text to clipboard without auto-clear
  static Future<void> copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Clear clipboard immediately
  static Future<void> clear() async {
    _clearTimer?.cancel();
    await Clipboard.setData(const ClipboardData(text: ''));
  }

  /// Get clipboard content
  static Future<String?> paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Cancel auto-clear timer
  static void cancelAutoClear() {
    _clearTimer?.cancel();
    _clearTimer = null;
  }
}
