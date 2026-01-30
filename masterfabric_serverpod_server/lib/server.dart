import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';
import 'src/core/integrations/integration_manager.dart';
import 'src/core/health/health_check_handler.dart';
import 'src/core/scheduling/scheduler_manager.dart';
import 'src/core/session/session_manager.dart';

/// Global instances for core components
IntegrationManager? _integrationManager;
SessionManager? _sessionManager;
SchedulerManager? _schedulerManager;

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    healthCheckHandler: (pod, timestamp) => customHealthCheckHandler(
      pod,
      timestamp,
      integrationManager: _integrationManager,
    ),
  );

  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
    identityProviderBuilders: [
      // Configure the email identity provider for email/password authentication.
      EmailIdpConfigFromPasswords(
        sendRegistrationVerificationCode: _sendRegistrationCode,
        sendPasswordResetVerificationCode: _sendPasswordResetCode,
      ),
    ],
  );

  // Initialize core components
  await _initializeCoreComponents(pod);

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final root = Directory(Uri(path: 'web/static').toFilePath());
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Start the server.
  await pod.start();
}

/// Initialize core components (integrations, health checks, schedulers, session manager)
Future<void> _initializeCoreComponents(Serverpod pod) async {
  // Initialize Session Manager
  // Default TTL: 30 minutes (can be configured via environment variables or config)
  _sessionManager = SessionManager(
    defaultTtl: const Duration(minutes: 30),
  );

  // Initialize Integration Manager
  _integrationManager = IntegrationManager();
  try {
    // Load config from YAML - Serverpod loads config automatically
    // We'll initialize integrations based on environment variables or config files
    // For now, integrations are disabled by default in config files
      final sessionFuture = pod.createSession();
      final session = await sessionFuture;
      try {
        // Config is accessed via pod.config, but custom sections need to be read from YAML
        // For now, integrations will be initialized as empty (all disabled)
        // Users can enable them by setting enabled: true in config files
        await _integrationManager!.initializeFromConfig({});
        
        final enabledIntegrations = _integrationManager!.getEnabledIntegrations();
        if (enabledIntegrations.isNotEmpty) {
          session.log('Initialized integrations: ${enabledIntegrations.map((i) => i.name).join(", ")}');
        }
      } finally {
        await session.close();
      }
    } catch (e, stackTrace) {
      final sessionFuture = pod.createSession();
      final session = await sessionFuture;
      try {
        session.log('Failed to initialize integrations: $e', level: LogLevel.error, exception: e is Exception ? e : Exception(e.toString()), stackTrace: stackTrace);
      } finally {
        await session.close();
      }
    }

  // Initialize Scheduler Manager
  // Scheduler is enabled by default, can be disabled via config
  _schedulerManager = SchedulerManager(pod, checkInterval: const Duration(minutes: 1));
  
  // Register example cron jobs here
  // Example: Clean up expired sessions every hour
  // _schedulerManager!.registerJob(
  //   CronJob(
  //     name: 'cleanup_expired_sessions',
  //     schedule: '0 0 * * * *', // Every hour
  //     execute: (session) async {
  //       // Implementation for cleaning up expired sessions
  //     },
  //   ),
  // );

  _schedulerManager!.start();
}

/// Cleanup core components on server shutdown
Future<void> _cleanupCoreComponents() async {
  // Stop scheduler
  _schedulerManager?.stop();

  // Dispose integrations
  await _integrationManager?.disposeAll();
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Registration code ($email): $verificationCode');
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // NOTE: Here you call your mail service to send the verification code to
  // the user. For testing, we will just log the verification code.
  session.log('[EmailIdp] Password reset code ($email): $verificationCode');
}
