import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:yaml/yaml.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/routes/app_config_route.dart';
import 'src/routes/root_route.dart';
import 'src/core/integrations/integration_manager.dart';
import 'src/core/health/health_check_handler.dart';
import 'src/core/scheduling/scheduler_manager.dart';
import 'src/core/session/session_manager.dart';
import 'src/services/auth/email_validation_service.dart';
import 'src/services/auth/email_service.dart';
import 'src/services/auth/email_idp_endpoint.dart';

/// Global instances for core components
IntegrationManager? _integrationManager;
SessionManager? _sessionManager;
SchedulerManager? _schedulerManager;
EmailValidationService? _emailValidationService;
EmailService? _emailService;

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

  // Set email validation service on EmailIdpEndpoint after endpoints are initialized
  _setEmailValidationServiceOnEndpoint(pod);

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final staticDir = Directory(Uri(path: 'web/static').toFilePath());
  if (staticDir.existsSync()) {
    pod.webServer.addRoute(StaticRoute.directory(staticDir));
  }

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
    final sessionFuture = pod.createSession();
    final session = await sessionFuture;
    try {
      // Read config from pod.config (Serverpod handles YAML parsing)
      // Custom sections like 'integrations' and 'emailValidation' are available
      final config = _readConfigFromPod(pod);
      
      // Initialize integrations
      await _integrationManager!.initializeFromConfig(config);
      
      final enabledIntegrations = _integrationManager!.getEnabledIntegrations();
      if (enabledIntegrations.isNotEmpty) {
        session.log('Initialized integrations: ${enabledIntegrations.map((i) => i.name).join(", ")}');
      }

      // Initialize Email Validation Service
      final emailValidationConfig = config['emailValidation'] as Map<String, dynamic>?;
      if (emailValidationConfig != null) {
        final rateLimitingConfig = emailValidationConfig['rateLimiting'] as Map<String, dynamic>?;
        _emailValidationService = EmailValidationService(
          enabled: emailValidationConfig['enabled'] as bool? ?? true,
          domainWhitelist: (emailValidationConfig['domainWhitelist'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
          domainBlacklist: (emailValidationConfig['domainBlacklist'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
          emailBlacklist: (emailValidationConfig['emailBlacklist'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
          rateLimitingEnabled: rateLimitingConfig?['enabled'] as bool? ?? true,
          maxAttemptsPerEmail: rateLimitingConfig?['maxAttemptsPerEmail'] as int? ?? 5,
          maxAttemptsPerIp: rateLimitingConfig?['maxAttemptsPerIp'] as int? ?? 10,
          windowMinutes: rateLimitingConfig?['windowMinutes'] as int? ?? 60,
        );
        session.log('Email validation service initialized', level: LogLevel.info);
      }

      // Initialize Email Service
      _emailService = EmailService(_integrationManager);
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

/// Set email validation service on EmailIdpEndpoint
void _setEmailValidationServiceOnEndpoint(Serverpod pod) {
  try {
    // Access endpoint through Endpoints class
    final endpoints = pod.endpoints;
    final emailIdpConnector = endpoints.connectors['emailIdp'];
    if (emailIdpConnector != null) {
      final emailIdpEndpoint = emailIdpConnector.endpoint;
      if (emailIdpEndpoint is EmailIdpEndpoint && _emailValidationService != null) {
        emailIdpEndpoint.setEmailValidationService(_emailValidationService);
      }
    }
  } catch (e) {
    // Endpoint might not be available yet, this is okay
    // The endpoint will work without validation if not set
  }
}

/// Cleanup core components on server shutdown
Future<void> _cleanupCoreComponents() async {
  // Stop scheduler
  _schedulerManager?.stop();

  // Dispose integrations
  await _integrationManager?.disposeAll();
}

/// Read configuration from YAML config file
/// 
/// Reads custom configuration sections (integrations, emailValidation) from config files
Map<String, dynamic> _readConfigFromPod(Serverpod pod) {
  try {
    // Determine config file path based on environment
    final environment = Platform.environment['SERVERPOD_ENVIRONMENT'] ?? 'development';
    final configPath = 'config/$environment.yaml';
    
    final configFile = File(configPath);
    if (!configFile.existsSync()) {
      // Fallback to development.yaml if environment-specific file doesn't exist
      final fallbackPath = 'config/development.yaml';
      final fallbackFile = File(fallbackPath);
      if (!fallbackFile.existsSync()) {
        return {};
      }
      final content = fallbackFile.readAsStringSync();
      final yaml = loadYaml(content) as Map;
      return _yamlToMap(yaml);
    }

    final content = configFile.readAsStringSync();
    final yaml = loadYaml(content) as Map;
    return _yamlToMap(yaml);
  } catch (e) {
    // If config reading fails, return empty map (components will use defaults)
    return {};
  }
}

/// Convert YAML map to Dart Map<String, dynamic>
Map<String, dynamic> _yamlToMap(Map yaml) {
  final result = <String, dynamic>{};
  for (final entry in yaml.entries) {
    final key = entry.key.toString();
    final value = entry.value;
    
    if (value is Map) {
      result[key] = _yamlToMap(value);
    } else if (value is List) {
      result[key] = value.map((e) => e is Map ? _yamlToMap(e) : e).toList();
    } else {
      result[key] = value;
    }
  }
  return result;
}

void _sendRegistrationCode(
  Session session, {
  required String email,
  required UuidValue accountRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // Use EmailService to send verification code
  if (_emailService != null) {
    _emailService!.sendRegistrationVerificationCode(
      email: email,
      verificationCode: verificationCode,
      session: session,
    );
  } else {
    // Fallback to logging if EmailService is not initialized
    session.log('[EmailIdp] Registration code ($email): $verificationCode');
  }
}

void _sendPasswordResetCode(
  Session session, {
  required String email,
  required UuidValue passwordResetRequestId,
  required String verificationCode,
  required Transaction? transaction,
}) {
  // Use EmailService to send verification code
  if (_emailService != null) {
    _emailService!.sendPasswordResetVerificationCode(
      email: email,
      verificationCode: verificationCode,
      session: session,
    );
  } else {
    // Fallback to logging if EmailService is not initialized
    session.log('[EmailIdp] Password reset code ($email): $verificationCode');
  }
}
