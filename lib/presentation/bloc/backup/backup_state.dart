import 'package:equatable/equatable.dart';

import '../../../domain/entities/backup_entity.dart';

/// Backup screen status
enum BackupStatus { initial, loading, loaded, syncing, error }

/// Backup state
class BackupState extends Equatable {
  final BackupStatus status;
  final bool autoBackupEnabled;
  final bool wifiOnlyEnabled;
  final DateTime? lastSyncAt;
  final List<BackupEntity> backupHistory;
  final String? errorMessage;
  final String? successMessage;
  final double storageUsed;
  final double storageTotal;

  const BackupState({this.status = BackupStatus.initial, this.autoBackupEnabled = true, this.wifiOnlyEnabled = true, this.lastSyncAt, this.backupHistory = const [], this.errorMessage, this.successMessage, this.storageUsed = 3.4, this.storageTotal = 5.0});

  bool get isSyncing => status == BackupStatus.syncing;
  bool get isLoading => status == BackupStatus.loading;
  double get storageProgress => storageUsed / storageTotal;

  BackupState copyWith({BackupStatus? status, bool? autoBackupEnabled, bool? wifiOnlyEnabled, DateTime? lastSyncAt, List<BackupEntity>? backupHistory, String? errorMessage, String? successMessage, double? storageUsed, double? storageTotal, bool clearError = false, bool clearSuccess = false}) {
    return BackupState(
      status: status ?? this.status,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      wifiOnlyEnabled: wifiOnlyEnabled ?? this.wifiOnlyEnabled,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      backupHistory: backupHistory ?? this.backupHistory,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      storageUsed: storageUsed ?? this.storageUsed,
      storageTotal: storageTotal ?? this.storageTotal,
    );
  }

  @override
  List<Object?> get props => [status, autoBackupEnabled, wifiOnlyEnabled, lastSyncAt, backupHistory, errorMessage, successMessage, storageUsed, storageTotal];
}
