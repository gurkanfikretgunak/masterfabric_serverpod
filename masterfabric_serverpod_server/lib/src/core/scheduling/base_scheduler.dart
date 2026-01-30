import 'package:serverpod/serverpod.dart';

/// Abstract base class for schedulers
/// 
/// Provides a common interface for scheduled tasks (cron jobs).
abstract class BaseScheduler {
  /// Cron expression or schedule pattern
  /// 
  /// For cron: "0 */5 * * * *" (every 5 minutes)
  /// Format: second minute hour day month weekday
  String get schedule;

  /// Name of the scheduler/job
  String get name;

  /// Execute the scheduled task
  /// 
  /// [session] - Serverpod session for database access, logging, etc.
  Future<void> execute(Session session);
}
