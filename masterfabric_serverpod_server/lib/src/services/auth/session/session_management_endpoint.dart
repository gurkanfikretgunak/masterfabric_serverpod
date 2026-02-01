import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../../generated/protocol.dart';
import '../../../core/errors/base_error_handler.dart';
import '../../../core/errors/error_types.dart';
import '../../../core/logging/core_logger.dart';
import 'session_management_service.dart';
import '../core/auth_helper_service.dart';

/// Endpoint for session management
/// 
/// Provides endpoints for managing user sessions (list, revoke, etc.).
class SessionManagementEndpoint extends Endpoint {
  final SessionManagementService _sessionService = SessionManagementService();
  final AuthHelperService _authHelper = AuthHelperService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Get current session info from JWT token
  /// 
  /// Returns the current authenticated session information
  Future<SessionInfoResponse> getCurrentSession(Session session) async {
    final logger = CoreLogger(session);

    try {
      final authInfo = session.authenticated;
      if (authInfo == null) {
        throw AuthenticationError('Not authenticated');
      }

      final userId = await _authHelper.requireAuth(session);
      
      logger.info('Current session info requested', context: {
        'userId': userId.toString(),
      });

      return SessionInfoResponse(
        id: 'jwt-session', // JWT doesn't have session ID
        userId: userId.toString(),
        createdAt: DateTime.now(), // JWT doesn't track creation time
        lastUsedAt: DateTime.now(),
        expiresAt: null, // Token expiry managed by client
        method: 'jwt',
        metadataJson: jsonEncode({
          'scopes': authInfo.scopes.map((s) => s.name).toList(),
          'type': 'jwt_token',
        }),
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get current session: ${e.toString()}',
      );
    }
  }

  /// Get all active sessions for the current user
  /// 
  /// Note: With JWT auth, this returns server-side sessions if any exist.
  /// If no server-side sessions, returns current JWT session info.
  Future<List<SessionInfoResponse>> getActiveSessions(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Active sessions requested');

      final sessions = await _sessionService.getActiveSessions(session);

      // If no server-side sessions, return current JWT session
      if (sessions.isEmpty) {
        final currentSession = await getCurrentSession(session);
        return [currentSession];
      }

      logger.info('Active sessions retrieved', context: {
        'count': sessions.length,
      });

      return sessions.map((s) => SessionInfoResponse(
        id: s.id.toString(),
        userId: s.userId.toString(),
        createdAt: s.createdAt,
        lastUsedAt: s.lastUsedAt,
        expiresAt: s.expiresAt,
        method: s.method,
        metadataJson: s.metadata != null ? jsonEncode(s.metadata) : null,
      )).toList();
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get active sessions: ${e.toString()}',
      );
    }
  }

  /// Get session details by session ID
  /// 
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to retrieve
  /// 
  /// Returns SessionInfoResponse if found
  /// 
  /// Throws NotFoundError if session not found
  /// Throws AuthenticationError if not authenticated
  Future<SessionInfoResponse> getSession(
    Session session,
    String sessionId,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Session details requested', context: {
        'sessionId': sessionId,
      });

      final sessionInfo = await _sessionService.getSession(
        session,
        UuidValue.fromString(sessionId),
      );

      logger.info('Session details retrieved');

      return SessionInfoResponse(
        id: sessionInfo.id.toString(),
        userId: sessionInfo.userId.toString(),
        createdAt: sessionInfo.createdAt,
        lastUsedAt: sessionInfo.lastUsedAt,
        expiresAt: sessionInfo.expiresAt,
        method: sessionInfo.method,
        metadataJson: sessionInfo.metadata != null ? jsonEncode(sessionInfo.metadata) : null,
      );
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to get session: ${e.toString()}',
      );
    }
  }

  /// Revoke a specific session
  /// 
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to revoke
  /// 
  /// Throws NotFoundError if session not found
  /// Throws AuthenticationError if not authenticated
  Future<void> revokeSession(
    Session session,
    String sessionId,
  ) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Session revocation requested', context: {
        'sessionId': sessionId,
      });

      await _sessionService.revokeSession(
        session,
        UuidValue.fromString(sessionId),
      );

      logger.info('Session revoked successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to revoke session: ${e.toString()}',
      );
    }
  }

  /// Revoke all sessions except the current one
  /// 
  /// [session] - Serverpod session
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<void> revokeAllOtherSessions(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Revoke all other sessions requested');

      await _sessionService.revokeAllOtherSessions(session);

      logger.info('All other sessions revoked successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to revoke all other sessions: ${e.toString()}',
      );
    }
  }

  /// Revoke all sessions including current
  /// 
  /// [session] - Serverpod session
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<void> revokeAllSessions(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Revoke all sessions requested');

      await _sessionService.revokeAllSessions(session);

      logger.info('All sessions revoked successfully');
    } catch (e, stackTrace) {
      await _errorHandler.logError(session, e, stackTrace);

      if (e is AppException) {
        rethrow;
      }

      throw InternalServerError(
        'Failed to revoke all sessions: ${e.toString()}',
      );
    }
  }
}
