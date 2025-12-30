import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/failures/exceptions.dart';

/// Abstract Supabase data source interface
/// Used as secondary/redundant backend for VaultKey
abstract class SupabaseDataSource {
  /// Get Supabase client instance
  SupabaseClient get client;

  /// Get current authenticated user (if using Supabase auth)
  User? get currentUser;

  /// Check if user is authenticated via Supabase
  bool get isAuthenticated;

  /// Store backup data to Supabase
  Future<void> storeBackupData({required String userId, required String tableName, required Map<String, dynamic> data});

  /// Retrieve backup data from Supabase
  Future<Map<String, dynamic>?> getBackupData({required String userId, required String tableName});

  /// Delete backup data from Supabase
  Future<void> deleteBackupData({required String userId, required String tableName});

  /// Upload file to Supabase Storage
  Future<String> uploadFile({required String bucketName, required String path, required List<int> data, String? contentType});

  /// Download file from Supabase Storage
  Future<List<int>> downloadFile({required String bucketName, required String path});

  /// Delete file from Supabase Storage
  Future<void> deleteFile({required String bucketName, required String path});

  /// Store analytics event
  Future<void> logAnalyticsEvent({required String eventName, required Map<String, dynamic> properties});

  /// Get user subscription data
  Future<Map<String, dynamic>?> getSubscriptionData(String userId);

  /// Update user subscription data
  Future<void> updateSubscriptionData({required String userId, required Map<String, dynamic> data});
}

/// Implementation of Supabase data source
class SupabaseDataSourceImpl implements SupabaseDataSource {
  SupabaseDataSourceImpl();

  @override
  SupabaseClient get client => Supabase.instance.client;

  @override
  User? get currentUser => client.auth.currentUser;

  @override
  bool get isAuthenticated => client.auth.currentUser != null;

  @override
  Future<void> storeBackupData({required String userId, required String tableName, required Map<String, dynamic> data}) async {
    try {
      await client.from(tableName).upsert({'user_id': userId, 'data': data, 'updated_at': DateTime.now().toIso8601String()});
    } catch (e) {
      throw ServerException(message: 'Failed to store backup data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getBackupData({required String userId, required String tableName}) async {
    try {
      final response = await client.from(tableName).select().eq('user_id', userId).maybeSingle();

      if (response == null) return null;
      return response['data'] as Map<String, dynamic>?;
    } catch (e) {
      throw ServerException(message: 'Failed to get backup data: $e');
    }
  }

  @override
  Future<void> deleteBackupData({required String userId, required String tableName}) async {
    try {
      await client.from(tableName).delete().eq('user_id', userId);
    } catch (e) {
      throw ServerException(message: 'Failed to delete backup data: $e');
    }
  }

  @override
  Future<String> uploadFile({required String bucketName, required String path, required List<int> data, String? contentType}) async {
    try {
      final bytes = Uint8List.fromList(data);
      await client.storage.from(bucketName).uploadBinary(path, bytes, fileOptions: FileOptions(contentType: contentType));

      // Get the public URL
      return client.storage.from(bucketName).getPublicUrl(path);
    } catch (e) {
      throw ServerException(message: 'Failed to upload file: $e');
    }
  }

  @override
  Future<List<int>> downloadFile({required String bucketName, required String path}) async {
    try {
      final response = await client.storage.from(bucketName).download(path);
      return response.toList();
    } catch (e) {
      throw ServerException(message: 'Failed to download file: $e');
    }
  }

  @override
  Future<void> deleteFile({required String bucketName, required String path}) async {
    try {
      await client.storage.from(bucketName).remove([path]);
    } catch (e) {
      throw ServerException(message: 'Failed to delete file: $e');
    }
  }

  @override
  Future<void> logAnalyticsEvent({required String eventName, required Map<String, dynamic> properties}) async {
    try {
      await client.from('analytics_events').insert({'event_name': eventName, 'properties': properties, 'created_at': DateTime.now().toIso8601String()});
    } catch (e) {
      // Don't throw for analytics - just log silently
      // Analytics failures shouldn't crash the app
    }
  }

  @override
  Future<Map<String, dynamic>?> getSubscriptionData(String userId) async {
    try {
      final response = await client.from('subscriptions').select().eq('user_id', userId).maybeSingle();

      return response;
    } catch (e) {
      throw ServerException(message: 'Failed to get subscription data: $e');
    }
  }

  @override
  Future<void> updateSubscriptionData({required String userId, required Map<String, dynamic> data}) async {
    try {
      await client.from('subscriptions').upsert({'user_id': userId, ...data, 'updated_at': DateTime.now().toIso8601String()});
    } catch (e) {
      throw ServerException(message: 'Failed to update subscription data: $e');
    }
  }
}
