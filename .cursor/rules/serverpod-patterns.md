# Serverpod Development Patterns

## Endpoint Patterns

### Basic Endpoint

```dart
class MyEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<MyResponse> myMethod(Session session) async {
    session.log('Processing request', level: LogLevel.info);
    return MyResponse(success: true, timestamp: DateTime.now());
  }
}
```

### With Rate Limiting

```dart
class MyEndpoint extends Endpoint {
  static const _rateLimitConfig = RateLimitConfig(
    maxRequests: 60,
    windowDuration: Duration(minutes: 1),
    keyPrefix: 'my_endpoint',
  );

  Future<MyResponse> myMethod(Session session) async {
    final identifier = session.authenticated?.userIdentifier.toString() 
        ?? 'anonymous:my_endpoint';
    await RateLimitService.checkLimit(session, _rateLimitConfig, identifier);
    
    // ... rest of logic
  }
}
```

### Streaming Endpoint (WebSocket)

```dart
class MyStreamEndpoint extends Endpoint {
  Stream<MyEvent> subscribe(Session session, List<String> channelIds) async* {
    // Validate
    if (channelIds.isEmpty) {
      throw MyException(code: 'INVALID', message: 'No channels');
    }

    // Get stream controller
    final controller = MyChannelService.getStream(channelIds.first);

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

## Service Patterns

### Static Service Methods

```dart
class MyService {
  static Future<MyResponse> process(Session session, String input) async {
    // Business logic
    return MyResponse(/* ... */);
  }
}
```

### Caching Pattern

```dart
class MyCacheService {
  static const _cacheKeyPrefix = 'my_cache';
  static const _cacheTtl = Duration(minutes: 15);

  static Future<MyModel?> get(Session session, String id) async {
    final cacheKey = '$_cacheKeyPrefix:$id';
    try {
      return await session.caches.global.get<MyModel>(cacheKey);
    } catch (e) {
      return null;
    }
  }

  static Future<void> put(Session session, MyModel model) async {
    final cacheKey = '$_cacheKeyPrefix:${model.id}';
    await session.caches.global.put(cacheKey, model, lifetime: _cacheTtl);
  }

  static Future<void> invalidate(Session session, String id) async {
    final cacheKey = '$_cacheKeyPrefix:$id';
    await session.caches.global.invalidateKey(cacheKey);
  }
}
```

## Model Patterns

### Response Model

```yaml
class: MyResponse
fields:
  success: bool
  message: String
  timestamp: DateTime
  data: MyData?
```

### Enum

```yaml
enum: MyStatus
values:
  - pending
  - active
  - completed
  - cancelled
```

### Exception Model

```yaml
class: MyException
serverOnly: true
fields:
  code: String
  message: String
```

### Database Table

```yaml
class: MyTable
table: my_tables
fields:
  id: int
  name: String
  createdAt: DateTime
  updatedAt: DateTime
```

## Error Handling

```dart
try {
  // Operation
} on MyException catch (e) {
  return MyResponse(success: false, message: e.message);
} catch (e) {
  session.log('Unexpected error: $e', level: LogLevel.error);
  rethrow;
}
```

## Authentication

```dart
// Check if authenticated
final auth = session.authenticated;
if (auth == null) {
  throw AuthException(code: 'UNAUTHENTICATED', message: 'Login required');
}

// Get user ID
final userId = auth.userIdentifier.toString();
```

## Logging

```dart
session.log('Info message', level: LogLevel.info);
session.log('Debug: $data', level: LogLevel.debug);
session.log('Warning: $issue', level: LogLevel.warning);
session.log('Error: $e', level: LogLevel.error);
```

## Code Generation

After creating or modifying `.spy.yaml` files:

```bash
cd masterfabric_serverpod_server && serverpod generate
```
