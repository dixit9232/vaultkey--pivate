import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/failures/exceptions.dart';

/// Abstract Firebase data source interface
abstract class FirebaseDataSource {
  /// Get current authenticated user
  User? get currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password});

  /// Create user with email and password
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password});

  /// Sign out
  Future<void> signOut();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Get Firestore collection reference
  CollectionReference<Map<String, dynamic>> getCollection(String path);

  /// Get Firestore document reference
  DocumentReference<Map<String, dynamic>> getDocument(String path);

  /// Upload file to Firebase Storage
  Future<String> uploadFile({required String path, required List<int> data, String? contentType});

  /// Download file from Firebase Storage
  Future<List<int>> downloadFile(String path);

  /// Delete file from Firebase Storage
  Future<void> deleteFile(String path);
}

/// Implementation of Firebase data source
class FirebaseDataSourceImpl implements FirebaseDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  FirebaseDataSourceImpl({FirebaseAuth? auth, FirebaseFirestore? firestore, FirebaseStorage? storage}) : _auth = auth ?? FirebaseAuth.instance, _firestore = firestore ?? FirebaseFirestore.instance, _storage = storage ?? FirebaseStorage.instance;

  @override
  User? get currentUser => _auth.currentUser;

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  Future<UserCredential> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Authentication failed', code: e.code);
    } catch (e) {
      throw ServerException(message: 'Sign in failed: $e');
    }
  }

  @override
  Future<UserCredential> createUserWithEmailAndPassword({required String email, required String password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Registration failed', code: e.code);
    } catch (e) {
      throw ServerException(message: 'Registration failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw ServerException(message: 'Sign out failed: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(message: e.message ?? 'Failed to send reset email', code: e.code);
    } catch (e) {
      throw ServerException(message: 'Failed to send password reset email: $e');
    }
  }

  @override
  CollectionReference<Map<String, dynamic>> getCollection(String path) {
    return _firestore.collection(path);
  }

  @override
  DocumentReference<Map<String, dynamic>> getDocument(String path) {
    return _firestore.doc(path);
  }

  @override
  Future<String> uploadFile({required String path, required List<int> data, String? contentType}) async {
    try {
      final ref = _storage.ref(path);
      final metadata = contentType != null ? SettableMetadata(contentType: contentType) : null;
      await ref.putData(data is Uint8List ? data : Uint8List.fromList(data), metadata);
      return await ref.getDownloadURL();
    } catch (e) {
      throw ServerException(message: 'Failed to upload file: $e');
    }
  }

  @override
  Future<List<int>> downloadFile(String path) async {
    try {
      final ref = _storage.ref(path);
      final data = await ref.getData();
      if (data == null) {
        throw const ServerException(message: 'File not found');
      }
      return data;
    } catch (e) {
      throw ServerException(message: 'Failed to download file: $e');
    }
  }

  @override
  Future<void> deleteFile(String path) async {
    try {
      final ref = _storage.ref(path);
      await ref.delete();
    } catch (e) {
      throw ServerException(message: 'Failed to delete file: $e');
    }
  }
}
