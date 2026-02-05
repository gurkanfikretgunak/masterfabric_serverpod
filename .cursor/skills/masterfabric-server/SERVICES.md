# Existing Services Reference

## Services Overview

| Service | Path | Auth Required | Description |
|---------|------|---------------|-------------|
| `greeting` | `/greeting/hello` | No | Example with rate limiting |
| `health` | `/health/check` | No | Server health monitoring |
| `translation` | `/translation/*` | No | i18n translations |
| `appConfig` | `/appConfig/getConfig` | No | Remote configuration |
| `currency` | `/currency/*` | No | Currency conversion and exchange rates |
| `emailIdp` | `/emailIdp/*` | No | Email authentication |
| `passwordManagement` | `/passwordManagement/*` | Mixed | Password validation/reset |
| `pairedDevice` | `/pairedDevice/*` | Yes | Device pairing and management |
| `userProfile` | `/userProfile/*` | Yes | User profile management |
| `sessionManagement` | `/sessionManagement/*` | Yes | Session management |
| `rbac` | `/rbac/*` | Yes | Role-based access control |
| `notification` | `/notification/*` | Mixed | Notification management |
| `notificationStream` | `/notificationStream/*` | No | Real-time notifications (WebSocket) |

## Real-Time Services

### Notification Center (`core/real_time/notifications_center/`)

The notification center provides real-time notifications via WebSocket streaming.

**Endpoints:**
| Endpoint | Method | Auth | Description |
|----------|--------|------|-------------|
| `notification.send` | POST | No | Send a notification |
| `notification.getHistory` | POST | No | Get notification history |
| `notification.getPublicNotifications` | POST | No | Get public notifications |
| `notification.listPublicChannels` | POST | No | List public channels |
| `notification.createChannel` | POST | No | Create a channel |
| `notification.joinChannel` | POST | Yes | Join a channel |
| `notification.leaveChannel` | POST | Yes | Leave a channel |
| `notificationStream.subscribe` | Stream | No | Subscribe to channels |
| `notificationStream.subscribeToBroadcasts` | Stream | No | Subscribe to public broadcasts |

**Usage Example:**
```dart
// Server-side: Send notification
await NotificationService.broadcast(
  session,
  channelId: 'announcements',
  title: 'New Update',
  body: 'Version 2.0 is here!',
);

// Client-side: Subscribe to stream
final stream = client.notificationStream.subscribeToBroadcasts(['channel-id']);
stream.listen((notification) {
  print('Received: ${notification.title}');
});
```

## Rate Limit Configurations

| Endpoint | Limit | Window | Key Prefix |
|----------|-------|--------|------------|
| Greeting | 20 | 1 min | `greeting` |
| Auth (login) | 5 | 1 min | `auth:login` |
| Password reset | 3 | 15 min | `auth:reset` |
| Currency | 60 | 1 min | `currency_*` |
| Paired Device (pair) | 5 | 1 hour | `paired_device_pair` |
| Paired Device (verify) | 10 | 1 hour | `paired_device_verify` |
| Paired Device (general) | 60 | 1 min | `paired_device` |
| General API | 100 | 1 min | `api` |
| Notification send | 100 | 1 min | `notification_send` |
| Notification read | 300 | 1 min | `notification_read` |

## Database Tables

```
serverpod_auth_core_user      # Users
serverpod_auth_core_session   # Sessions
translation_entries           # i18n entries
paired_devices                # Paired device information
user_verification_preferences # Verification channel preferences
```

## Environment Variables

```bash
SERVERPOD_API_SERVER          # API server config
REDIS_HOST                    # Redis for rate limiting & caching
SMTP_HOST                     # Email service
SENTRY_DSN                    # Error tracking
MIXPANEL_TOKEN                # Analytics
FIREBASE_PROJECT_ID           # Push notifications
```

## Core Module Structure

```
core/
├── errors/              # Error handling
├── exceptions/          # Custom exceptions
├── health/              # Health checks
├── integrations/        # External services
│   ├── firebase_integration.dart
│   ├── sentry_integration.dart
│   ├── mixpanel_integration.dart
│   └── email_integration.dart
├── logging/             # Structured logging
├── rate_limit/          # Rate limiting
├── scheduling/          # Background jobs
├── session/             # Session management
├── utils/               # Utilities
└── real_time/           # Real-time features
    └── notifications_center/    # Notification system
        ├── endpoints/           # API endpoints
        ├── models/              # Data models
        ├── services/            # Business logic
        └── integrations/        # Push providers (FCM, APNs)
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

### Notifications (Real-Time)
```dart
import '../core/real_time/notifications_center/services/notification_service.dart';

// Send to user
await NotificationService.sendToUser(session, userId: 'user-123', title: 'Hi', body: 'Message');

// Broadcast
await NotificationService.broadcast(session, channelId: 'public', title: 'News', body: 'Content');
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

## Auth Service Structure

The auth service is organized into subdirectories for maintainability:

```
services/auth/
├── config/          # Auth configuration service
├── core/            # Audit logs, helpers
├── email/           # Email authentication (IDP)
├── jwt/             # JWT refresh endpoint
├── oauth/           # Apple, Google OAuth
├── password/        # Password management
├── rbac/            # Role-based access control
├── session/         # Session management
├── two_factor/      # 2FA setup & verification
├── user/            # User profiles, management
└── verification/    # Email/phone verification
```
