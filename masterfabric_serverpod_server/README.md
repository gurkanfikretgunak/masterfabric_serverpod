# masterfabric_serverpod_server

Serverpod backend server with rate limiting, multi-level caching, internationalization, real-time notifications, and authentication.

## Quick Start

```bash
# 1. Start PostgreSQL and Redis
docker compose up --build --detach

# 2. Generate Serverpod code
serverpod generate

# 3. Start the server
dart bin/main.dart
```

## Features

### Rate Limiting

Distributed rate limiting using Redis cache:

```dart
// In your endpoint
static const _rateLimitConfig = RateLimitConfig(
  maxRequests: 20,
  windowDuration: Duration(minutes: 1),
  keyPrefix: 'my_endpoint',
);

Future<MyResponse> myMethod(Session session) async {
  await RateLimitService.checkLimit(session, _rateLimitConfig, identifier);
  // ... your logic
}
```

### Multi-Level Caching

Three-tier caching strategy:

| Level | Storage | Speed | Scope |
|-------|---------|-------|-------|
| `localPrio` | Memory | Fastest | Single server |
| `local` | Memory | Fast | Single server |
| `global` | Redis | Network | Cluster-wide |

```dart
// Read from cache (try all levels)
var data = await session.caches.localPrio.get<MyModel>(key);
data ??= await session.caches.local.get<MyModel>(key);
data ??= await session.caches.global.get<MyModel>(key);

// Write to cache
await session.caches.global.put(key, data, lifetime: Duration(hours: 1));
```

### Internationalization (i18n)

Auto-seeds translations from `assets/i18n/*.json` on startup:

```
assets/i18n/
├── en.i18n.json    # English (default)
├── tr.i18n.json    # Turkish
├── de.i18n.json    # German
└── es.i18n.json    # Spanish
```

**Translation structure includes:**
- `app` - App name and version
- `welcome`, `auth` - Authentication screens
- `dashboard`, `devTools` - Main screens
- `settings` - Settings screen (language, notifications, privacy, about)
- `greeting.v3` - RBAC test screen
- `profile` - User profile
- `common`, `errors` - Shared strings
- `languages` - Language names for selector

### Real-Time Notifications

WebSocket streaming for real-time notifications with Redis caching:

```dart
// Create a notification channel
final response = await NotificationChannelService.createChannel(
  session,
  name: 'announcements',
  type: ChannelType.broadcast,
  isPublic: true,
);

// Send notification
await NotificationService.sendNotification(
  session,
  channelId: channelId,
  title: 'New Feature',
  message: 'Check out the updates!',
  priority: NotificationPriority.high,
);
```

**Notification Types:**
- **Broadcast**: Public notifications for all users (cached for 50k+ concurrent users)
- **User-Based**: Notifications for specific users
- **Project-Based**: Notifications for project members

### Role-Based Access Control (RBAC)

Automatic role assignment and endpoint protection:

```dart
// Define role requirements in your endpoint
class MyEndpoint extends MasterfabricEndpoint with RbacEndpointMixin {
  @override
  List<String> get requiredRoles => ['user'];

  @override
  Map<String, List<String>> get methodRoles => {
    'adminMethod': ['admin'],           // Admin only
    'modMethod': ['moderator', 'admin'], // Either role
  };

  @override
  Map<String, bool> get methodRequireAllRoles => {
    'strictMethod': true,  // Require ALL roles
  };
}
```

**Default Roles (auto-seeded on startup):**
- `public` - Unauthenticated access
- `user` - Auto-assigned on signup
- `moderator` - Content moderation
- `admin` - Full access

**RBAC Service:**

```dart
final rbacService = RbacService();

// Check role
final isAdmin = await rbacService.hasRole(session, userId, 'admin');

// Assign role
await rbacService.assignRole(session, userId, 'moderator');

// Get user roles
final roles = await rbacService.getUserRoles(session, userId);
```

### SerializableExceptions

Proper error responses to clients:

```dart
// Define in .spy.yaml
exception: RateLimitException
fields:
  message: String
  limit: int
  retryAfterSeconds: int

// Throw in endpoint
throw RateLimitException(
  message: 'Rate limit exceeded',
  limit: 20,
  retryAfterSeconds: 45,
);

// Client receives structured error (not "Internal Server Error")
```

## Project Structure

```
lib/src/
├── core/
│   ├── core.dart              # Barrel export for core
│   ├── errors/                # Custom error types
│   │   ├── errors.dart        # Barrel export
│   │   ├── base_error_handler.dart
│   │   └── error_types.dart
│   ├── exceptions/            # SerializableExceptions
│   │   ├── exceptions.dart    # Barrel export
│   │   └── models/            # Exception .spy.yaml files
│   ├── health/                # Health checks
│   │   ├── health.dart        # Barrel export
│   │   ├── health_check_handler.dart
│   │   └── health_metrics.dart
│   ├── integrations/          # Firebase, Sentry, Mixpanel
│   │   └── integrations.dart  # Barrel export
│   ├── logging/               # Structured logging
│   │   └── logging.dart       # Barrel export
│   ├── rate_limit/            # Rate limiting
│   │   ├── rate_limit.dart    # Barrel export
│   │   ├── models/            # Rate limit models
│   │   └── services/          # Rate limit service
│   ├── real_time/             # Real-time features
│   │   ├── real_time.dart     # Barrel export
│   │   └── notifications_center/
│   │       ├── notifications_center.dart  # Barrel export
│   │       ├── endpoints/     # Notification endpoints
│   │       ├── models/        # Notification models
│   │       ├── services/      # Notification services
│   │       └── integrations/  # Push notification integrations
│   ├── scheduling/            # Cron scheduling
│   │   └── scheduling.dart    # Barrel export
│   ├── session/               # Session management
│   │   └── session.dart       # Barrel export
│   └── utils/                 # Utilities
│       └── utils.dart         # Barrel export
├── services/
│   ├── app_config/            # App configuration
│   │   ├── app_config.dart    # Barrel export
│   │   ├── endpoints/         # Config endpoints
│   │   └── services/          # Config services
│   ├── auth/                  # Authentication
│   │   ├── auth.dart          # Barrel export
│   │   ├── config/            # Auth configuration
│   │   ├── core/              # Auth core services
│   │   ├── email/             # Email auth
│   │   ├── jwt/               # JWT handling
│   │   ├── oauth/             # OAuth providers
│   │   ├── password/          # Password management
│   │   ├── rbac/              # Role-based access
│   │   ├── session/           # Session management
│   │   ├── two_factor/        # 2FA
│   │   ├── user/              # User management
│   │   └── verification/      # Verification codes
│   ├── greetings/             # Example service
│   │   ├── greetings.dart     # Barrel export
│   │   ├── endpoints/         # Greeting endpoints
│   │   └── models/            # Greeting models
│   ├── health/                # Health endpoints
│   │   ├── health.dart        # Barrel export
│   │   ├── endpoints/         # Health endpoints
│   │   └── models/            # Health models
│   └── translations/          # i18n service
│       ├── translations.dart  # Barrel export
│       ├── endpoints/         # Translation endpoints
│       ├── models/            # Translation models
│       └── services/          # Translation services
└── generated/                 # Serverpod generated code
```

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Folders | `snake_case` | `notifications_center/` |
| Files | `snake_case` | `notification_service.dart` |
| Classes | `PascalCase` | `NotificationService` |
| Models | `snake_case.spy.yaml` | `notification.spy.yaml` |

### Module Organization Pattern

Each module follows this structure:

```
module_name/
├── module_name.dart     # Barrel export (re-exports all public APIs)
├── endpoints/           # API endpoints
├── models/              # Data models (.spy.yaml files)
├── services/            # Business logic services
└── integrations/        # External integrations (optional)
```

## Configuration

Server configuration in `config/development.yaml`:

```yaml
# Enable Redis (required for rate limiting, caching & notifications)
redis:
  enabled: true
  host: localhost
  port: 8091

# Rate limiting config
emailValidation:
  rateLimiting:
    enabled: true
    maxAttemptsPerEmail: 5
    maxAttemptsPerIp: 10
    windowMinutes: 60
```

## Seeding Data

```bash
# Seed notifications for testing
dart run bin/seed_notifications.dart

# Translations auto-seed from assets/i18n/ on server startup
```

## Stopping Services

```bash
# Stop server
Ctrl-C

# Stop Docker containers
docker compose stop

# Remove volumes
docker compose down -v
```

## Documentation

- [Main Project README](../README.md)
- [Serverpod Documentation](https://docs.serverpod.dev)

---

## License

This project is licensed under the **GNU Affero General Public License v3.0 (AGPL-3.0)**.

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)

**Copyright (C) 2026 MASTERFABRIC Bilişim Teknolojileri A.Ş. (MASTERFABRIC Information Technologies Inc.)**

- **Owner:** Gürkan Fikret Günak (@gurkanfikretgunak)
- **Website:** https://masterfabric.co
- **License Contact:** license@masterfabric.co

For full license terms, see the [LICENSE](../LICENSE) file.
