import 'package:equatable/equatable.dart';

/// OTP type enumeration
enum OTPType { totp, hotp }

/// Hashing algorithm enumeration
enum Algorithm { sha1, sha256, sha512 }

/// Authenticator entity representing TOTP/HOTP account
class AuthenticatorEntity extends Equatable {
  final String id;
  final String issuer;
  final String accountName;
  final String secret;
  final OTPType type;
  final int digits;
  final int period;
  final Algorithm algorithm;
  final String? iconUrl;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const AuthenticatorEntity({required this.id, required this.issuer, required this.accountName, required this.secret, this.type = OTPType.totp, this.digits = 6, this.period = 30, this.algorithm = Algorithm.sha1, this.iconUrl, this.sortOrder = 0, required this.createdAt, this.lastUsedAt});

  /// Get full label (issuer:accountName)
  String get label => '$issuer:$accountName';

  /// Get short label (accountName only)
  String get shortLabel => accountName;

  /// Check if TOTP
  bool get isTotp => type == OTPType.totp;

  /// Check if HOTP
  bool get isHotp => type == OTPType.hotp;

  @override
  List<Object?> get props => [id, issuer, accountName, secret, type, digits, period, algorithm, iconUrl, sortOrder, createdAt, lastUsedAt];

  /// Create copy with updated fields
  AuthenticatorEntity copyWith({String? id, String? issuer, String? accountName, String? secret, OTPType? type, int? digits, int? period, Algorithm? algorithm, String? iconUrl, int? sortOrder, DateTime? createdAt, DateTime? lastUsedAt}) {
    return AuthenticatorEntity(
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
