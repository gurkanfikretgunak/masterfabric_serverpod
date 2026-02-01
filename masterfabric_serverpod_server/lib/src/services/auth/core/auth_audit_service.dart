import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Auth event types
enum AuthEventType {
  login,
  logout,
  loginFailed,
  registration,
  registrationFailed,
  passwordChange,
  passwordReset,
  passwordResetFailed,
  accountBlocked,
  accountUnblocked,
  accountDeleted,
  accountDeactivated,
  accountReactivated,
  twoFactorEnabled,
  twoFactorDisabled,
  twoFactorVerificationFailed,
  sessionRevoked,
  roleAssigned,
  roleRevoked,
  profileUpdated,
  emailChanged,
}

/// Auth audit service
/// 
/// Handles logging of authentication and authorization events for audit and security purposes.
class AuthAuditService {
  /// Log an authentication event
  /// 
  /// [session] - Serverpod session
  /// [eventType] - Type of event
  /// [userId] - Optional user ID (null for anonymous events)
  /// [eventData] - Optional additional event data
  /// 
  /// Returns the created AuthAuditLog
  Future<AuthAuditLog> logEvent(
    Session session,
    AuthEventType eventType, {
    String? userId,
    Map<String, dynamic>? eventData,
  }) async {
    // Get IP address and user agent
    String? ipAddress;
    String? userAgent;

    // Try to get IP and user agent from request
    // Note: Session doesn't directly expose httpRequest in endpoints
    // This will be null for now, but can be enhanced if request is passed separately
    try {
      // For web routes, request might be available differently
      // For now, we'll leave these as null
    } catch (e) {
      // Ignore
    }

    // Create audit log entry
    final auditLog = AuthAuditLog(
      userId: userId,
      eventType: eventType.name,
      eventData: eventData != null ? jsonEncode(eventData) : '{}',
      ipAddress: ipAddress,
      userAgent: userAgent,
      timestamp: DateTime.now(),
    );

    // Insert into database
    final created = await AuthAuditLog.db.insertRow(session, auditLog);

    // Also log to session log for immediate visibility
    final logMessage = 'Auth audit: ${eventType.name} - userId: $userId, ipAddress: $ipAddress';
    session.log(
      logMessage,
      level: LogLevel.info,
    );

    return created;
  }

  /// Log login event
  Future<AuthAuditLog> logLogin(
    Session session,
    String userId,
  ) async {
    return await logEvent(
      session,
      AuthEventType.login,
      userId: userId,
      eventData: {'userId': userId},
    );
  }

  /// Log failed login event
  Future<AuthAuditLog> logLoginFailed(
    Session session, {
    String? email,
    String? reason,
  }) async {
    return await logEvent(
      session,
      AuthEventType.loginFailed,
      eventData: {
        if (email != null) 'email': email,
        if (reason != null) 'reason': reason,
      },
    );
  }

  /// Log logout event
  Future<AuthAuditLog> logLogout(
    Session session,
    String userId,
  ) async {
    return await logEvent(
      session,
      AuthEventType.logout,
      userId: userId,
      eventData: {'userId': userId},
    );
  }

  /// Log registration event
  Future<AuthAuditLog> logRegistration(
    Session session,
    String userId,
    String email,
  ) async {
    return await logEvent(
      session,
      AuthEventType.registration,
      userId: userId,
      eventData: {
        'userId': userId,
        'email': email,
      },
    );
  }

  /// Log password change event
  Future<AuthAuditLog> logPasswordChange(
    Session session,
    String userId,
  ) async {
    return await logEvent(
      session,
      AuthEventType.passwordChange,
      userId: userId,
      eventData: {'userId': userId},
    );
  }

  /// Log password reset event
  Future<AuthAuditLog> logPasswordReset(
    Session session,
    String userId,
  ) async {
    return await logEvent(
      session,
      AuthEventType.passwordReset,
      userId: userId,
      eventData: {'userId': userId},
    );
  }

  /// Log account blocked event
  Future<AuthAuditLog> logAccountBlocked(
    Session session,
    String userId,
    String blockedBy,
  ) async {
    return await logEvent(
      session,
      AuthEventType.accountBlocked,
      userId: userId,
      eventData: {
        'userId': userId,
        'blockedBy': blockedBy,
      },
    );
  }

  /// Log account deleted event
  Future<AuthAuditLog> logAccountDeleted(
    Session session,
    String userId,
    String deletedBy,
  ) async {
    return await logEvent(
      session,
      AuthEventType.accountDeleted,
      userId: userId,
      eventData: {
        'userId': userId,
        'deletedBy': deletedBy,
      },
    );
  }

  /// Log 2FA enabled event
  Future<AuthAuditLog> logTwoFactorEnabled(
    Session session,
    String userId,
  ) async {
    return await logEvent(
      session,
      AuthEventType.twoFactorEnabled,
      userId: userId,
      eventData: {'userId': userId},
    );
  }

  /// Log 2FA disabled event
  Future<AuthAuditLog> logTwoFactorDisabled(
    Session session,
    String userId,
  ) async {
    return await logEvent(
      session,
      AuthEventType.twoFactorDisabled,
      userId: userId,
      eventData: {'userId': userId},
    );
  }

  /// Log role assignment event
  Future<AuthAuditLog> logRoleAssigned(
    Session session,
    String userId,
    String roleName,
    String assignedBy,
  ) async {
    return await logEvent(
      session,
      AuthEventType.roleAssigned,
      userId: userId,
      eventData: {
        'userId': userId,
        'roleName': roleName,
        'assignedBy': assignedBy,
      },
    );
  }

  /// Query audit logs
  /// 
  /// [session] - Serverpod session
  /// [userId] - Optional user ID filter
  /// [eventType] - Optional event type filter
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  /// [limit] - Maximum number of results (default: 100)
  /// 
  /// Returns list of AuthAuditLog entries
  Future<List<AuthAuditLog>> queryAuditLogs(
    Session session, {
    String? userId,
    String? eventType,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
  }) async {
    // Build where clause using builder function
    WhereExpressionBuilder<AuthAuditLogTable>? whereBuilder;
    
    if (userId != null && eventType != null) {
      whereBuilder = (t) => t.userId.equals(userId) & t.eventType.equals(eventType);
    } else if (userId != null) {
      whereBuilder = (t) => t.userId.equals(userId);
    } else if (eventType != null) {
      whereBuilder = (t) => t.eventType.equals(eventType);
    }

    final logs = await AuthAuditLog.db.find(
      session,
      where: whereBuilder,
      orderBy: (t) => t.timestamp,
      orderDescending: true,
      limit: limit,
    );

    return logs;
  }
}
