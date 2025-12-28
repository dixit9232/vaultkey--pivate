import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/export.dart';

import '../failures/exceptions.dart';

/// Encryption service for secure data handling
/// Uses AES-256-GCM for encryption and Argon2 for key derivation
class EncryptionService {
  EncryptionService._();

  static const int _keyLength = 32; // 256 bits
  static const int _ivLength = 12; // 96 bits for GCM
  static const int _saltLength = 16; // 128 bits
  static const int _tagLength = 16; // 128 bits (GCM auth tag)

  // Argon2 parameters
  static const int _argon2Iterations = 3;
  static const int _argon2MemoryKB = 65536; // 64 MB
  static const int _argon2Parallelism = 4;

  /// Generate a cryptographically secure random key
  static Uint8List generateRandomKey([int length = _keyLength]) {
    final random = Random.secure();
    return Uint8List.fromList(List<int>.generate(length, (_) => random.nextInt(256)));
  }

  /// Generate a random IV for encryption
  static Uint8List generateIV() {
    return generateRandomKey(_ivLength);
  }

  /// Generate a random salt for key derivation
  static Uint8List generateSalt() {
    return generateRandomKey(_saltLength);
  }

  /// Derive encryption key from password using Argon2id
  static Uint8List deriveKeyFromPassword(String password, Uint8List salt) {
    final argon2 = Argon2BytesGenerator();

    final params = Argon2Parameters(Argon2Parameters.ARGON2_id, salt, desiredKeyLength: _keyLength, iterations: _argon2Iterations, memory: _argon2MemoryKB, lanes: _argon2Parallelism);

    argon2.init(params);

    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    final key = Uint8List(_keyLength);
    argon2.deriveKey(passwordBytes, passwordBytes.length, key, 0);

    return key;
  }

  /// Encrypt data using AES-256-GCM
  static String encryptAES256GCM(String plaintext, Uint8List key) {
    try {
      final iv = generateIV();
      final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.gcm));

      final encrypted = encrypter.encrypt(plaintext, iv: encrypt.IV(iv));

      // Combine IV + ciphertext for storage
      final encryptedBytesLength = encrypted.bytes.length;
      final combined = Uint8List(_ivLength + encryptedBytesLength);
      combined.setRange(0, _ivLength, iv);
      combined.setRange(_ivLength, combined.length, encrypted.bytes);

      return base64Encode(combined);
    } catch (e) {
      throw EncryptionException(message: 'Encryption failed: $e');
    }
  }

  /// Decrypt data using AES-256-GCM
  static String decryptAES256GCM(String ciphertext, Uint8List key) {
    try {
      final combined = base64Decode(ciphertext);

      if (combined.length < _ivLength + _tagLength) {
        throw const EncryptionException(message: 'Invalid ciphertext');
      }

      final iv = Uint8List.sublistView(combined, 0, _ivLength);
      final encryptedBytes = Uint8List.sublistView(combined, _ivLength);

      final encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key(key), mode: encrypt.AESMode.gcm));

      final decrypted = encrypter.decrypt(encrypt.Encrypted(encryptedBytes), iv: encrypt.IV(iv));

      return decrypted;
    } catch (e) {
      throw EncryptionException(message: 'Decryption failed: $e');
    }
  }

  /// Encrypt data with password (derives key internally)
  static Map<String, String> encryptWithPassword(String plaintext, String password) {
    final salt = generateSalt();
    final key = deriveKeyFromPassword(password, salt);
    final encrypted = encryptAES256GCM(plaintext, key);

    return {'data': encrypted, 'salt': base64Encode(salt)};
  }

  /// Decrypt data with password (derives key internally)
  static String decryptWithPassword(String ciphertext, String password, String saltBase64) {
    final salt = base64Decode(saltBase64);
    final key = deriveKeyFromPassword(password, salt);
    return decryptAES256GCM(ciphertext, key);
  }

  /// Hash data using SHA-256
  static String hashSHA256(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Hash data using SHA-512
  static String hashSHA512(String data) {
    final bytes = utf8.encode(data);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  /// Generate HMAC-SHA256
  static String hmacSHA256(String data, Uint8List key) {
    final hmacInstance = Hmac(sha256, key);
    final digest = hmacInstance.convert(utf8.encode(data));
    return digest.toString();
  }

  /// Generate HMAC-SHA512
  static String hmacSHA512(String data, Uint8List key) {
    final hmacInstance = Hmac(sha512, key);
    final digest = hmacInstance.convert(utf8.encode(data));
    return digest.toString();
  }

  /// Securely compare two strings (constant-time)
  static bool secureCompare(String a, String b) {
    if (a.length != b.length) return false;

    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  /// Clear sensitive data from memory (best effort)
  static void clearBytes(Uint8List bytes) {
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = 0;
    }
  }
}
