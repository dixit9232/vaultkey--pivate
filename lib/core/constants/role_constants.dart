/// User role constants for RBAC
enum UserRole {
  /// Regular app user
  user('user'),

  /// Super admin with full access
  superAdmin('super_admin'),

  /// Support admin for user assistance
  supportAdmin('support_admin'),

  /// Finance admin for subscriptions
  financeAdmin('finance_admin'),

  /// Content admin for feature flags
  contentAdmin('content_admin'),

  /// Audit admin for compliance
  auditAdmin('audit_admin');

  final String value;

  const UserRole(this.value);

  /// Create from string value
  static UserRole fromString(String value) {
    return UserRole.values.firstWhere((role) => role.value == value, orElse: () => UserRole.user);
  }

  /// Check if this role has admin privileges
  bool get isAdmin => this != UserRole.user;

  /// Check if this role can manage users
  bool get canManageUsers => this == UserRole.superAdmin || this == UserRole.supportAdmin;

  /// Check if this role can manage subscriptions
  bool get canManageSubscriptions => this == UserRole.superAdmin || this == UserRole.financeAdmin;

  /// Check if this role can manage content
  bool get canManageContent => this == UserRole.superAdmin || this == UserRole.contentAdmin;

  /// Check if this role can view audit logs
  bool get canViewAuditLogs => this == UserRole.superAdmin || this == UserRole.auditAdmin;

  /// Check if this role has full access
  bool get hasFullAccess => this == UserRole.superAdmin;
}

/// Permission constants
class Permissions {
  Permissions._();

  // User permissions
  static const String readUsers = 'read_users';
  static const String writeUsers = 'write_users';
  static const String deleteUsers = 'delete_users';

  // Subscription permissions
  static const String readSubscriptions = 'read_subscriptions';
  static const String writeSubscriptions = 'write_subscriptions';
  static const String processRefunds = 'process_refunds';

  // Content permissions
  static const String manageFeatureFlags = 'manage_feature_flags';
  static const String manageAnnouncements = 'manage_announcements';
  static const String manageEmailTemplates = 'manage_email_templates';

  // Audit permissions
  static const String viewAuditLogs = 'view_audit_logs';
  static const String exportAuditLogs = 'export_audit_logs';
  static const String viewSystemHealth = 'view_system_health';

  // Support permissions
  static const String viewSupportTickets = 'view_support_tickets';
  static const String manageSupportTickets = 'manage_support_tickets';
  static const String resetUserPasswords = 'reset_user_passwords';
}

/// Role permission mappings
class RolePermissions {
  RolePermissions._();

  static List<String> getPermissions(UserRole role) {
    switch (role) {
      case UserRole.superAdmin:
        return [
          Permissions.readUsers,
          Permissions.writeUsers,
          Permissions.deleteUsers,
          Permissions.readSubscriptions,
          Permissions.writeSubscriptions,
          Permissions.processRefunds,
          Permissions.manageFeatureFlags,
          Permissions.manageAnnouncements,
          Permissions.manageEmailTemplates,
          Permissions.viewAuditLogs,
          Permissions.exportAuditLogs,
          Permissions.viewSystemHealth,
          Permissions.viewSupportTickets,
          Permissions.manageSupportTickets,
          Permissions.resetUserPasswords,
        ];

      case UserRole.supportAdmin:
        return [Permissions.readUsers, Permissions.viewSupportTickets, Permissions.manageSupportTickets, Permissions.resetUserPasswords];

      case UserRole.financeAdmin:
        return [Permissions.readSubscriptions, Permissions.writeSubscriptions, Permissions.processRefunds];

      case UserRole.contentAdmin:
        return [Permissions.manageFeatureFlags, Permissions.manageAnnouncements, Permissions.manageEmailTemplates];

      case UserRole.auditAdmin:
        return [Permissions.viewAuditLogs, Permissions.exportAuditLogs, Permissions.viewSystemHealth];

      case UserRole.user:
        return [];
    }
  }

  static bool hasPermission(UserRole role, String permission) {
    return getPermissions(role).contains(permission);
  }
}
