import 'dart:async';
import 'package:serverpod/serverpod.dart';
import 'cron_job.dart';

/// Manager for scheduling and executing cron jobs
/// 
/// Uses Serverpod's FutureCall system or periodic timers to execute jobs.
class SchedulerManager {
  final Serverpod _server;
  final List<CronJob> _jobs = [];
  Timer? _schedulerTimer;
  bool _isRunning = false;

  /// Interval for checking and executing jobs (default: 1 minute)
  final Duration checkInterval;

  SchedulerManager(
    this._server, {
    Duration? checkInterval,
  }) : checkInterval = checkInterval ?? const Duration(minutes: 1);

  /// Register a cron job
  /// 
  /// [job] - Cron job to register
  void registerJob(CronJob job) {
    if (!job.validateSchedule()) {
      throw Exception('Invalid cron schedule for job "${job.name}": ${job.schedule}');
    }

    _jobs.add(job);
  }

  /// Register multiple cron jobs
  /// 
  /// [jobs] - List of cron jobs to register
  void registerJobs(List<CronJob> jobs) {
    for (final job in jobs) {
      registerJob(job);
    }
  }

  /// Start the scheduler
  /// 
  /// Begins checking and executing jobs periodically
  void start() {
    if (_isRunning) {
      return;
    }

    _isRunning = true;
    _schedulerTimer = Timer.periodic(checkInterval, (_) {
      _checkAndExecuteJobs();
    });
  }

  /// Stop the scheduler
  /// 
  /// Stops checking and executing jobs
  void stop() {
    _isRunning = false;
    _schedulerTimer?.cancel();
    _schedulerTimer = null;
  }

  /// Get all registered jobs
  List<CronJob> getJobs() {
    return List.unmodifiable(_jobs);
  }

  /// Get a job by name
  /// 
  /// [name] - Job name
  /// 
  /// Returns the job or null if not found
  CronJob? getJob(String name) {
    try {
      return _jobs.firstWhere((job) => job.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Check and execute jobs that are due
  /// 
  /// This is called periodically by the timer
  Future<void> _checkAndExecuteJobs() async {
    final now = DateTime.now();

    for (final job in _jobs) {
      if (!job.enabled) {
        continue;
      }

      // Simple cron parsing - check if job should run
      // Note: This is a simplified implementation. For production,
      // you should use a proper cron parsing library
      if (_shouldExecute(job, now)) {
      // Execute job asynchronously (don't await to avoid blocking)
      unawaited(_executeJob(job).catchError((error) {
        // Error is already logged in CronJob.execute()
      }));
      }
    }
  }

  /// Check if a job should execute at the given time
  /// 
  /// This is a simplified cron parser. For production use, consider
  /// using a library like 'cron' package.
  bool _shouldExecute(CronJob job, DateTime now) {
    // TODO: Implement proper cron parsing
    // For now, this is a placeholder that always returns false
    // You should parse the cron expression and check if it matches 'now'
    // Jobs can be triggered manually using triggerJob() method
    
    // This is a very basic implementation - replace with proper cron parsing
    // For now, jobs won't auto-execute. They can be triggered manually or
    // you need to add a cron parsing library.
    
    return false; // Placeholder - implement cron parsing here
  }

  /// Execute a job
  /// 
  /// Creates a session and executes the job
  Future<void> _executeJob(CronJob job) async {
    // Create a session for the job execution
    // Note: This creates a session without HTTP context
    final sessionFuture = _server.createSession();

    try {
      final session = await sessionFuture;
      await job.execute(session);
      job.setNextExecution(_calculateNextExecution(job));
      await session.close();
    } catch (e) {
      // Error is already logged in CronJob.execute()
      rethrow;
    }
  }

  /// Calculate next execution time for a job
  /// 
  /// This is a placeholder - implement proper cron calculation
  DateTime? _calculateNextExecution(CronJob job) {
    // TODO: Implement proper cron next execution calculation
    // For now, return null
    return null;
  }

  /// Manually trigger a job execution
  /// 
  /// [jobName] - Name of the job to execute
  Future<void> triggerJob(String jobName) async {
    final job = getJob(jobName);
    if (job == null) {
      throw Exception('Job not found: $jobName');
    }

    await _executeJob(job);
  }
}
