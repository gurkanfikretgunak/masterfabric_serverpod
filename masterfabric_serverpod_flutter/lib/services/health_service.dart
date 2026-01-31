import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Health status enum for UI
enum ServiceStatus {
  healthy,
  degraded,
  unhealthy,
  unknown,
}

/// Health monitoring service - calls server-side health endpoint
class HealthService extends ChangeNotifier {
  static HealthService? _instance;
  static HealthService get instance => _instance ??= HealthService._();

  HealthService._();

  Client? _client;
  Timer? _autoCheckTimer;
  HealthCheckResponse? _lastResponse;
  bool _isChecking = false;
  bool _isInitialized = false;
  String? _lastError;

  HealthCheckResponse? get lastResponse => _lastResponse;
  bool get isChecking => _isChecking;
  bool get isInitialized => _isInitialized;
  String? get lastError => _lastError;

  bool get isHealthy => _lastResponse?.status == 'healthy';
  int get healthyCount => _lastResponse?.services.where((s) => s.status == 'healthy').length ?? 0;
  int get totalCount => _lastResponse?.services.length ?? 0;

  ServiceStatus get overallStatus {
    if (_lastResponse == null) return ServiceStatus.unknown;
    switch (_lastResponse!.status) {
      case 'healthy':
        return ServiceStatus.healthy;
      case 'degraded':
        return ServiceStatus.degraded;
      case 'unhealthy':
        return ServiceStatus.unhealthy;
      default:
        return ServiceStatus.unknown;
    }
  }

  /// Initialize with client
  void initialize(Client client) {
    _client = client;
    _isInitialized = true;
    debugPrint('HealthService: Initialized');
  }

  /// Start automatic health checks
  void startAutoCheck({Duration interval = const Duration(seconds: 30)}) {
    if (!_isInitialized) {
      debugPrint('HealthService: Cannot start auto-check - not initialized');
      return;
    }
    
    stopAutoCheck();
    debugPrint('HealthService: Starting auto-check every ${interval.inSeconds}s');
    
    _autoCheckTimer = Timer.periodic(interval, (_) => checkHealth());
    
    // Do initial check
    checkHealth();
  }

  /// Stop automatic health checks
  void stopAutoCheck() {
    if (_autoCheckTimer != null) {
      _autoCheckTimer!.cancel();
      _autoCheckTimer = null;
      debugPrint('HealthService: Auto-check stopped');
    }
  }

  /// Perform health check via server endpoint
  Future<HealthCheckResponse?> checkHealth() async {
    if (_client == null) {
      debugPrint('HealthService: No client available');
      _lastError = 'Not initialized';
      notifyListeners();
      return null;
    }

    if (_isChecking) {
      return _lastResponse;
    }

    _isChecking = true;
    _lastError = null;
    notifyListeners();

    try {
      debugPrint('HealthService: Checking server health...');
      final response = await _client!.health.check();
      
      _lastResponse = response;
      _lastError = null;
      
      debugPrint('HealthService: ${response.status} - $healthyCount/$totalCount services (${response.totalLatencyMs}ms)');
    } catch (e) {
      debugPrint('HealthService: Error - $e');
      _lastError = e.toString();
    } finally {
      _isChecking = false;
      notifyListeners();
    }

    return _lastResponse;
  }

  /// Quick ping check
  Future<bool> ping() async {
    if (_client == null) return false;
    
    try {
      final result = await _client!.health.ping();
      return result == 'pong';
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    stopAutoCheck();
    super.dispose();
  }
}
