import 'package:hive_flutter/hive_flutter.dart';

import '../../models/authenticator_model.dart';

/// Local data source for authenticator storage using encrypted Hive
abstract class AuthenticatorLocalDataSource {
  /// Initialize the data source
  Future<void> init();

  /// Get all authenticators
  Future<List<AuthenticatorModel>> getAllAuthenticators();

  /// Get authenticator by ID
  Future<AuthenticatorModel?> getAuthenticator(String id);

  /// Add new authenticator
  Future<void> addAuthenticator(AuthenticatorModel authenticator);

  /// Update existing authenticator
  Future<void> updateAuthenticator(AuthenticatorModel authenticator);

  /// Delete authenticator
  Future<void> deleteAuthenticator(String id);

  /// Delete all authenticators
  Future<void> deleteAllAuthenticators();

  /// Reorder authenticators
  Future<void> reorderAuthenticators(List<String> orderedIds);

  /// Search authenticators by query
  Future<List<AuthenticatorModel>> searchAuthenticators(String query);

  /// Get authenticators by issuer
  Future<List<AuthenticatorModel>> getByIssuer(String issuer);

  /// Watch authenticators stream
  Stream<List<AuthenticatorModel>> watchAuthenticators();
}

/// Implementation of authenticator local data source
class AuthenticatorLocalDataSourceImpl implements AuthenticatorLocalDataSource {
  static const String _boxName = 'authenticators';
  Box<Map<dynamic, dynamic>>? _box;

  @override
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<Map<dynamic, dynamic>>(_boxName);
    } else {
      _box = Hive.box<Map<dynamic, dynamic>>(_boxName);
    }
  }

  Box<Map<dynamic, dynamic>> get _safeBox {
    if (_box == null || !_box!.isOpen) {
      throw StateError('Authenticator box is not initialized. Call init() first.');
    }
    return _box!;
  }

  @override
  Future<List<AuthenticatorModel>> getAllAuthenticators() async {
    final values = _safeBox.values.toList();
    final authenticators = values.map((e) => AuthenticatorModel.fromJson(Map<String, dynamic>.from(e))).toList();

    // Sort by sortOrder
    authenticators.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return authenticators;
  }

  @override
  Future<AuthenticatorModel?> getAuthenticator(String id) async {
    final data = _safeBox.get(id);
    if (data == null) return null;
    return AuthenticatorModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> addAuthenticator(AuthenticatorModel authenticator) async {
    await _safeBox.put(authenticator.id, authenticator.toJson());
  }

  @override
  Future<void> updateAuthenticator(AuthenticatorModel authenticator) async {
    if (!_safeBox.containsKey(authenticator.id)) {
      throw StateError('Authenticator with id ${authenticator.id} not found');
    }
    await _safeBox.put(authenticator.id, authenticator.toJson());
  }

  @override
  Future<void> deleteAuthenticator(String id) async {
    await _safeBox.delete(id);
  }

  @override
  Future<void> deleteAllAuthenticators() async {
    await _safeBox.clear();
  }

  @override
  Future<void> reorderAuthenticators(List<String> orderedIds) async {
    for (var i = 0; i < orderedIds.length; i++) {
      final data = _safeBox.get(orderedIds[i]);
      if (data != null) {
        final updated = Map<String, dynamic>.from(data);
        updated['sortOrder'] = i;
        await _safeBox.put(orderedIds[i], updated);
      }
    }
  }

  @override
  Future<List<AuthenticatorModel>> searchAuthenticators(String query) async {
    final all = await getAllAuthenticators();
    final lowerQuery = query.toLowerCase();
    return all.where((a) => a.issuer.toLowerCase().contains(lowerQuery) || a.accountName.toLowerCase().contains(lowerQuery)).toList();
  }

  @override
  Future<List<AuthenticatorModel>> getByIssuer(String issuer) async {
    final all = await getAllAuthenticators();
    return all.where((a) => a.issuer.toLowerCase() == issuer.toLowerCase()).toList();
  }

  @override
  Stream<List<AuthenticatorModel>> watchAuthenticators() {
    return _safeBox.watch().map((_) {
      return _safeBox.values.map((e) => AuthenticatorModel.fromJson(Map<String, dynamic>.from(e))).toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    });
  }
}
