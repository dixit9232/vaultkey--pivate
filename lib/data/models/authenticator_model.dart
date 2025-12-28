import '../../domain/entities/authenticator_entity.dart';

/// Authenticator data transfer object for serialization and local storage
class AuthenticatorModel extends AuthenticatorEntity {
  const AuthenticatorModel({required super.id, required super.issuer, required super.accountName, required super.secret, super.type = OTPType.totp, super.digits = 6, super.period = 30, super.algorithm = Algorithm.sha1, super.iconUrl, super.sortOrder = 0, required super.createdAt, super.lastUsedAt});

  /// Create from JSON map
  factory AuthenticatorModel.fromJson(Map<String, dynamic> json) {
    return AuthenticatorModel(
      id: json['id'] as String,
      issuer: json['issuer'] as String,
      accountName: json['accountName'] as String,
      secret: json['secret'] as String,
      type: OTPType.values.firstWhere((e) => e.name == json['type'], orElse: () => OTPType.totp),
      digits: json['digits'] as int? ?? 6,
      period: json['period'] as int? ?? 30,
      algorithm: Algorithm.values.firstWhere((e) => e.name == json['algorithm'], orElse: () => Algorithm.sha1),
      iconUrl: json['iconUrl'] as String?,
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt: json['lastUsedAt'] != null ? DateTime.parse(json['lastUsedAt'] as String) : null,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issuer': issuer,
      'accountName': accountName,
      'secret': secret,
      'type': type.name,
      'digits': digits,
      'period': period,
      'algorithm': algorithm.name,
      'iconUrl': iconUrl,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
    };
  }

  /// Create from domain entity
  factory AuthenticatorModel.fromEntity(AuthenticatorEntity entity) {
    return AuthenticatorModel(
      id: entity.id,
      issuer: entity.issuer,
      accountName: entity.accountName,
      secret: entity.secret,
      type: entity.type,
      digits: entity.digits,
      period: entity.period,
      algorithm: entity.algorithm,
      iconUrl: entity.iconUrl,
      sortOrder: entity.sortOrder,
      createdAt: entity.createdAt,
      lastUsedAt: entity.lastUsedAt,
    );
  }

  /// Convert to domain entity
  AuthenticatorEntity toEntity() {
    return AuthenticatorEntity(id: id, issuer: issuer, accountName: accountName, secret: secret, type: type, digits: digits, period: period, algorithm: algorithm, iconUrl: iconUrl, sortOrder: sortOrder, createdAt: createdAt, lastUsedAt: lastUsedAt);
  }

  /// Create copy with updated fields
  @override
  AuthenticatorModel copyWith({String? id, String? issuer, String? accountName, String? secret, OTPType? type, int? digits, int? period, Algorithm? algorithm, String? iconUrl, int? sortOrder, DateTime? createdAt, DateTime? lastUsedAt}) {
    return AuthenticatorModel(
      id: id ?? this.id,
      issuer: issuer ?? this.issuer,
      accountName: accountName ?? this.accountName,
      secret: secret ?? this.secret,
      type: type ?? this.type,
      digits: digits ?? this.digits,
      period: period ?? this.period,
      algorithm: algorithm ?? this.algorithm,
      iconUrl: iconUrl ?? this.iconUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }
}
