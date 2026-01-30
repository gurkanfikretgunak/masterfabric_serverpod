/// Health check status enumeration
enum HealthStatus {
  /// System is healthy
  healthy,
  
  /// System is degraded but functional
  degraded,
  
  /// System is unhealthy
  unhealthy,
}

/// Health check result for a single check
class HealthCheckResult {
  /// Name of the health check
  final String name;
  
  /// Status of the check
  final HealthStatus status;
  
  /// Optional message describing the status
  final String? message;
  
  /// Optional additional details
  final Map<String, dynamic>? details;
  
  /// Timestamp when check was performed
  final DateTime timestamp;

  HealthCheckResult({
    required this.name,
    required this.status,
    this.message,
    this.details,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

}

/// Aggregate health check result
class AggregateHealthResult {
  /// Overall status (worst status from all checks)
  final HealthStatus overallStatus;
  
  /// List of individual health check results
  final List<HealthCheckResult> checks;
  
  /// Timestamp when checks were performed
  final DateTime timestamp;

  AggregateHealthResult({
    required this.overallStatus,
    required this.checks,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Create from list of health check results
  factory AggregateHealthResult.fromChecks(List<HealthCheckResult> checks) {
    HealthStatus overall = HealthStatus.healthy;
    
    for (final check in checks) {
      if (check.status == HealthStatus.unhealthy) {
        overall = HealthStatus.unhealthy;
        break;
      } else if (check.status == HealthStatus.degraded) {
        overall = HealthStatus.degraded;
      }
    }

    return AggregateHealthResult(
      overallStatus: overall,
      checks: checks,
    );
  }
}
