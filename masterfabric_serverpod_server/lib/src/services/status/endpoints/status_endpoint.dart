import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';
import '../../../core/middleware/base/masterfabric_endpoint.dart';
import '../../../core/middleware/base/middleware_config.dart';
import '../../../core/rate_limit/services/rate_limit_service.dart';
import '../../app_config/services/app_config_service.dart';

/// Server start time - captured when the server first initializes.
/// 
/// This is set once when the first StatusEndpoint instance is created
/// and persists for the lifetime of the server process.
DateTime _serverStartTime = DateTime.now();

/// Whether the server start time has been initialized.
bool _serverStartTimeInitialized = false;

/// Initialize server start time (call from server.dart on startup)
void initializeServerStartTime() {
  if (!_serverStartTimeInitialized) {
    _serverStartTime = DateTime.now();
    _serverStartTimeInitialized = true;
  }
}

/// Get server start time
DateTime get serverStartTime => _serverStartTime;

/// Public status endpoint that returns server information.
///
/// This endpoint demonstrates the RBAC pattern with public methods.
/// It uses [RbacEndpointMixin] but exposes a public method using [skipAuth].
///
/// ## Features:
/// - Public endpoint (no authentication required)
/// - Cached server info for performance
/// - Returns version, environment, server time, server start time, uptime
///
/// ## Usage from client:
/// ```dart
/// final status = await client.status.getStatus();
/// print('Server: ${status.appName} v${status.appVersion}');
/// print('Environment: ${status.environment}');
/// print('Uptime: ${status.uptime}');
/// ```
///
/// ## Role Requirements:
/// - `getStatus`: Requires 'public' role (unauthenticated access allowed)
class StatusEndpoint extends MasterfabricEndpoint with RbacEndpointMixin {
  /// Endpoint-level role requirements.
  ///
  /// This endpoint uses the 'public' role, which is the default role
  /// for unauthenticated access in the RBAC system.
  @override
  List<String> get requiredRoles => ['public'];

  /// No method-specific role requirements for this endpoint.
  @override
  Map<String, List<String>> get methodRoles => {};

  /// No "require all" flags needed for this endpoint.
  @override
  Map<String, bool> get methodRequireAllRoles => {};

  /// App config service for retrieving server settings
  final AppConfigService _configService = AppConfigService();

  /// Cache TTL for static server info
  static const Duration _cacheTtl = Duration(minutes: 5);

  /// Cache key for server info
  static const String _cacheKey = 'status:server_info';

  // ============================================================
  // PUBLIC METHODS (no authentication required)
  // ============================================================

  /// Get server status information.
  ///
  /// **Required Roles:** 'public' (unauthenticated access allowed)
  ///
  /// Returns [ServerStatus] containing:
  /// - appName: Application name
  /// - appVersion: Application version
  /// - environment: Current environment (development/staging/production)
  /// - serverTime: Current server timestamp
  /// - serverStartTime: When the server was started
  /// - uptime: Human-readable uptime string
  /// - clientIp: Requesting client's IP address (if available)
  /// - locale: Detected locale from request
  /// - debugMode: Whether debug mode is enabled
  /// - maintenanceMode: Whether maintenance mode is active
  ///
  /// This endpoint is publicly accessible without authentication.
  /// Rate limited to 60 requests per minute.
  Future<ServerStatus> getStatus(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'getStatus',
      config: EndpointMiddlewareConfig(
        skipAuth: true, // Public endpoint - no auth required
        customRateLimit: RateLimitConfig(
          maxRequests: 60,
          windowDuration: Duration(minutes: 1),
          keyPrefix: 'status_public',
        ),
      ),
      handler: () async {
        // Get current server time
        final serverTime = DateTime.now();

        // Calculate uptime
        final uptimeDuration = serverTime.difference(_serverStartTime);
        final uptime = _formatUptime(uptimeDuration);

        // Try to get cached server info
        AppSettings? cachedSettings = await _loadCachedSettings(session);

        // If not cached, load from config service
        if (cachedSettings == null) {
          cachedSettings = await _loadAndCacheSettings(session);
        }

        // Extract client IP from session (best effort)
        final clientIp = _extractClientIp(session);

        // Extract locale from session (best effort)
        final locale = _extractLocale(session);

        return ServerStatus(
          appName: cachedSettings?.appName ?? 'MasterFabric',
          appVersion: cachedSettings?.appVersion ?? '1.0.0',
          environment: cachedSettings?.environment ?? _getEnvironment(),
          serverTime: serverTime,
          serverStartTime: _serverStartTime,
          uptime: uptime,
          clientIp: clientIp,
          locale: locale,
          debugMode: cachedSettings?.debugMode ?? false,
          maintenanceMode: cachedSettings?.maintenanceMode ?? true,
        );
      },
    );
  }

  /// Format uptime duration into human-readable string
  String _formatUptime(Duration duration) {
    if (duration.inDays > 0) {
      final days = duration.inDays;
      final hours = duration.inHours % 24;
      final minutes = duration.inMinutes % 60;
      return '${days}d ${hours}h ${minutes}m';
    } else if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    } else if (duration.inMinutes > 0) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds % 60;
      return '${minutes}m ${seconds}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  // ============================================================
  // PRIVATE HELPER METHODS
  // ============================================================

  /// Load cached app settings
  /// 
  /// Prioritizes Redis cache (global) over local cache to ensure
  /// real-time updates when Redis is manually updated (e.g., maintenance mode changes).
  /// Falls back to local cache if Redis is unavailable for performance.
  Future<AppSettings?> _loadCachedSettings(Session session) async {
    try {
      // Try global cache (Redis) FIRST - this allows real-time updates
      // when Redis is manually updated (e.g., maintenance mode changes)
      var cached = await session.caches.global.get<AppSettings>(_cacheKey);
      if (cached != null) {
        // Update local cache with fresh data from Redis for faster subsequent access
        await session.caches.localPrio.put(
          _cacheKey,
          cached,
          lifetime: _cacheTtl,
        );
        return cached;
      }

      // Fallback to local priority cache if Redis is not available
      // This ensures performance even if Redis is temporarily unavailable
      cached = await session.caches.localPrio.get<AppSettings>(_cacheKey);
      if (cached != null) return cached;

      return null;
    } catch (e) {
      // Cache miss or error - try local cache as fallback
      try {
        return await session.caches.localPrio.get<AppSettings>(_cacheKey);
      } catch (_) {
        return null;
      }
    }
  }

  /// Load settings from config service and cache them
  Future<AppSettings?> _loadAndCacheSettings(Session session) async {
    try {
      final environment = _getEnvironment();
      final config = await _configService.getConfigForEnvironment(
        session,
        environment,
      );

      final settings = config.appSettings;

      // Cache in local priority cache
      await session.caches.localPrio.put(
        _cacheKey,
        settings,
        lifetime: _cacheTtl,
      );

      // Cache in global cache (Redis)
      await session.caches.global.put(
        _cacheKey,
        settings,
        lifetime: _cacheTtl,
      );

      return settings;
    } catch (e) {
      // If config service fails, return null (will use defaults)
      session.log('Failed to load app settings: $e', level: LogLevel.warning);
      return null;
    }
  }

  /// Get current environment from Serverpod config
  String _getEnvironment() {
    // Try to get from environment variable first
    final envVar =
        const String.fromEnvironment('SERVERPOD_ENV', defaultValue: '');
    if (envVar.isNotEmpty) return envVar;

    // Default to development
    return 'development';
  }

  /// Extract client IP from session
  ///
  /// Tries to extract IP from:
  /// 1. X-Forwarded-For header (when behind proxy)
  /// 2. X-Real-IP header (nginx)
  /// 3. Remote address from connection
  String? _extractClientIp(Session session) {
    try {
      // For HTTP requests, try to get from headers
      // Note: Serverpod abstracts this, so we do our best

      // In a real implementation, you'd access the underlying HTTP request
      // For now, return the session's remote address if available
      return null; // Will be enhanced when HTTP context is available
    } catch (e) {
      return null;
    }
  }

  /// Extract locale from session
  ///
  /// Tries to extract from Accept-Language header
  String? _extractLocale(Session session) {
    try {
      // In a real implementation, you'd parse Accept-Language header
      // For now, return default
      return 'en';
    } catch (e) {
      return 'en';
    }
  }
}
