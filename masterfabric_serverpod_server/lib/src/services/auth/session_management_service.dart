import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import '../../generated/protocol.dart';
import '../../core/errors/error_types.dart';
import 'auth_helper_service.dart';

/// Session information model
class SessionInfo {
  final UuidValue id;
  final UuidValue userId;
  final DateTime createdAt;
  final DateTime lastUsedAt;
  final DateTime? expiresAt;
  final String method;
  final Map<String, dynamic>? metadata;

  SessionInfo({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.lastUsedAt,
    this.expiresAt,
    required this.method,
    this.metadata,
  });
}

/// Session management service
/// 
/// Handles session operations including listing, retrieving, and revoking sessions.
class SessionManagementService {
  final AuthHelperService _authHelper = AuthHelperService();

  /// Get current session ID for the user
  Future<UuidValue?> _getCurrentSessionId(Session session, UuidValue userId) async {
    final sessions = await ServerSideSession.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
      orderBy: (t) => t.lastUsedAt,
      orderDescending: true,
      limit: 1,
    );
    return sessions.isNotEmpty ? sessions.first.id : null;
  }

  /// Get all active sessions for the current user
  /// 
  /// [session] - Serverpod session
  /// 
  /// Returns list of SessionInfo for all active sessions
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<List<SessionInfo>> getActiveSessions(Session session) async {
    final userId = await _authHelper.requireAuth(session);

    // Get all sessions for the user using database query
    final sessions = await ServerSideSession.db.find(
      session,
      where: (t) => t.authUserId.equals(userId),
    );

    // Filter to only active (non-expired) sessions
    final now = DateTime.now();
    final activeSessions = sessions.where((s) {
      if (s.expiresAt != null && s.expiresAt!.isBefore(now)) {
        return false;
      }
      return true;
    }).toList();

    // Convert to SessionInfo (filter out sessions without authUserId)
    return activeSessions
        .where((s) => s.authUserId != null)
        .map((s) {
      return SessionInfo(
        id: s.id!,
        userId: s.authUserId!,
        createdAt: s.createdAt,
        lastUsedAt: s.lastUsedAt,
        expiresAt: s.expiresAt,
        method: s.method,
        metadata: {
          'scopeNames': s.scopeNames,
        },
      );
    }).toList();
  }

  /// Get session details by session ID
  /// 
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to retrieve
  /// 
  /// Returns SessionInfo if found and belongs to current user
  /// 
  /// Throws NotFoundError if session not found
  /// Throws AuthenticationError if not authenticated or session doesn't belong to user
  Future<SessionInfo> getSession(
    Session session,
    UuidValue sessionId,
  ) async {
    final userId = await _authHelper.requireAuth(session);

    final serverSession = await ServerSideSession.db.findById(session, sessionId);

    if (serverSession == null) {
      throw NotFoundError(
        'Session not found',
        details: {'sessionId': sessionId.toString()},
      );
    }

    // Verify session belongs to current user
    if (serverSession.authUserId != userId) {
      throw AuthenticationError(
        'Session does not belong to current user',
        details: {'sessionId': sessionId.toString()},
      );
    }

    if (serverSession.authUserId == null) {
      throw NotFoundError(
        'Session has no associated user',
        details: {'sessionId': sessionId.toString()},
      );
    }

    return SessionInfo(
      id: serverSession.id!,
      userId: serverSession.authUserId!,
      createdAt: serverSession.createdAt,
      lastUsedAt: serverSession.lastUsedAt,
      expiresAt: serverSession.expiresAt,
      method: serverSession.method,
      metadata: {
        'scopeNames': serverSession.scopeNames,
      },
    );
  }

  /// Revoke a specific session
  /// 
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to revoke
  /// 
  /// Throws NotFoundError if session not found
  /// Throws AuthenticationError if not authenticated or session doesn't belong to user
  Future<void> revokeSession(
    Session session,
    UuidValue sessionId,
  ) async {
    final userId = await _authHelper.requireAuth(session);

    // Verify session exists and belongs to user
    final sessionToVerify = await getSession(session, sessionId);
    
    // Get session from database to delete
    final serverSession = await ServerSideSession.db.findById(session, sessionId);
    if (serverSession != null) {
      await ServerSideSession.db.deleteRow(session, serverSession);
    }

    session.log(
      'Session revoked - sessionId: ${sessionId.toString()}',
      level: LogLevel.info,
    );
  }

  /// Revoke all sessions except the current one
  /// 
  /// [session] - Serverpod session
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<void> revokeAllOtherSessions(Session session) async {
    final userId = await _authHelper.requireAuth(session);
    // Note: Serverpod doesn't expose sessionId directly
    // We'll identify current session by finding the most recent one
    final currentSessionId = await _getCurrentSessionId(session, userId);

    // Get all active sessions
    final activeSessions = await getActiveSessions(session);

    // Get current session ID (already retrieved above)

    // Revoke all except current
    for (final sessionInfo in activeSessions) {
      if (currentSessionId == null || sessionInfo.id != currentSessionId) {
        await revokeSession(session, sessionInfo.id);
      }
    }

    session.log(
      'All other sessions revoked - revokedCount: ${activeSessions.length - 1}',
      level: LogLevel.info,
    );
  }

  /// Revoke all sessions including current
  /// 
  /// [session] - Serverpod session
  /// 
  /// Throws AuthenticationError if not authenticated
  Future<void> revokeAllSessions(Session session) async {
    final userId = await _authHelper.requireAuth(session);

    // Get all active sessions
    final activeSessions = await getActiveSessions(session);

    // Revoke all sessions
    for (final sessionInfo in activeSessions) {
      final sessionToDelete = await ServerSideSession.db.findById(session, sessionInfo.id);
      if (sessionToDelete != null) {
        await ServerSideSession.db.deleteRow(session, sessionToDelete);
      }
    }

    session.log(
      'All sessions revoked - revokedCount: ${activeSessions.length}',
      level: LogLevel.info,
    );
  }
}
