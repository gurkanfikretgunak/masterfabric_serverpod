import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/logging/core_logger.dart';

/// Service for managing user app settings
/// 
/// Handles CRUD operations for user-specific app settings.
class UserAppSettingsService {
  /// Cache TTL for user settings
  static const Duration _cacheTtl = Duration(minutes: 10);

  /// Get or create user app settings
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// 
  /// Returns user's app settings, creating default if not exists
  Future<UserAppSettings> getOrCreateSettings(
    Session session,
    String userId,
  ) async {
    final logger = CoreLogger(session);

    // Try cache first
    final cacheKey = _getCacheKey(userId);
    final cached = await session.caches.local.get<UserAppSettings>(cacheKey);
    if (cached != null) {
      logger.debug('Settings loaded from cache', context: {'userId': userId});
      return cached;
    }

    // Try database
    final existing = await UserAppSettings.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final settings = existing.first;
      // Cache it
      await session.caches.local.put(cacheKey, settings, lifetime: _cacheTtl);
      return settings;
    }

    // Create default settings
    final now = DateTime.now();
    final defaultSettings = UserAppSettings(
      userId: userId,
      pushNotifications: true,
      emailNotifications: false,
      notificationSound: true,
      analytics: true,
      crashReports: true,
      twoFactorEnabled: false,
      accountDeletionRequested: null,
      createdAt: now,
      updatedAt: now,
    );

    final created = await UserAppSettings.db.insertRow(session, defaultSettings);
    
    // Cache it
    await session.caches.local.put(cacheKey, created, lifetime: _cacheTtl);

    logger.info('Created default settings for user', context: {'userId': userId});

    return created;
  }

  /// Update user app settings
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  /// [request] - Update request with new values
  /// 
  /// Returns updated settings
  Future<UserAppSettings> updateSettings(
    Session session,
    String userId,
    UserAppSettingsUpdateRequest request,
  ) async {
    final logger = CoreLogger(session);

    // Get existing settings
    final existing = await getOrCreateSettings(session, userId);

    // Build updated settings
    final updated = existing.copyWith(
      pushNotifications: request.pushNotifications ?? existing.pushNotifications,
      emailNotifications: request.emailNotifications ?? existing.emailNotifications,
      notificationSound: request.notificationSound ?? existing.notificationSound,
      analytics: request.analytics ?? existing.analytics,
      crashReports: request.crashReports ?? existing.crashReports,
      twoFactorEnabled: request.twoFactorEnabled ?? existing.twoFactorEnabled,
      updatedAt: DateTime.now(),
    );

    // Save to database
    final saved = await UserAppSettings.db.updateRow(session, updated);

    // Update cache
    final cacheKey = _getCacheKey(userId);
    await session.caches.local.put(cacheKey, saved, lifetime: _cacheTtl);

    logger.info('Settings updated', context: {
      'userId': userId,
      'fields': _getChangedFields(existing, request),
    });

    return saved;
  }

  /// Delete user app settings (for account deletion)
  /// 
  /// [session] - Serverpod session
  /// [userId] - User ID
  Future<void> deleteSettings(
    Session session,
    String userId,
  ) async {
    final logger = CoreLogger(session);

    await UserAppSettings.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );

    // Clear cache
    final cacheKey = _getCacheKey(userId);
    await session.caches.local.invalidateKey(cacheKey);

    logger.info('Settings deleted', context: {'userId': userId});
  }

  /// Get cache key for user settings
  String _getCacheKey(String userId) {
    return 'user_app_settings:$userId';
  }

  /// Get list of changed fields for logging
  List<String> _getChangedFields(
    UserAppSettings existing,
    UserAppSettingsUpdateRequest request,
  ) {
    final changed = <String>[];
    
    if (request.pushNotifications != null &&
        request.pushNotifications != existing.pushNotifications) {
      changed.add('pushNotifications');
    }
    if (request.emailNotifications != null &&
        request.emailNotifications != existing.emailNotifications) {
      changed.add('emailNotifications');
    }
    if (request.notificationSound != null &&
        request.notificationSound != existing.notificationSound) {
      changed.add('notificationSound');
    }
    if (request.analytics != null && request.analytics != existing.analytics) {
      changed.add('analytics');
    }
    if (request.crashReports != null &&
        request.crashReports != existing.crashReports) {
      changed.add('crashReports');
    }
    if (request.twoFactorEnabled != null &&
        request.twoFactorEnabled != existing.twoFactorEnabled) {
      changed.add('twoFactorEnabled');
    }

    return changed;
  }
}
