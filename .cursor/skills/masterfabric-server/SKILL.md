---
name: masterfabric-server
description: Create Serverpod services, endpoints, and models for MasterFabric server. Use when creating new API endpoints, services, database models, or modifying server-side code. Includes rate limiting, caching, authentication, and i18n patterns.
---

# MasterFabric Serverpod Server

## Project Structure

```
masterfabric_serverpod_server/
├── lib/src/
│   ├── core/                    # Shared utilities
│   │   ├── rate_limit/          # Rate limiting service
│   │   ├── exceptions/          # Custom exceptions
│   │   ├── integrations/        # Firebase, Sentry, Mixpanel
│   │   ├── logging/             # Structured logging
│   │   └── session/             # Session management
│   ├── services/                # Business logic (ADD NEW SERVICES HERE)
│   │   ├── auth/                # Authentication endpoints
│   │   ├── greetings/           # Example with rate limit
│   │   ├── health/              # Health check endpoint
│   │   ├── translations/        # i18n service
│   │   └── app_config/          # Remote config
│   └── generated/               # Auto-generated (DO NOT EDIT)
└── assets/i18n/                 # Translation files (en, tr, de, es)
```

## Creating a New Service

### Step 1: Create Directory

```bash
mkdir -p lib/src/services/<service_name>/
```

### Step 2: Create Endpoint

**File:** `<service_name>_endpoint.dart`

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/rate_limit/rate_limit_service.dart';

class <ServiceName>Endpoint extends Endpoint {
  // Rate limit: 60 requests/minute
  static const _rateLimitConfig = RateLimitConfig(
    maxRequests: 60,
    windowDuration: Duration(minutes: 1),
    keyPrefix: '<service_name>',
  );

  @override
  bool get requireLogin => false; // Set true for auth required

  Future<<ServiceName>Response> get(Session session) async {
    // Rate limit check
    final identifier = _getRateLimitIdentifier(session);
    await RateLimitService.checkLimit(session, _rateLimitConfig, identifier);
    
    // Your logic here
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

### Step 3: Create Service (Business Logic)

**File:** `<service_name>_service.dart`

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class <ServiceName>Service {
  Future<<ServiceName>Response> process(Session session) async {
    // Business logic here
    return <ServiceName>Response(/* ... */);
  }
}
```

### Step 4: Create Models

**File:** `<service_name>_response.spy.yaml`

```yaml
### Response model
class: <ServiceName>Response
fields:
  success: bool
  message: String
  data: String?
  timestamp: DateTime
```

### Step 5: Generate Code

```bash
cd masterfabric_serverpod_server && serverpod generate
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

## Model Definitions (.spy.yaml)

```yaml
### Basic model
class: MyModel
fields:
  id: int
  name: String
  createdAt: DateTime
  metadata: String?      # Nullable field

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

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Directory | snake_case | `payment_gateway/` |
| Endpoint | PascalCase + Endpoint | `PaymentGatewayEndpoint` |
| Service | PascalCase + Service | `PaymentGatewayService` |
| Model file | snake_case.spy.yaml | `payment_response.spy.yaml` |
| Model class | PascalCase | `PaymentResponse` |

## Error Handling

```dart
// Custom exception (create .spy.yaml)
class: PaymentError
serverOnly: true
fields:
  code: String
  message: String

// Throw in endpoint
throw PaymentError(code: 'INSUFFICIENT_FUNDS', message: 'Not enough balance');
```

## Checklist for New Services

- [ ] Create directory in `lib/src/services/`
- [ ] Create `*_endpoint.dart` with rate limiting
- [ ] Create `*_service.dart` for business logic
- [ ] Create `*_response.spy.yaml` model
- [ ] Run `serverpod generate`
- [ ] Add tests if needed
- [ ] Update health endpoint if critical service
