---
name: masterfabric-server
description: Create Serverpod services, endpoints, and models for MasterFabric server. Use when creating new API endpoints, services, database models, or modifying server-side code. Includes rate limiting, caching, authentication, real-time notifications, and i18n patterns.
---

# MasterFabric Serverpod Server

## Project Structure

```
masterfabric_serverpod_server/
├── lib/src/
│   ├── core/                           # Shared utilities & real-time features
│   │   ├── errors/                     # Error handling
│   │   ├── exceptions/                 # Custom exceptions (.spy.yaml)
│   │   ├── health/                     # Health check handler
│   │   ├── integrations/               # Firebase, Sentry, Mixpanel, Email
│   │   ├── logging/                    # Structured logging
│   │   ├── middleware/                 # Middleware/Interceptor system
│   │   │   ├── base/                   # Base classes (MasterfabricEndpoint)
│   │   │   ├── interceptors/           # Logging, RateLimit, Auth, etc.
│   │   │   ├── models/                 # Middleware models
│   │   │   └── services/               # Registry, resolver
│   │   ├── rate_limit/                 # Rate limiting service
│   │   ├── scheduling/                 # Background jobs, cron
│   │   ├── session/                    # Session management
│   │   ├── utils/                      # Common utilities
│   │   └── real_time/                  # Real-time features
│   │       └── notifications_center/   # Notification system (pattern example)
│   │           ├── endpoints/          # API & streaming endpoints
│   │           ├── integrations/       # Push notification providers
│   │           ├── models/             # Data models (.spy.yaml)
│   │           └── services/           # Business logic
│   ├── services/                       # Business logic (ADD NEW SERVICES HERE)
│   │   ├── auth/                       # Authentication (organized subdirs)
│   │   │   ├── config/                 # Auth configuration
│   │   │   ├── core/                   # Audit logs, helpers
│   │   │   ├── email/                  # Email authentication
│   │   │   ├── jwt/                    # JWT refresh
│   │   │   ├── oauth/                  # Apple, Google OAuth
│   │   │   ├── password/               # Password management
│   │   │   ├── rbac/                   # Role-based access control
│   │   │   ├── session/                # Session management
│   │   │   ├── two_factor/             # 2FA
│   │   │   ├── user/                   # User profiles, management
│   │   │   └── verification/           # Email/phone verification
│   │   ├── app_config/                 # Remote config
│   │   ├── greetings/                  # Example with rate limit
│   │   ├── health/                     # Health check endpoint
│   │   └── translations/               # i18n service
│   ├── app_config/                     # App configuration models
│   ├── routes/                         # HTTP routes
│   └── generated/                      # Auto-generated (DO NOT EDIT)
├── config/                             # Environment configs
└── assets/i18n/                        # Translation files (en, tr, de, es)
```

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Directory | snake_case | `payment_gateway/` |
| Endpoint | PascalCase + Endpoint | `PaymentGatewayEndpoint` |
| Service | PascalCase + Service | `PaymentGatewayService` |
| Model file | snake_case.spy.yaml | `payment_response.spy.yaml` |
| Model class | PascalCase | `PaymentResponse` |
| Barrel export | snake_case.dart | `payment_gateway.dart` |

**Important:** Always use underscores (`_`) in folder names, never hyphens (`-`).

## Module Organization Pattern

For complex modules (like `notifications_center`), use this structure:

```
my_module/
├── my_module.dart              # Barrel export file
├── endpoints/                  # API endpoints (public interface)
│   ├── my_endpoint.dart
│   └── my_stream_endpoint.dart # For real-time streaming
├── models/                     # Data models (.spy.yaml files)
│   ├── my_model.spy.yaml
│   └── my_response.spy.yaml
├── services/                   # Business logic (internal)
│   ├── my_service.dart
│   └── my_cache_service.dart
└── integrations/               # External service integrations
    └── external_provider.dart
```

## Creating a New Service

### Simple Service (Single File Pattern)

For simple services, use the flat structure in `lib/src/services/`:

```bash
mkdir -p lib/src/services/<service_name>/
```

Create files:
- `<service_name>_endpoint.dart` - API endpoint
- `<service_name>_service.dart` - Business logic
- `<service_name>_response.spy.yaml` - Response model

### Complex Service (Module Pattern)

For complex services with multiple endpoints, models, and integrations:

```bash
mkdir -p lib/src/services/<service_name>/{endpoints,models,services,integrations}
touch lib/src/services/<service_name>/<service_name>.dart  # Barrel export
```

### Endpoint Template (With Middleware - Recommended)

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/middleware/base/masterfabric_endpoint.dart';
import '../../core/middleware/base/middleware_config.dart';
import '../../core/rate_limit/services/rate_limit_service.dart';

class <ServiceName>Endpoint extends MasterfabricEndpoint {
  // Configure middleware for this endpoint
  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
    customRateLimit: RateLimitConfig(
      maxRequests: 60,
      windowDuration: Duration(minutes: 1),
      keyPrefix: '<service_name>',
    ),
  );

  @override
  bool get requireLogin => false; // Set true for auth required

  Future<<ServiceName>Response> get(Session session) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'get',
      parameters: {},
      handler: () async {
        // Your clean business logic - no boilerplate!
        return <ServiceName>Response(/* ... */);
      },
    );
  }
}
```

### Endpoint Template (Legacy - Manual Rate Limiting)

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/rate_limit/services/rate_limit_service.dart';

class <ServiceName>Endpoint extends Endpoint {
  static const _rateLimitConfig = RateLimitConfig(
    maxRequests: 60,
    windowDuration: Duration(minutes: 1),
    keyPrefix: '<service_name>',
  );

  @override
  bool get requireLogin => false;

  Future<<ServiceName>Response> get(Session session) async {
    final identifier = _getRateLimitIdentifier(session);
    await RateLimitService.checkLimit(session, _rateLimitConfig, identifier);
    
    session.log('Processing <service_name>', level: LogLevel.info);
    
    return <ServiceName>Response(/* ... */);
  }

  String _getRateLimitIdentifier(Session session) {
    final auth = session.authenticated;
    return auth != null 
        ? 'user:${auth.userIdentifier}' 
        : 'anonymous:<service_name>';
  }
}
```

### Model Template (.spy.yaml)

```yaml
### Response model
class: <ServiceName>Response
fields:
  success: bool
  message: String
  data: String?
  timestamp: DateTime
```

### Generate Code

```bash
cd masterfabric_serverpod_server && serverpod generate
```

## Middleware System

The project includes a comprehensive middleware/interceptor system for automatic request handling.

### Using Middleware (Recommended)

Extend `MasterfabricEndpoint` instead of `Endpoint` for automatic middleware:

```dart
import '../../core/middleware/base/masterfabric_endpoint.dart';
import '../../core/middleware/base/middleware_config.dart';

class MyEndpoint extends MasterfabricEndpoint {
  // Optional: Configure middleware for this endpoint
  @override
  EndpointMiddlewareConfig? get middlewareConfig => EndpointMiddlewareConfig(
    customRateLimit: RateLimitConfig(
      maxRequests: 20,
      windowDuration: Duration(minutes: 1),
      keyPrefix: 'my_endpoint',
    ),
  );

  Future<MyResponse> myMethod(Session session, String param) async {
    return executeWithMiddleware(
      session: session,
      methodName: 'myMethod',
      parameters: {'param': param},
      handler: () async {
        // Your clean business logic here - no boilerplate!
        return MyResponse(success: true);
      },
    );
  }
}
```

### Middleware Features

The middleware system automatically handles:

| Middleware | Priority | Function |
|------------|----------|----------|
| **Logging** | 10 | Request/response logging with PII masking |
| **Rate Limit** | 20 | Distributed rate limiting with Redis |
| **Auth** | 30 | Authentication and RBAC checks |
| **Validation** | 40 | Request parameter validation |
| **Metrics** | 100 | Request metrics collection |
| **Error** | 999 | Global error handling |

### Per-Method Configuration

Override middleware for specific methods:

```dart
Future<MyResponse> publicMethod(Session session) async {
  return executeWithMiddleware(
    session: session,
    methodName: 'publicMethod',
    parameters: {},
    config: const EndpointMiddlewareConfig(
      skipAuth: true,  // No auth required
      skipRateLimit: true,  // No rate limiting
    ),
    handler: () async {
      return MyResponse(success: true);
    },
  );
}
```

### Available Configuration Options

```dart
EndpointMiddlewareConfig(
  skipLogging: false,      // Skip request logging
  skipRateLimit: false,    // Skip rate limiting
  skipAuth: false,         // Skip authentication
  skipValidation: false,   // Skip validation
  skipMetrics: false,      // Skip metrics collection
  customRateLimit: null,   // Custom rate limit config
  requiredPermissions: [], // Required RBAC permissions
  requiredRoles: [],       // Required user roles
  validationRules: {},     // Custom validation rules
);
```

## Core Utilities

### Rate Limiting

```dart
import '../../core/rate_limit/rate_limit_service.dart';

// Configure
static const _config = RateLimitConfig(
  maxRequests: 20,
  windowDuration: Duration(minutes: 1),
  keyPrefix: 'my_endpoint',
);

// Check (throws RateLimitException if exceeded)
await RateLimitService.checkLimit(session, _config, identifier);

// Get info for response headers
final info = await RateLimitService.getRateLimitInfo(session, _config, identifier);
```

### Caching

```dart
// Local cache (in-memory)
await session.caches.local.put('key', myObject, lifetime: Duration(minutes: 5));
final cached = await session.caches.local.get<MyType>('key');

// Global cache (Redis - shared across instances)
await session.caches.global.put('key', myObject, lifetime: Duration(hours: 1));
```

### Real-Time Notifications

```dart
import '../../core/real_time/notifications_center/services/notification_service.dart';

// Send to specific user
await NotificationService.sendToUser(
  session,
  userId: 'user-123',
  title: 'Hello',
  body: 'You have a new message',
);

// Broadcast to channel (cached for high volume)
await NotificationService.broadcast(
  session,
  channelId: 'announcements',
  title: 'New Feature',
  body: 'Check out our latest update!',
);
```

### Logging

```dart
session.log('Info message', level: LogLevel.info);
session.log('Debug details', level: LogLevel.debug);
session.log('Error occurred: $e', level: LogLevel.error);
```

### Authentication Check

```dart
// In endpoint
@override
bool get requireLogin => true;

// Manual check
final auth = session.authenticated;
if (auth == null) throw AuthenticationError('Not authenticated');
final userId = auth.userIdentifier;
```

## Streaming Endpoints (Real-Time)

For WebSocket streaming endpoints:

```dart
class MyStreamEndpoint extends Endpoint {
  /// Subscribe to real-time updates
  Stream<MyEvent> subscribe(Session session, String channelId) async* {
    // Validate access
    final userId = session.authenticated?.userIdentifier.toString();
    
    // Get stream controller for channel
    final controller = MyChannelService.getStream(channelId);
    
    try {
      await for (final event in controller.stream) {
        yield event;
      }
    } finally {
      // Cleanup on disconnect
    }
  }
}
```

## Model Definitions (.spy.yaml)

```yaml
### Basic model
class: MyModel
fields:
  id: int
  name: String
  createdAt: DateTime
  metadata: String?      # Nullable field

### Enum
enum: MyStatus
values:
  - pending
  - active
  - completed

### With relations
class: Order
fields:
  userId: int
  items: List<OrderItem>
  
### Database table
class: UserProfile
table: user_profiles
fields:
  id: int
  userId: int
  bio: String?
```

## Error Handling

```yaml
# Custom exception (create .spy.yaml)
class: PaymentError
serverOnly: true
fields:
  code: String
  message: String
```

```dart
// Throw in endpoint
throw PaymentError(code: 'INSUFFICIENT_FUNDS', message: 'Not enough balance');
```

## Checklist for New Services

- [ ] Create directory in `lib/src/services/` (use snake_case)
- [ ] Create `*_endpoint.dart` extending `MasterfabricEndpoint` (recommended)
- [ ] Use `executeWithMiddleware()` for automatic rate limiting, logging, auth
- [ ] Create `*_service.dart` for business logic
- [ ] Create `*_response.spy.yaml` model
- [ ] Run `serverpod generate`
- [ ] Add tests if needed
- [ ] Update health endpoint if critical service
- [ ] For complex modules, use the organized pattern (endpoints/, models/, services/, integrations/)
