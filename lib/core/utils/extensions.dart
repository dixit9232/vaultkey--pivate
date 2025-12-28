import 'package:flutter/material.dart';

/// Extension methods for BuildContext
extension ContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get screen width
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Get screen height
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Get padding (safe area)
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  /// Get view insets (keyboard)
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Check if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;

  /// Check if dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Check if mobile (< 600dp)
  bool get isMobile => screenWidth < 600;

  /// Check if tablet (600dp - 1200dp)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Check if desktop (>= 1200dp)
  bool get isDesktop => screenWidth >= 1200;

  /// Get device pixel ratio
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  /// Show snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message), duration: duration, action: action),
    );
  }

  /// Show error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: colorScheme.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show success snackbar
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// Extension methods for String
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Check if string is valid email
  bool get isValidEmail {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(this);
  }

  /// Remove all whitespace
  String get removeWhitespace => replaceAll(RegExp(r'\s+'), '');

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }
}

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Format as readable date
  String get formattedDate {
    return '$day/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Format as readable time
  String get formattedTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  /// Format as readable date and time
  String get formattedDateTime => '$formattedDate $formattedTime';

  /// Check if same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Check if today
  bool get isToday => isSameDay(DateTime.now());

  /// Check if yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(yesterday);
  }
}

/// Extension methods for Duration
extension DurationExtensions on Duration {
  /// Format as mm:ss
  String get formatted {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Format as countdown timer
  String get countdown {
    final seconds = inSeconds.remainder(60);
    return seconds.toString().padLeft(2, '0');
  }
}
