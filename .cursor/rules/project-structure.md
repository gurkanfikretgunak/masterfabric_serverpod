# Project Structure Rules

## Folder Naming Convention

**Always use snake_case (underscores) for folder names.**

```
# Correct
real_time/
notifications_center/
payment_gateway/
user_profile/

# Incorrect - NEVER use hyphens
real-time/
notifications-center/
payment-gateway/
```

## Module Organization Pattern

All modules follow this consistent structure:

```
module_name/
├── module_name.dart        # Barrel export (required)
├── endpoints/              # API endpoints
│   └── *_endpoint.dart
├── models/                 # Data models (.spy.yaml)
│   └── *.spy.yaml
├── services/               # Business logic
│   └── *_service.dart
└── integrations/           # External APIs (optional)
    └── *_integration.dart
```

## Server Project Structure

```
masterfabric_serverpod_server/lib/src/
├── core/                                    # Shared utilities
│   ├── core.dart                            # Main barrel export
│   ├── errors/
│   │   ├── errors.dart                      # Barrel
│   │   ├── base_error_handler.dart
│   │   └── error_types.dart
│   ├── exceptions/
│   │   ├── exceptions.dart                  # Barrel
│   │   └── models/
│   │       └── rate_limit_exception.spy.yaml
│   ├── health/
│   │   ├── health.dart                      # Barrel
│   │   ├── health_check_handler.dart
│   │   └── health_metrics.dart
│   ├── integrations/
│   │   ├── integrations.dart                # Barrel
│   │   ├── base_integration.dart
│   │   ├── email_integration.dart
│   │   ├── firebase_integration.dart
│   │   ├── integration_manager.dart
│   │   ├── mixpanel_integration.dart
│   │   └── sentry_integration.dart
│   ├── logging/
│   │   ├── logging.dart                     # Barrel
│   │   ├── core_logger.dart
│   │   └── log_formatter.dart
│   ├── rate_limit/
│   │   ├── rate_limit.dart                  # Barrel
│   │   ├── models/
│   │   │   └── rate_limit_entry.spy.yaml
│   │   └── services/
│   │       └── rate_limit_service.dart
│   ├── scheduling/
│   │   ├── scheduling.dart                  # Barrel
│   │   ├── base_scheduler.dart
│   │   ├── cron_job.dart
│   │   └── scheduler_manager.dart
│   ├── session/
│   │   ├── session.dart                     # Barrel
│   │   ├── session_cache_provider.dart
│   │   ├── session_data.dart
│   │   └── session_manager.dart
│   ├── utils/
│   │   ├── utils.dart                       # Barrel
│   │   └── common_utils.dart
│   └── real_time/
│       ├── real_time.dart                   # Barrel
│       └── notifications_center/            # Complex module example
│           ├── notifications_center.dart    # Barrel
│           ├── endpoints/
│           │   ├── notification_endpoint.dart
│           │   └── notification_stream_endpoint.dart
│           ├── integrations/
│           │   └── push_notification_integration.dart
│           ├── models/
│           │   ├── notification.spy.yaml
│           │   ├── notification_channel.spy.yaml
│           │   └── ... (13 total models)
│           └── services/
│               ├── notification_service.dart
│               ├── notification_channel_service.dart
│               └── notification_cache_service.dart
│
├── services/                                # Business services
│   ├── app_config/
│   │   ├── app_config.dart                  # Barrel
│   │   ├── endpoints/
│   │   │   └── app_config_endpoint.dart
│   │   └── services/
│   │       └── app_config_service.dart
│   ├── auth/
│   │   ├── auth.dart                        # Barrel
│   │   ├── config/                          # Domain-based subdirectories
│   │   ├── core/
│   │   ├── email/
│   │   ├── jwt/
│   │   ├── oauth/
│   │   ├── password/
│   │   ├── rbac/
│   │   ├── session/
│   │   ├── two_factor/
│   │   ├── user/
│   │   └── verification/
│   ├── greetings/
│   │   ├── greetings.dart                   # Barrel
│   │   ├── endpoints/
│   │   │   └── greeting_endpoint.dart
│   │   └── models/
│   │       ├── greeting.spy.yaml
│   │       └── greeting_response.spy.yaml
│   ├── health/
│   │   ├── health.dart                      # Barrel
│   │   ├── endpoints/
│   │   │   └── health_endpoint.dart
│   │   └── models/
│   │       ├── health_check_response.spy.yaml
│   │       └── service_health_info.spy.yaml
│   └── translations/
│       ├── translations.dart                # Barrel
│       ├── endpoints/
│       │   └── translation_endpoint.dart
│       ├── models/
│       │   ├── translation_entry.spy.yaml
│       │   └── translation_response.spy.yaml
│       └── services/
│           ├── translation_service.dart
│           └── ip_locale_detector.dart
│
├── app_config/                              # App configuration models
├── routes/                                  # HTTP routes
└── generated/                               # Auto-generated (DO NOT EDIT)
```

## File Naming Convention

| Type | Convention | Example |
|------|------------|---------|
| Endpoint | `<name>_endpoint.dart` | `payment_endpoint.dart` |
| Service | `<name>_service.dart` | `payment_service.dart` |
| Model | `<name>.spy.yaml` | `payment_response.spy.yaml` |
| Barrel | `<module_name>.dart` | `notifications_center.dart` |
| Stream Endpoint | `<name>_stream_endpoint.dart` | `notification_stream_endpoint.dart` |
| Integration | `<name>_integration.dart` | `push_notification_integration.dart` |

## Import Rules

1. Use package imports for serverpod: `import 'package:serverpod/serverpod.dart';`
2. Use relative imports within the same module: `import '../services/my_service.dart';`
3. Use relative imports for generated code: `import '../../../generated/protocol.dart';`
4. Use relative imports for core utilities: `import '../../../core/rate_limit/services/rate_limit_service.dart';`
5. Export via barrel files for external use

## Barrel Export Pattern

Each module must have a barrel export file at its root:

```dart
/// Module Name
///
/// Description of the module.

// Services
export 'services/my_service.dart';

// Endpoints
export 'endpoints/my_endpoint.dart';

// Integrations (optional)
export 'integrations/my_integration.dart';
```
