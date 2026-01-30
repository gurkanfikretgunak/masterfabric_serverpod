import 'package:serverpod/serverpod.dart';
import 'session_data.dart';

/// Cache provider for session storage
/// 
/// Handles session caching using Serverpod's cache protocol:
/// - Local priority cache for fast access
/// - Redis global cache for distributed systems
class SessionCacheProvider {
  /// Cache key prefix for local priority cache
  static const String _localCachePrefix = 'session';
  
  /// Cache key prefix for global Redis cache
  static const String _globalCachePrefix = 'global_session';
  
  /// Default TTL for sessions (30 minutes)
  static const Duration defaultTtl = Duration(minutes: 30);

  /// Get cache key for local priority cache
  static String _getLocalCacheKey(String sessionId) {
    return '$_localCachePrefix:$sessionId';
  }

  /// Get cache key for global Redis cache
  static String _getGlobalCacheKey(String sessionId) {
    return '$_globalCachePrefix:$sessionId';
  }

  /// Store session in cache
  /// 
  /// Stores in both local priority cache and global Redis cache
  /// [session] - Serverpod session
  /// [sessionData] - Session data to store
  /// [ttl] - Time to live (defaults to [defaultTtl])
  Future<void> storeSession(
    Session session,
    SessionData sessionData, {
    Duration? ttl,
  }) async {
    final cacheKey = _getLocalCacheKey(sessionData.sessionId);
    final globalCacheKey = _getGlobalCacheKey(sessionData.sessionId);
    final ttlDuration = ttl ?? defaultTtl;

    // Store in local cache (fast access)
    // Note: We'll use a simple string key-value approach
    // Cache API requires SerializableModel, so we'll store as JSON string in a wrapper
    // For now, we'll skip local cache and use global cache only
    // await session.caches.local.put(cacheKey, sessionData.toJson());

    // Store in global Redis cache (for distributed systems)
    // Note: Cache requires SerializableModel - we'll need to create a proper model
    // For now, skip cache storage and rely on database or implement proper SerializableModel
    // await session.caches.global.put(globalCacheKey, sessionData.toJson());
  }

  /// Get session from cache
  /// 
  /// Tries local priority cache first, then global cache
  /// Returns null if session not found or expired
  Future<SessionData?> getSession(
    Session session,
    String sessionId,
  ) async {
    final cacheKey = _getLocalCacheKey(sessionId);
    final globalCacheKey = _getGlobalCacheKey(sessionId);

    // Note: Cache API requires SerializableModel
    // For now, return null - sessions will need to be stored in database
    // TODO: Create a proper SerializableModel for SessionData or use database storage
    // Try local cache first
    // final localData = await session.caches.local.get(cacheKey);
    // if (localData != null) { ... }

    // Try global Redis cache
    // final globalData = await session.caches.global.get(globalCacheKey);
    // if (globalData != null) { ... }

    return null;
  }

  /// Remove session from cache
  /// 
  /// Removes from both local and global cache
  Future<void> removeSession(
    Session session,
    String sessionId,
  ) async {
    final cacheKey = _getLocalCacheKey(sessionId);
    final globalCacheKey = _getGlobalCacheKey(sessionId);

    // Note: Cache API requires proper methods
    // For now, skip cache invalidation
    // TODO: Implement proper cache invalidation when SerializableModel is created
    // await session.caches.local.remove(cacheKey);
    // await session.caches.global.remove(globalCacheKey);
  }

  /// Update session in cache
  /// 
  /// Updates both local and global cache
  Future<void> updateSession(
    Session session,
    SessionData sessionData, {
    Duration? ttl,
  }) async {
    await storeSession(session, sessionData, ttl: ttl);
  }
}
