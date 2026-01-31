import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Health status for a service
enum ServiceStatus {
  healthy,
  degraded,
  unhealthy,
  unknown,
}

/// Individual service health info
class ServiceHealth {
  final String name;
  final ServiceStatus status;
  final int? latencyMs;
  final String? message;
  final DateTime checkedAt;

  ServiceHealth({
    required this.name,
    required this.status,
    this.latencyMs,
    this.message,
    DateTime? checkedAt,
  }) : checkedAt = checkedAt ?? DateTime.now();

  bool get isHealthy => status == ServiceStatus.healthy;
}

/// Overall health status
class HealthStatus {
  final ServiceStatus overall;
  final List<ServiceHealth> services;
  final DateTime checkedAt;
  final int totalLatencyMs;

  HealthStatus({
    required this.overall,
    required this.services,
    required this.totalLatencyMs,
    DateTime? checkedAt,
  }) : checkedAt = checkedAt ?? DateTime.now();

  int get healthyCount => services.where((s) => s.isHealthy).length;
  int get totalCount => services.length;
  double get healthPercentage => totalCount > 0 ? healthyCount / totalCount : 0;
}

/// Health monitoring service for checking server and service status
class HealthService extends ChangeNotifier {
  static HealthService? _instance;
  static HealthService get instance => _instance ??= HealthService._();

  HealthService._();

  Client? _client;
  Timer? _autoCheckTimer;
  HealthStatus? _lastStatus;
  bool _isChecking = false;

  HealthStatus? get lastStatus => _lastStatus;
  bool get isChecking => _isChecking;
  bool get isHealthy => _lastStatus?.overall == ServiceStatus.healthy;

  /// Initialize with client
  void initialize(Client client) {
    _client = client;
  }

  /// Start automatic health checks
  void startAutoCheck({Duration interval = const Duration(seconds: 30)}) {
    stopAutoCheck();
    _autoCheckTimer = Timer.periodic(interval, (_) => checkHealth());
    // Do initial check
    checkHealth();
  }

  /// Stop automatic health checks
  void stopAutoCheck() {
    _autoCheckTimer?.cancel();
    _autoCheckTimer = null;
  }

  /// Perform health check on all services
  Future<HealthStatus> checkHealth() async {
    if (_client == null) {
      return HealthStatus(
        overall: ServiceStatus.unknown,
        services: [],
        totalLatencyMs: 0,
      );
    }

    _isChecking = true;
    notifyListeners();

    final services = <ServiceHealth>[];
    final startTime = DateTime.now();

    // Check API Server connectivity
    services.add(await _checkApiServer());

    // Check Greeting endpoint (tests basic endpoint + rate limiting)
    services.add(await _checkGreetingService());

    // Check Translation service
    services.add(await _checkTranslationService());

    // Check App Config service
    services.add(await _checkAppConfigService());

    // Check Auth service (if authenticated)
    services.add(await _checkAuthService());

    final totalLatency = DateTime.now().difference(startTime).inMilliseconds;

    // Determine overall status
    final healthyCount = services.where((s) => s.isHealthy).length;
    final degradedCount = services.where((s) => s.status == ServiceStatus.degraded).length;
    
    ServiceStatus overall;
    if (healthyCount == services.length) {
      overall = ServiceStatus.healthy;
    } else if (healthyCount > 0 || degradedCount > 0) {
      overall = ServiceStatus.degraded;
    } else {
      overall = ServiceStatus.unhealthy;
    }

    _lastStatus = HealthStatus(
      overall: overall,
      services: services,
      totalLatencyMs: totalLatency,
    );

    _isChecking = false;
    notifyListeners();

    return _lastStatus!;
  }

  /// Check API server connectivity
  Future<ServiceHealth> _checkApiServer() async {
    final start = DateTime.now();
    try {
      // Simple connectivity check - try to reach the server
      await _client!.greeting.hello('health-check');
      final latency = DateTime.now().difference(start).inMilliseconds;
      
      return ServiceHealth(
        name: 'API Server',
        status: latency < 1000 ? ServiceStatus.healthy : ServiceStatus.degraded,
        latencyMs: latency,
        message: 'Connected',
      );
    } catch (e) {
      return ServiceHealth(
        name: 'API Server',
        status: ServiceStatus.unhealthy,
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: e.toString().split(':').first,
      );
    }
  }

  /// Check greeting service (includes rate limit test)
  Future<ServiceHealth> _checkGreetingService() async {
    final start = DateTime.now();
    try {
      final response = await _client!.greeting.hello('health-check');
      final latency = DateTime.now().difference(start).inMilliseconds;
      
      // Check rate limit status
      final remaining = response.rateLimitRemaining;
      final limit = response.rateLimitMax;
      
      ServiceStatus status;
      String message;
      
      if (remaining > limit * 0.5) {
        status = ServiceStatus.healthy;
        message = 'OK ($remaining/$limit requests remaining)';
      } else if (remaining > 0) {
        status = ServiceStatus.degraded;
        message = 'Rate limit warning ($remaining/$limit)';
      } else {
        status = ServiceStatus.degraded;
        message = 'Rate limited';
      }
      
      return ServiceHealth(
        name: 'Greeting Service',
        status: status,
        latencyMs: latency,
        message: message,
      );
    } on RateLimitException catch (e) {
      return ServiceHealth(
        name: 'Greeting Service',
        status: ServiceStatus.degraded,
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: 'Rate limited (retry in ${e.retryAfterSeconds}s)',
      );
    } catch (e) {
      return ServiceHealth(
        name: 'Greeting Service',
        status: ServiceStatus.unhealthy,
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: e.toString().split(':').first,
      );
    }
  }

  /// Check translation service
  Future<ServiceHealth> _checkTranslationService() async {
    final start = DateTime.now();
    try {
      await _client!.translation.getTranslations(locale: 'en');
      final latency = DateTime.now().difference(start).inMilliseconds;
      
      return ServiceHealth(
        name: 'Translation Service',
        status: ServiceStatus.healthy,
        latencyMs: latency,
        message: 'Translations available',
      );
    } catch (e) {
      return ServiceHealth(
        name: 'Translation Service',
        status: ServiceStatus.unhealthy,
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: e.toString().split(':').first,
      );
    }
  }

  /// Check app config service
  Future<ServiceHealth> _checkAppConfigService() async {
    final start = DateTime.now();
    try {
      await _client!.appConfig.getConfig();
      final latency = DateTime.now().difference(start).inMilliseconds;
      
      return ServiceHealth(
        name: 'App Config Service',
        status: ServiceStatus.healthy,
        latencyMs: latency,
        message: 'Config loaded',
      );
    } catch (e) {
      return ServiceHealth(
        name: 'App Config Service',
        status: ServiceStatus.unhealthy,
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: e.toString().split(':').first,
      );
    }
  }

  /// Check auth service by trying to call password validation endpoint
  /// This endpoint doesn't require authentication but tests auth infrastructure
  Future<ServiceHealth> _checkAuthService() async {
    final start = DateTime.now();
    try {
      // Try password validation endpoint - tests auth infrastructure
      await _client!.passwordManagement.validatePasswordStrength(
        password: 'TestPass123!',
      );
      final latency = DateTime.now().difference(start).inMilliseconds;
      
      return ServiceHealth(
        name: 'Auth Service',
        status: ServiceStatus.healthy,
        latencyMs: latency,
        message: 'Auth endpoints available',
      );
    } catch (e) {
      return ServiceHealth(
        name: 'Auth Service',
        status: ServiceStatus.degraded,
        latencyMs: DateTime.now().difference(start).inMilliseconds,
        message: e.toString().split(':').first,
      );
    }
  }

  @override
  void dispose() {
    stopAutoCheck();
    super.dispose();
  }
}
