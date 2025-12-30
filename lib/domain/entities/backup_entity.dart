import 'package:equatable/equatable.dart';

/// Backup entity representing a cloud backup
class BackupEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime createdAt;
  final int size;
  final int authenticatorCount;
  final String version;
  final String? deviceId;
  final String? deviceName;
  final bool isAutomatic;
  final String? encryptionKeyHash;

  const BackupEntity({required this.id, required this.userId, required this.createdAt, required this.size, required this.authenticatorCount, required this.version, this.deviceId, this.deviceName, this.isAutomatic = false, this.encryptionKeyHash});

  /// Get formatted size string
  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  /// Get relative time string
  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(createdAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  @override
  List<Object?> get props => [id, userId, createdAt, size, authenticatorCount, version, deviceId, deviceName, isAutomatic, encryptionKeyHash];

  /// Create copy with updated fields
  BackupEntity copyWith({String? id, String? userId, DateTime? createdAt, int? size, int? authenticatorCount, String? version, String? deviceId, String? deviceName, bool? isAutomatic, String? encryptionKeyHash}) {
    return BackupEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      size: size ?? this.size,
      authenticatorCount: authenticatorCount ?? this.authenticatorCount,
      version: version ?? this.version,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      isAutomatic: isAutomatic ?? this.isAutomatic,
      encryptionKeyHash: encryptionKeyHash ?? this.encryptionKeyHash,
    );
  }
}

/// Sync status entity
class SyncStatusEntity extends Equatable {
  final DateTime? lastSyncAt;
  final bool isSyncing;
  final String? error;
  final int pendingChanges;
  final List<String> syncedDevices;

  const SyncStatusEntity({this.lastSyncAt, this.isSyncing = false, this.error, this.pendingChanges = 0, this.syncedDevices = const []});

  /// Check if sync is needed
  bool get needsSync => pendingChanges > 0;

  /// Check if recently synced (within last hour)
  bool get isRecentlySynced {
    if (lastSyncAt == null) return false;
    return DateTime.now().difference(lastSyncAt!).inHours < 1;
  }

  @override
  List<Object?> get props => [lastSyncAt, isSyncing, error, pendingChanges, syncedDevices];

  /// Create copy with updated fields
  SyncStatusEntity copyWith({DateTime? lastSyncAt, bool? isSyncing, String? error, int? pendingChanges, List<String>? syncedDevices}) {
    return SyncStatusEntity(lastSyncAt: lastSyncAt ?? this.lastSyncAt, isSyncing: isSyncing ?? this.isSyncing, error: error ?? this.error, pendingChanges: pendingChanges ?? this.pendingChanges, syncedDevices: syncedDevices ?? this.syncedDevices);
  }
}

/// Recovery code entity
class RecoveryCodeEntity extends Equatable {
  final String code;
  final bool isUsed;
  final DateTime? usedAt;
  final DateTime createdAt;

  const RecoveryCodeEntity({required this.code, this.isUsed = false, this.usedAt, required this.createdAt});

  @override
  List<Object?> get props => [code, isUsed, usedAt, createdAt];

  /// Create copy with updated fields
  RecoveryCodeEntity copyWith({String? code, bool? isUsed, DateTime? usedAt, DateTime? createdAt}) {
    return RecoveryCodeEntity(code: code ?? this.code, isUsed: isUsed ?? this.isUsed, usedAt: usedAt ?? this.usedAt, createdAt: createdAt ?? this.createdAt);
  }
}
