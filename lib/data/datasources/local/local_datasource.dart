import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/failures/exceptions.dart';

/// Abstract local data source interface
abstract class LocalDataSource {
  /// Initialize local storage
  Future<void> init();

  /// Get value from secure storage
  Future<String?> getSecureValue(String key);

  /// Save value to secure storage
  Future<void> setSecureValue(String key, String value);

  /// Delete value from secure storage
  Future<void> deleteSecureValue(String key);

  /// Check if value exists in secure storage
  Future<bool> hasSecureValue(String key);

  /// Clear all secure storage
  Future<void> clearSecureStorage();

  /// Get Hive box for a specific type
  Box<T> getBox<T>(String boxName);

  /// Open a Hive box
  Future<Box<T>> openBox<T>(String boxName);

  /// Close all Hive boxes
  Future<void> closeAllBoxes();
}

/// Implementation of local data source
class LocalDataSourceImpl implements LocalDataSource {
  final FlutterSecureStorage _secureStorage;

  LocalDataSourceImpl({FlutterSecureStorage? secureStorage})
    : _secureStorage =
          secureStorage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(),
            iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
          );

  @override
  Future<void> init() async {
    try {
      await Hive.initFlutter();
      // Register adapters here when models are created
      // Hive.registerAdapter(AuthenticatorModelAdapter());
    } catch (e) {
      throw CacheException(message: 'Failed to initialize local storage: $e');
    }
  }

  @override
  Future<String?> getSecureValue(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to read secure value: $e');
    }
  }

  @override
  Future<void> setSecureValue(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      throw CacheException(message: 'Failed to write secure value: $e');
    }
  }

  @override
  Future<void> deleteSecureValue(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to delete secure value: $e');
    }
  }

  @override
  Future<bool> hasSecureValue(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      throw CacheException(message: 'Failed to check secure value: $e');
    }
  }

  @override
  Future<void> clearSecureStorage() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw CacheException(message: 'Failed to clear secure storage: $e');
    }
  }

  @override
  Box<T> getBox<T>(String boxName) {
    try {
      return Hive.box<T>(boxName);
    } catch (e) {
      throw CacheException(message: 'Failed to get Hive box: $e');
    }
  }

  @override
  Future<Box<T>> openBox<T>(String boxName) async {
    try {
      return await Hive.openBox<T>(boxName);
    } catch (e) {
      throw CacheException(message: 'Failed to open Hive box: $e');
    }
  }

  @override
  Future<void> closeAllBoxes() async {
    try {
      await Hive.close();
    } catch (e) {
      throw CacheException(message: 'Failed to close Hive boxes: $e');
    }
  }
}
