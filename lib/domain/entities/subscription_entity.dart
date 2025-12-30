import 'package:equatable/equatable.dart';

/// Subscription tier enumeration
enum SubscriptionTier {
  /// Free tier with basic features
  essential,

  /// Personal tier with cloud backup
  securePlus,

  /// Power user tier with advanced features
  pro,

  /// Enterprise tier for teams
  team,
}

/// Subscription entity representing user's subscription status
class SubscriptionEntity extends Equatable {
  final String id;
  final String userId;
  final SubscriptionTier tier;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool isActive;
  final bool isTrialing;
  final String? productId;
  final String? purchaseToken;
  final DateTime? lastVerifiedAt;

  const SubscriptionEntity({required this.id, required this.userId, required this.tier, this.startDate, this.endDate, this.isActive = true, this.isTrialing = false, this.productId, this.purchaseToken, this.lastVerifiedAt});

  /// Check if subscription has expired
  bool get isExpired {
    if (endDate == null) return false;
    return DateTime.now().isAfter(endDate!);
  }

  /// Check if user has premium features (Secure+ or higher)
  bool get isPremium => tier != SubscriptionTier.essential && isActive && !isExpired;

  /// Check if user has pro features
  bool get isPro => (tier == SubscriptionTier.pro || tier == SubscriptionTier.team) && isActive && !isExpired;

  /// Check if user has team features
  bool get isTeam => tier == SubscriptionTier.team && isActive && !isExpired;

  /// Get display name for tier
  String get tierDisplayName {
    switch (tier) {
      case SubscriptionTier.essential:
        return 'Essential';
      case SubscriptionTier.securePlus:
        return 'Secure+';
      case SubscriptionTier.pro:
        return 'Pro';
      case SubscriptionTier.team:
        return 'Team';
    }
  }

  /// Get monthly price for tier
  double get monthlyPrice {
    switch (tier) {
      case SubscriptionTier.essential:
        return 0;
      case SubscriptionTier.securePlus:
        return 2.99;
      case SubscriptionTier.pro:
        return 4.99;
      case SubscriptionTier.team:
        return 6.99; // Per user
    }
  }

  /// Get yearly price for tier (with discount)
  double get yearlyPrice {
    switch (tier) {
      case SubscriptionTier.essential:
        return 0;
      case SubscriptionTier.securePlus:
        return 24.99;
      case SubscriptionTier.pro:
        return 39.99;
      case SubscriptionTier.team:
        return 59.99; // Per user
    }
  }

  @override
  List<Object?> get props => [id, userId, tier, startDate, endDate, isActive, isTrialing, productId, purchaseToken, lastVerifiedAt];

  /// Create copy with updated fields
  SubscriptionEntity copyWith({String? id, String? userId, SubscriptionTier? tier, DateTime? startDate, DateTime? endDate, bool? isActive, bool? isTrialing, String? productId, String? purchaseToken, DateTime? lastVerifiedAt}) {
    return SubscriptionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tier: tier ?? this.tier,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      isTrialing: isTrialing ?? this.isTrialing,
      productId: productId ?? this.productId,
      purchaseToken: purchaseToken ?? this.purchaseToken,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
    );
  }

  /// Create default free subscription
  factory SubscriptionEntity.free(String userId) {
    return SubscriptionEntity(id: 'free_$userId', userId: userId, tier: SubscriptionTier.essential, isActive: true);
  }
}
