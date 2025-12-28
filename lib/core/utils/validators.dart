/// Input validators for form fields
class Validators {
  Validators._();

  /// Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Password validation - minimum 8 characters
  static const int _minPasswordLength = 8;

  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates password - minimum 8 characters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < _minPasswordLength) {
      return 'Password must be at least $_minPasswordLength characters';
    }
    return null;
  }

  /// Validates password with strength requirements
  static String? validateStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < _minPasswordLength) {
      return 'Password must be at least $_minPasswordLength characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Validates confirm password matches
  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates required field
  static String? validateRequired(
    String? value, [
    String fieldName = 'This field',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates OTP secret key format
  static String? validateOTPSecret(String? value) {
    if (value == null || value.isEmpty) {
      return 'Secret key is required';
    }
    // Base32 characters only
    final base32Regex = RegExp(r'^[A-Z2-7]+=*$', caseSensitive: false);
    final cleanValue = value.replaceAll(' ', '').toUpperCase();
    if (!base32Regex.hasMatch(cleanValue)) {
      return 'Invalid secret key format';
    }
    if (cleanValue.length < 16) {
      return 'Secret key is too short';
    }
    return null;
  }

  /// Validates issuer name
  static String? validateIssuer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Issuer name is required';
    }
    if (value.length > 50) {
      return 'Issuer name is too long';
    }
    return null;
  }

  /// Validates account name
  static String? validateAccountName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account name is required';
    }
    if (value.length > 100) {
      return 'Account name is too long';
    }
    return null;
  }
}
