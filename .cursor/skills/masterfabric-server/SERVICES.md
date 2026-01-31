# Existing Services Reference

## Services Overview

| Service | Path | Auth Required | Description |
|---------|------|---------------|-------------|
| `greeting` | `/greeting/hello` | No | Example with rate limiting |
| `health` | `/health/check` | No | Server health monitoring |
| `translation` | `/translation/*` | No | i18n translations |
| `appConfig` | `/appConfig/getConfig` | No | Remote configuration |
| `emailIdp` | `/emailIdp/*` | No | Email authentication |
| `passwordManagement` | `/passwordManagement/*` | Mixed | Password validation/reset |
| `userProfile` | `/userProfile/*` | Yes | User profile management |
| `sessionManagement` | `/sessionManagement/*` | Yes | Session management |
| `rbac` | `/rbac/*` | Yes | Role-based access control |

## Rate Limit Configurations

| Endpoint | Limit | Window | Key Prefix |
|----------|-------|--------|------------|
| Greeting | 20 | 1 min | `greeting` |
| Auth (login) | 5 | 1 min | `auth:login` |
| Password reset | 3 | 15 min | `auth:reset` |
| General API | 100 | 1 min | `api` |

## Database Tables

```
serverpod_auth_core_user      # Users
serverpod_auth_core_session   # Sessions
translation_entries           # i18n entries
```

## Environment Variables

```bash
SERVERPOD_API_SERVER          # API server config
REDIS_HOST                    # Redis for rate limiting
SMTP_HOST                     # Email service
SENTRY_DSN                    # Error tracking
MIXPANEL_TOKEN                # Analytics
FIREBASE_PROJECT_ID           # Push notifications
```

## Integrations

### Sentry (Error Tracking)
```dart
import '../core/integrations/sentry_integration.dart';
SentryIntegration.captureException(e, stackTrace);
```

### Mixpanel (Analytics)
```dart
import '../core/integrations/mixpanel_integration.dart';
MixpanelIntegration.track('event_name', properties: {'key': 'value'});
```

## Translation Keys Structure

```json
{
  "welcome": { "title": "...", "subtitle": "..." },
  "login": { "title": "...", "email": "...", "password": "..." },
  "common": { "save": "...", "cancel": "...", "delete": "..." },
  "errors": { "network": "...", "server": "...", "validation": "..." }
}
```

Supported locales: `en`, `tr`, `de`, `es`
