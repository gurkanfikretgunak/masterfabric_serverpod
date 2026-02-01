# Create Server Service

Create a new Serverpod service with endpoint, service class, and models.

## Usage

```
/create-server-service <service_name> [--complex]
```

## Arguments

- `service_name` - Name of the service in snake_case (e.g., `payment`, `notification`, `analytics`)
- `--complex` - Use the module pattern with subdirectories (optional)

## Simple Service (Default)

Creates a flat structure for simple services:

```
masterfabric_serverpod_server/lib/src/services/<service_name>/
├── <service_name>_endpoint.dart    # API endpoint
├── <service_name>_service.dart     # Business logic
└── <service_name>_response.spy.yaml # Response model
```

## Complex Service (--complex flag)

Creates an organized module structure for complex services:

```
masterfabric_serverpod_server/lib/src/services/<service_name>/
├── <service_name>.dart             # Barrel export file
├── endpoints/
│   └── <service_name>_endpoint.dart
├── models/
│   ├── <service_name>_response.spy.yaml
│   └── <service_name>_request.spy.yaml
├── services/
│   └── <service_name>_service.dart
└── integrations/                   # (if external APIs needed)
    └── external_provider.dart
```

## Instructions

### 1. Create the Service Directory

**Simple:**
```bash
mkdir -p lib/src/services/<service_name>/
```

**Complex:**
```bash
mkdir -p lib/src/services/<service_name>/{endpoints,models,services,integrations}
touch lib/src/services/<service_name>/<service_name>.dart
```

### 2. Create the Endpoint

**File:** `<service_name>_endpoint.dart` (or `endpoints/<service_name>_endpoint.dart` for complex)

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';
import '../../core/rate_limit/rate_limit_service.dart';

/// <ServiceName> endpoint - handles <description>
class <ServiceName>Endpoint extends Endpoint {
  // Rate limit: 60 requests/minute
  static const _rateLimitConfig = RateLimitConfig(
    maxRequests: 60,
    windowDuration: Duration(minutes: 1),
    keyPrefix: '<service_name>',
  );

  @override
  bool get requireLogin => false; // Set true if auth required

  /// Main endpoint method
  Future<<ServiceName>Response> get<ServiceName>(Session session) async {
    // Rate limit check
    final identifier = _getRateLimitIdentifier(session);
    await RateLimitService.checkLimit(session, _rateLimitConfig, identifier);
    
    session.log('Processing <service_name> request', level: LogLevel.info);
    
    try {
      // TODO: Implement business logic
      return <ServiceName>Response(
        success: true,
        message: '<ServiceName> processed successfully',
        timestamp: DateTime.now(),
      );
    } catch (e) {
      session.log('Error in <service_name>: $e', level: LogLevel.error);
      rethrow;
    }
  }

  String _getRateLimitIdentifier(Session session) {
    final auth = session.authenticated;
    return auth != null 
        ? 'user:${auth.userIdentifier}' 
        : 'anonymous:<service_name>';
  }
}
```

### 3. Create the Service

**File:** `<service_name>_service.dart` (or `services/<service_name>_service.dart` for complex)

```dart
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

/// Internal service for <service_name> business logic
class <ServiceName>Service {
  /// Process <service_name> request
  static Future<<ServiceName>Response> process(Session session) async {
    // TODO: Implement business logic
    
    return <ServiceName>Response(
      success: true,
      message: '<ServiceName> processed successfully',
      timestamp: DateTime.now(),
    );
  }
}
```

### 4. Create the Response Model

**File:** `<service_name>_response.spy.yaml` (or `models/<service_name>_response.spy.yaml` for complex)

```yaml
### <ServiceName> response model
class: <ServiceName>Response
fields:
  success: bool
  message: String
  timestamp: DateTime
  data: String?
```

### 5. Create Barrel Export (Complex Only)

**File:** `<service_name>.dart`

```dart
/// <ServiceName> Module
/// 
/// <Description of the service>

// Services
export 'services/<service_name>_service.dart';

// Endpoints
export 'endpoints/<service_name>_endpoint.dart';
```

### 6. Generate Serverpod Code

```bash
cd masterfabric_serverpod_server && serverpod generate
```

## Examples

### Basic Service

```
/create-server-service payment
```

Creates:
- `payment_endpoint.dart`
- `payment_service.dart`
- `payment_response.spy.yaml`

### Complex Service

```
/create-server-service payment --complex
```

Creates:
```
payment/
├── payment.dart
├── endpoints/
│   └── payment_endpoint.dart
├── models/
│   └── payment_response.spy.yaml
└── services/
    └── payment_service.dart
```

## Adding Features

### With Authentication

Set `requireLogin => true` in the endpoint.

### With Rate Limiting

Already included in template. Adjust `maxRequests` and `windowDuration`.

### With Caching

```dart
// Local cache (in-memory)
await session.caches.local.put(key, value, lifetime: Duration(minutes: 5));
final cached = await session.caches.local.get<MyType>(key);

// Global cache (Redis - shared across instances)
await session.caches.global.put(key, value, lifetime: Duration(hours: 1));
```

### With Streaming (WebSocket)

Add a streaming endpoint:

```dart
/// Subscribe to real-time updates
Stream<MyEvent> subscribe(Session session, List<String> channelIds) async* {
  // Implementation
}
```

## Naming Conventions

| Item | Convention | Example |
|------|------------|---------|
| Directory | snake_case | `payment_gateway/` |
| Endpoint class | PascalCase + Endpoint | `PaymentGatewayEndpoint` |
| Service class | PascalCase + Service | `PaymentGatewayService` |
| Response model | PascalCase + Response | `PaymentGatewayResponse` |
| File names | snake_case | `payment_gateway_endpoint.dart` |

**Important:** Always use underscores (`_`) in folder names, never hyphens (`-`).

## Post-Creation Checklist

- [ ] Run `serverpod generate`
- [ ] Add any database models if needed
- [ ] Add integration tests
- [ ] Update README if public API
- [ ] Add rate limiting if needed
- [ ] Add caching strategy if needed
- [ ] Update health endpoint if critical service
