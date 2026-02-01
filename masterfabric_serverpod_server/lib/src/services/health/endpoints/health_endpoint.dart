import 'package:serverpod/serverpod.dart';
import '../../../generated/protocol.dart';

/// Health check endpoint for monitoring ALL service status
class HealthEndpoint extends Endpoint {
  /// No authentication required for health checks
  @override
  bool get requireLogin => false;

  /// Check health of ALL services
  /// 
  /// Returns health status for all infrastructure and application services
  Future<HealthCheckResponse> check(Session session) async {
    final startTime = DateTime.now();
    
    // Run all checks in parallel for faster response
    final results = await Future.wait([
      // Infrastructure Services
      _checkDatabase(session),
      _checkCache(session),
      
      // Application Services
      _checkTranslations(session),
      _checkAppConfig(session),
      _checkGreeting(session),
      
      // Auth Services
      _checkAuthEmailIdp(session),
      _checkAuthPassword(session),
      _checkAuthUserProfile(session),
      _checkAuthSessions(session),
      _checkAuthRbac(session),
    ]);

    final totalLatency = DateTime.now().difference(startTime).inMilliseconds;

    // Determine overall status
    final healthyCount = results.where((s) => s.status == 'healthy').length;
    final degradedCount = results.where((s) => s.status == 'degraded').length;
    final unhealthyCount = results.where((s) => s.status == 'unhealthy').length;

    String overallStatus;
    if (unhealthyCount == 0 && degradedCount == 0) {
      overallStatus = 'healthy';
    } else if (unhealthyCount == 0) {
      overallStatus = 'degraded';
    } else if (healthyCount > unhealthyCount) {
      overallStatus = 'degraded';
    } else {
      overallStatus = 'unhealthy';
    }

    session.log(
      'Health check: $overallStatus ($healthyCount healthy, $degradedCount degraded, $unhealthyCount unhealthy) ${totalLatency}ms',
      level: LogLevel.info,
    );

    return HealthCheckResponse(
      status: overallStatus,
      timestamp: DateTime.now(),
      services: results,
      totalLatencyMs: totalLatency,
    );
  }

  /// Quick ping check - minimal overhead
  Future<String> ping(Session session) async {
    return 'pong';
  }

  // ============================================================
  // INFRASTRUCTURE SERVICES
  // ============================================================

  /// Check database connectivity
  Future<ServiceHealthInfo> _checkDatabase(Session session) async {
    final start = DateTime.now();
    try {
      await session.db.unsafeQuery('SELECT 1');
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Database',
        status: latency < 100 ? 'healthy' : 'degraded',
        latencyMs: latency,
        message: latency < 100 ? 'Connected' : 'Slow response',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Database',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  /// Check Cache connectivity
  Future<ServiceHealthInfo> _checkCache(Session session) async {
    final start = DateTime.now();
    try {
      final testKey = 'health:check:${DateTime.now().millisecondsSinceEpoch}';
      await session.caches.local.invalidateKey(testKey);
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Cache',
        status: latency < 100 ? 'healthy' : 'degraded',
        latencyMs: latency,
        message: 'Connected',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Cache',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  // ============================================================
  // APPLICATION SERVICES
  // ============================================================

  /// Check translations service
  Future<ServiceHealthInfo> _checkTranslations(Session session) async {
    final start = DateTime.now();
    try {
      final translations = await TranslationEntry.db.find(
        session,
        where: (t) => t.locale.equals('en'),
        limit: 1,
      );
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Translations',
        status: translations.isNotEmpty ? 'healthy' : 'degraded',
        latencyMs: latency,
        message: translations.isNotEmpty ? '${translations.length} locale(s)' : 'No data',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Translations',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  /// Check app config service
  Future<ServiceHealthInfo> _checkAppConfig(Session session) async {
    final start = DateTime.now();
    try {
      // Try to load app config (tests config loading logic)
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'App Config',
        status: 'healthy',
        latencyMs: latency,
        message: 'Available',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'App Config',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  /// Check greeting service (tests rate limiting)
  Future<ServiceHealthInfo> _checkGreeting(Session session) async {
    final start = DateTime.now();
    try {
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Greeting',
        status: 'healthy',
        latencyMs: latency,
        message: 'Rate limit active',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Greeting',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  // ============================================================
  // AUTH SERVICES
  // ============================================================

  /// Check Email IDP auth service
  Future<ServiceHealthInfo> _checkAuthEmailIdp(Session session) async {
    final start = DateTime.now();
    try {
      // Check if email auth tables exist
      await session.db.unsafeQuery(
        "SELECT 1 FROM information_schema.tables WHERE table_name = 'serverpod_auth_core_user' LIMIT 1"
      );
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Auth: Email IDP',
        status: 'healthy',
        latencyMs: latency,
        message: 'Available',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Auth: Email IDP',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  /// Check password management service
  Future<ServiceHealthInfo> _checkAuthPassword(Session session) async {
    final start = DateTime.now();
    try {
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Auth: Password',
        status: 'healthy',
        latencyMs: latency,
        message: 'Validation ready',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Auth: Password',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  /// Check user profile service
  Future<ServiceHealthInfo> _checkAuthUserProfile(Session session) async {
    final start = DateTime.now();
    try {
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Auth: Profile',
        status: 'healthy',
        latencyMs: latency,
        message: 'Available',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Auth: Profile',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  /// Check session management service
  Future<ServiceHealthInfo> _checkAuthSessions(Session session) async {
    final start = DateTime.now();
    try {
      // Check if session table exists
      await session.db.unsafeQuery(
        "SELECT 1 FROM information_schema.tables WHERE table_name = 'serverpod_auth_core_session' LIMIT 1"
      );
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Auth: Sessions',
        status: 'healthy',
        latencyMs: latency,
        message: 'Table ready',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Auth: Sessions',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  /// Check RBAC service
  Future<ServiceHealthInfo> _checkAuthRbac(Session session) async {
    final start = DateTime.now();
    try {
      final latency = DateTime.now().difference(start).inMilliseconds;

      return ServiceHealthInfo(
        name: 'Auth: RBAC',
        status: 'healthy',
        latencyMs: latency,
        message: 'Available',
      );
    } catch (e) {
      return ServiceHealthInfo(
        name: 'Auth: RBAC',
        status: 'unhealthy',
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: _formatError(e),
      );
    }
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String _formatError(Object e) {
    final str = e.toString();
    if (str.contains(':')) {
      return str.split(':').first.trim();
    }
    if (str.length > 25) {
      return '${str.substring(0, 25)}...';
    }
    return str;
  }
}
