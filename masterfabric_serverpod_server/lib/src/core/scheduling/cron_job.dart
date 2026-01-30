import 'package:serverpod/serverpod.dart';
import 'base_scheduler.dart';

/// Cron job implementation
/// 
/// Represents a scheduled task that runs on a cron schedule.
class CronJob extends BaseScheduler {
  /// Cron expression (e.g., "0 */5 * * * *" for every 5 minutes)
  @override
  final String schedule;
  
  /// Name of the cron job
  @override
  final String name;
  
  /// Function to execute when the job runs
  final Future<void> Function(Session session) _executeFunction;
  
  /// Whether the job is enabled
  final bool enabled;
  
  /// Last execution time
  DateTime? _lastExecution;
  
  /// Next execution time (calculated)
  DateTime? _nextExecution;
  
  /// Number of times this job has been executed
  int _executionCount = 0;
  
  /// Number of times this job has failed
  int _failureCount = 0;

  CronJob({
    required this.schedule,
    required this.name,
    required Future<void> Function(Session session) execute,
    this.enabled = true,
  }) : _executeFunction = execute;

  @override
  Future<void> execute(Session session) async {
    if (!enabled) {
      return;
    }

    try {
      _lastExecution = DateTime.now();
      _executionCount++;
      
      await _executeFunction(session);
    } catch (e, stackTrace) {
      _failureCount++;
      session.log(
        'Cron job "$name" failed: $e',
        level: LogLevel.error,
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Get last execution time
  DateTime? get lastExecution => _lastExecution;

  /// Get next execution time
  DateTime? get nextExecution => _nextExecution;

  /// Set next execution time
  void setNextExecution(DateTime? next) {
    _nextExecution = next;
  }

  /// Get execution count
  int get executionCount => _executionCount;

  /// Get failure count
  int get failureCount => _failureCount;

  /// Get success rate (0.0 to 1.0)
  double get successRate {
    if (_executionCount == 0) return 1.0;
    return (_executionCount - _failureCount) / _executionCount;
  }

  /// Validate cron expression
  /// 
  /// Basic validation - checks format (5 or 6 fields)
  /// Note: Full cron parsing would require a cron library
  bool validateSchedule() {
    final parts = schedule.trim().split(RegExp(r'\s+'));
    return parts.length == 5 || parts.length == 6;
  }
}
