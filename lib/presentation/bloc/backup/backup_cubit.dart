import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/backup_entity.dart';
import 'backup_state.dart';

/// Cubit for managing backup state
class BackupCubit extends Cubit<BackupState> {
  BackupCubit() : super(const BackupState());

  /// Load backup data
  void loadBackupData() {
    emit(state.copyWith(status: BackupStatus.loading));

    // Mock data for demonstration
    final backupHistory = [
      BackupEntity(id: '1', userId: 'user1', createdAt: DateTime.now().subtract(const Duration(hours: 2)), size: 3400, authenticatorCount: 12, version: '1.0.0', deviceName: 'This device', isAutomatic: true),
      BackupEntity(id: '2', userId: 'user1', createdAt: DateTime.now().subtract(const Duration(days: 1)), size: 3200, authenticatorCount: 11, version: '1.0.0', deviceName: 'This device', isAutomatic: true),
      BackupEntity(id: '3', userId: 'user1', createdAt: DateTime.now().subtract(const Duration(days: 3)), size: 2800, authenticatorCount: 10, version: '1.0.0', deviceName: 'Old Phone', isAutomatic: false),
    ];

    emit(state.copyWith(status: BackupStatus.loaded, backupHistory: backupHistory, lastSyncAt: DateTime.now().subtract(const Duration(hours: 2))));
  }

  /// Toggle auto backup
  void toggleAutoBackup(bool enabled) {
    emit(state.copyWith(autoBackupEnabled: enabled));
  }

  /// Toggle wifi only
  void toggleWifiOnly(bool enabled) {
    emit(state.copyWith(wifiOnlyEnabled: enabled));
  }

  /// Perform backup
  Future<void> performBackup() async {
    emit(state.copyWith(status: BackupStatus.syncing, clearError: true));

    try {
      // Simulate backup
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: BackupStatus.loaded, lastSyncAt: DateTime.now(), successMessage: 'Backup completed successfully'));
    } catch (e) {
      emit(state.copyWith(status: BackupStatus.error, errorMessage: 'Backup failed: ${e.toString()}'));
    }
  }

  /// Restore backup
  Future<void> restoreBackup(String backupId) async {
    emit(state.copyWith(status: BackupStatus.loading, clearError: true));

    try {
      // TODO: Implement actual restore logic
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: BackupStatus.loaded, successMessage: 'Backup restored successfully'));
    } catch (e) {
      emit(state.copyWith(status: BackupStatus.loaded, errorMessage: 'Restore failed: ${e.toString()}'));
    }
  }

  /// Delete backup
  Future<void> deleteBackup(String backupId) async {
    try {
      // TODO: Implement actual delete logic
      final updatedHistory = state.backupHistory.where((b) => b.id != backupId).toList();

      emit(state.copyWith(backupHistory: updatedHistory, successMessage: 'Backup deleted'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Delete failed: ${e.toString()}'));
    }
  }
}
