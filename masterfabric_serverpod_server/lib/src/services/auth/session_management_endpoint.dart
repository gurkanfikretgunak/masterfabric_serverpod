import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/errors/base_error_handler.dart';
import '../../core/errors/error_types.dart';
import '../../core/logging/core_logger.dart';
import 'session_management_service.dart';

/// Endpoint for session management
/// 
/// Provides endpoints for managing user sessions (list, revoke, etc.).
class SessionManagementEndpoint extends Endpoint {
  final SessionManagementService _sessionService = SessionManagementService();
  final DefaultErrorHandler _errorHandler = DefaultErrorHandler();

  /// Require authentication for all methods
  @override
  bool get requireLogin => true;

  /// Get all active sessions for the current user
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns list of SessionInfoResponse for all active sessions
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<List<SessionInfoResponse>> getActiveSessions(Session session) async {
    final logger = CoreLogger(session);

    try {
      logger.info('Active sessions requested');

      final sessions = await _sessionService.getActiveSessions(session);

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
