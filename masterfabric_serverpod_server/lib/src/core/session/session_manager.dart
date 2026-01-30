import 'package:serverpod/serverpod.dart';
import 'package:uuid/uuid.dart';
import 'session_data.dart';
import 'session_cache_provider.dart';

/// Session manager for handling user sessions
/// 
/// Provides high-scale ready session management using Serverpod's cache protocol.
/// Supports both local priority cache and Redis global cache for distributed systems.
class SessionManager {
  final SessionCacheProvider _cacheProvider;
  static const _uuid = Uuid();

  /// Default session TTL (30 minutes)
  final Duration defaultTtl;

  SessionManager({
    SessionCacheProvider? cacheProvider,
    Duration? defaultTtl,
  })  : _cacheProvider = cacheProvider ?? SessionCacheProvider(),
        defaultTtl = defaultTtl ?? const Duration(minutes: 30);

  /// Create a new session
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID to associate with the session
  /// [ttl] - Time to live for the session (defaults to [defaultTtl])
  /// [metadata] - Optional metadata to store with the session
  /// 
  /// Returns the created [SessionData]
  Future<SessionData> createSession(
    Session session,
    String userId, {
    Duration? ttl,
    Map<String, dynamic>? metadata,
  }) async {
    // Generate UUID using uuid package
    final sessionId = _uuid.v4();
    final expiresAt = ttl != null
        ? DateTime.now().add(ttl)
        : DateTime.now().add(defaultTtl);

    final sessionData = SessionData(
      userId: userId,
      sessionId: sessionId,
      expiresAt: expiresAt,
      metadata: metadata ?? {},
    );

    await _cacheProvider.storeSession(
      session,
      sessionData,
      ttl: ttl ?? defaultTtl,
    );

    return sessionData;
  }

  /// Get an existing session
  /// 
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to retrieve
  /// 
  /// Returns [SessionData] if found and not expired, null otherwise
  Future<SessionData?> getSession(
    Session session,
    String sessionId,
  ) async {
    final sessionData = await _cacheProvider.getSession(session, sessionId);
    
    if (sessionData == null) {
      return null;
    }

    if (sessionData.isExpired) {
      await invalidateSession(session, sessionId);
      return null;
    }

    return sessionData;
  }

  /// Update an existing session
  /// 
  /// Updates lastAccessedAt timestamp and optionally other fields
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to update
  /// [metadata] - Optional metadata updates (merged with existing)
  /// [ttl] - Optional new TTL (extends expiration)
  /// 
  /// Returns updated [SessionData] or null if session not found
  Future<SessionData?> updateSession(
    Session session,
    String sessionId, {
    Map<String, dynamic>? metadata,
    Duration? ttl,
  }) async {
    final existingSession = await getSession(session, sessionId);
    if (existingSession == null) {
      return null;
    }

    final updatedMetadata = {
      ...existingSession.metadata,
      if (metadata != null) ...metadata,
    };

    final expiresAt = ttl != null
        ? DateTime.now().add(ttl)
        : existingSession.expiresAt;

    final updatedSession = existingSession.copyWith(
      lastAccessedAt: DateTime.now(),
      expiresAt: expiresAt,
      metadata: updatedMetadata,
    );

    await _cacheProvider.updateSession(
      session,
      updatedSession,
      ttl: ttl ?? defaultTtl,
    );

    return updatedSession;
  }

  /// Refresh a session (extend expiration)
  /// 
  /// Updates lastAccessedAt and extends expiration time
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to refresh
  /// [ttl] - New TTL (defaults to [defaultTtl])
  /// 
  /// Returns refreshed [SessionData] or null if session not found
  Future<SessionData?> refreshSession(
    Session session,
    String sessionId, {
    Duration? ttl,
  }) async {
    return await updateSession(
      session,
      sessionId,
      ttl: ttl ?? defaultTtl,
    );
  }

  /// Invalidate (delete) a session
  /// 
  /// Removes session from cache
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to invalidate
  Future<void> invalidateSession(
    Session session,
    String sessionId,
  ) async {
    await _cacheProvider.removeSession(session, sessionId);
  }

  /// Check if a session exists and is valid
  /// 
  /// [session] - Serverpod session
  /// [sessionId] - Session ID to check
  /// 
  /// Returns true if session exists and is not expired
  Future<bool> isValidSession(
    Session session,
    String sessionId,
  ) async {
    final sessionData = await getSession(session, sessionId);
    return sessionData != null && !sessionData.isExpired;
  }
}
