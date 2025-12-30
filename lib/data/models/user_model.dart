import '../../domain/entities/user_entity.dart';

/// User data transfer object for serialization
class UserModel extends UserEntity {
  const UserModel({required super.id, required super.email, super.displayName, super.photoUrl, super.emailVerified = false, super.createdAt, super.lastLoginAt});

  /// Create from JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      emailVerified: json['emailVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      lastLoginAt: json['lastLoginAt'] != null ? DateTime.parse(json['lastLoginAt'] as String) : null,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'displayName': displayName, 'photoUrl': photoUrl, 'emailVerified': emailVerified, 'createdAt': createdAt?.toIso8601String(), 'lastLoginAt': lastLoginAt?.toIso8601String()};
  }

  /// Create from domain entity
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(id: entity.id, email: entity.email, displayName: entity.displayName, photoUrl: entity.photoUrl, emailVerified: entity.emailVerified, createdAt: entity.createdAt, lastLoginAt: entity.lastLoginAt);
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    return UserEntity(id: id, email: email, displayName: displayName, photoUrl: photoUrl, emailVerified: emailVerified, createdAt: createdAt, lastLoginAt: lastLoginAt);
  }

  /// Create copy with updated fields
  @override
  UserModel copyWith({String? id, String? email, String? displayName, String? photoUrl, bool? emailVerified, DateTime? createdAt, DateTime? lastLoginAt}) {
    return UserModel(id: id ?? this.id, email: email ?? this.email, displayName: displayName ?? this.displayName, photoUrl: photoUrl ?? this.photoUrl, emailVerified: emailVerified ?? this.emailVerified, createdAt: createdAt ?? this.createdAt, lastLoginAt: lastLoginAt ?? this.lastLoginAt);
  }
}
