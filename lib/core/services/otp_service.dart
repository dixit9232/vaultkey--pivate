import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Service for generating TOTP and HOTP codes
/// Implements RFC 4226 (HOTP) and RFC 6238 (TOTP)
class OTPService {
  OTPService._();
  static final OTPService instance = OTPService._();

  /// Generate TOTP code for the given secret
  ///
  /// [secret] - Base32 encoded secret key
  /// [algorithm] - Hash algorithm (sha1, sha256, sha512)
  /// [digits] - Number of digits (6 or 8)
  /// [period] - Time period in seconds (default 30)
  /// [timestamp] - Optional timestamp (uses current time if null)
  String generateTOTP({required String secret, String algorithm = 'sha1', int digits = 6, int period = 30, DateTime? timestamp}) {
    final time = timestamp ?? DateTime.now();
    final counter = (time.millisecondsSinceEpoch ~/ 1000) ~/ period;
    return generateHOTP(secret: secret, counter: counter, algorithm: algorithm, digits: digits);
  }

  /// Generate HOTP code for the given secret and counter
  ///
  /// [secret] - Base32 encoded secret key
  /// [counter] - Counter value
  /// [algorithm] - Hash algorithm (sha1, sha256, sha512)
  /// [digits] - Number of digits (6 or 8)
  String generateHOTP({required String secret, required int counter, String algorithm = 'sha1', int digits = 6}) {
    final decodedSecret = _base32Decode(secret);
    final counterBytes = _intToBytes(counter);

    final hmac = _getHmac(algorithm, decodedSecret);
    final hash = hmac.convert(counterBytes).bytes;

    final offset = hash[hash.length - 1] & 0x0F;
    final binary = ((hash[offset] & 0x7F) << 24) | ((hash[offset + 1] & 0xFF) << 16) | ((hash[offset + 2] & 0xFF) << 8) | (hash[offset + 3] & 0xFF);

    final otp = binary % _pow10(digits);
    return otp.toString().padLeft(digits, '0');
  }

  /// Get remaining seconds until next TOTP code
  int getRemainingSeconds({int period = 30}) {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return period - (now % period);
  }

  /// Get progress (0.0 to 1.0) through current TOTP period
  double getProgress({int period = 30}) {
    final remaining = getRemainingSeconds(period: period);
    return (period - remaining) / period;
  }

  /// Validate a secret key (check if valid Base32)
  bool isValidSecret(String secret) {
    try {
      _base32Decode(secret);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Parse otpauth:// URI
  OTPAuthUri? parseOTPAuthUri(String uri) {
    try {
      final parsed = Uri.parse(uri);
      if (parsed.scheme != 'otpauth') return null;

      final type = parsed.host.toLowerCase();
      if (type != 'totp' && type != 'hotp') return null;

      final path = parsed.pathSegments.isNotEmpty ? parsed.pathSegments.first : '';
      final parts = path.split(':');
      final issuer = parsed.queryParameters['issuer'] ?? (parts.length > 1 ? parts.first : '');
      final accountName = parts.length > 1 ? parts.last : parts.first;

      final secret = parsed.queryParameters['secret'];
      if (secret == null || secret.isEmpty) return null;

      return OTPAuthUri(
        type: type,
        issuer: Uri.decodeComponent(issuer),
        accountName: Uri.decodeComponent(accountName),
        secret: secret.toUpperCase().replaceAll(' ', ''),
        algorithm: parsed.queryParameters['algorithm']?.toLowerCase() ?? 'sha1',
        digits: int.tryParse(parsed.queryParameters['digits'] ?? '') ?? 6,
        period: int.tryParse(parsed.queryParameters['period'] ?? '') ?? 30,
        counter: int.tryParse(parsed.queryParameters['counter'] ?? '') ?? 0,
      );
    } catch (_) {
      return null;
    }
  }

  /// Generate otpauth:// URI
  String generateOTPAuthUri({required String type, required String issuer, required String accountName, required String secret, String algorithm = 'sha1', int digits = 6, int period = 30, int counter = 0}) {
    final typeStr = type;
    final label = Uri.encodeComponent('$issuer:$accountName');

    final params = <String, String>{'secret': secret, 'issuer': Uri.encodeComponent(issuer), 'algorithm': algorithm.toUpperCase(), 'digits': digits.toString()};

    if (type == 'totp') {
      params['period'] = period.toString();
    } else {
      params['counter'] = counter.toString();
    }

    final queryString = params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return 'otpauth://$typeStr/$label?$queryString';
  }

  // Private helper methods

  Hmac _getHmac(String algorithm, Uint8List key) {
    switch (algorithm.toLowerCase()) {
      case 'sha256':
        return Hmac(sha256, key);
      case 'sha512':
        return Hmac(sha512, key);
      case 'sha1':
      default:
        return Hmac(sha1, key);
    }
  }

  Uint8List _intToBytes(int value) {
    final bytes = Uint8List(8);
    for (var i = 7; i >= 0; i--) {
      bytes[i] = value & 0xFF;
      value >>= 8;
    }
    return bytes;
  }

  int _pow10(int n) {
    var result = 1;
    for (var i = 0; i < n; i++) {
      result *= 10;
    }
    return result;
  }

  Uint8List _base32Decode(String input) {
    const base32Chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
    final sanitized = input.toUpperCase().replaceAll(RegExp(r'[^A-Z2-7]'), '');

    if (sanitized.isEmpty) {
      throw ArgumentError('Invalid Base32 string');
    }

    final bits = StringBuffer();
    for (var i = 0; i < sanitized.length; i++) {
      final index = base32Chars.indexOf(sanitized[i]);
      if (index < 0) throw ArgumentError('Invalid Base32 character: ${sanitized[i]}');
      bits.write(index.toRadixString(2).padLeft(5, '0'));
    }

    final bitsStr = bits.toString();
    final bytes = <int>[];
    for (var i = 0; i + 8 <= bitsStr.length; i += 8) {
      bytes.add(int.parse(bitsStr.substring(i, i + 8), radix: 2));
    }

    return Uint8List.fromList(bytes);
  }
}

/// Parsed OTP Auth URI data
class OTPAuthUri {
  final String type; // 'totp' or 'hotp'
  final String issuer;
  final String accountName;
  final String secret;
  final String algorithm;
  final int digits;
  final int period;
  final int counter;

  const OTPAuthUri({required this.type, required this.issuer, required this.accountName, required this.secret, this.algorithm = 'sha1', this.digits = 6, this.period = 30, this.counter = 0});

  bool get isTotp => type == 'totp';
  bool get isHotp => type == 'hotp';

  @override
  String toString() =>
      'OTPAuthUri(type: $type, issuer: $issuer, '
      'accountName: $accountName, algorithm: $algorithm, '
      'digits: $digits, period: $period)';
}
