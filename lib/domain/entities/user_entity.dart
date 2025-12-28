import 'package:equatable/equatable.dart';

/// User entity representing core user data
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const UserEntity({required this.id, required this.email, this.displayName, this.photoUrl, this.emailVerified = false, this.createdAt, this.lastLoginAt});

  /// Check if user has verified email
  bool get isVerified => emailVerified;

  /// Get display name or email as fallback
  String get name => displayName ?? email.split('@').first;

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, emailVerified, createdAt, lastLoginAt];

  /// Create copy with updated fields
  UserEntity copyWith({String? id, String? email, String? displayName, String? photoUrl, bool? emailVerified, DateTime? createdAt, DateTime? lastLoginAt}) {
    return UserEntity(id: id ?? this.id, email: email ?? this.email, displayName: displayName ?? this.displayName, photoUrl: photoUrl ?? this.photoUrl, emailVerified: emailVerified ?? this.emailVerified, createdAt: createdAt ?? this.createdAt, lastLoginAt: lastLoginAt ?? this.lastLoginAt);
  }
}
