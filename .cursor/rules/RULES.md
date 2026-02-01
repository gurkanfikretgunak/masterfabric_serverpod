# MasterFabric Serverpod - Project Rules

## Quick Reference

| Rule | Convention |
|------|------------|
| Folder names | `snake_case` (underscores, NOT hyphens) |
| File names | `snake_case.dart` or `snake_case.spy.yaml` |
| Class names | `PascalCase` |
| Endpoint class | `<Name>Endpoint` |
| Service class | `<Name>Service` |
| Response model | `<Name>Response` |

## Directory Structure

```
masterfabric_serverpod/
├── masterfabric_serverpod_server/     # Serverpod backend
│   ├── lib/src/
│   │   ├── core/                      # Shared utilities
│   │   │   └── real_time/             # Real-time features
│   │   │       └── notifications_center/  # Example module
│   │   ├── services/                  # Business services
│   │   └── generated/                 # DO NOT EDIT
│   └── config/                        # Environment configs
├── masterfabric_serverpod_client/     # Generated client
├── masterfabric_serverpod_flutter/    # Flutter app
│   └── lib/
│       ├── screens/                   # UI screens
│       ├── services/                  # Client services
│       └── widgets/                   # Reusable widgets
└── .cursor/
    ├── skills/                        # AI skills
    ├── commands/                      # Custom commands
    └── rules/                         # Project rules
```

## Essential Commands

```bash
# Generate Serverpod code (after model changes)
cd masterfabric_serverpod_server && serverpod generate

# Start dev server
./dev-server.sh

# Seed notifications
dart bin/seed_notifications.dart
```

## Key Patterns

### 1. Rate Limiting (All Endpoints)
```dart
await RateLimitService.checkLimit(session, _rateLimitConfig, identifier);
```

### 2. Caching (High-Volume Data)
```dart
await session.caches.global.put(key, model, lifetime: Duration(minutes: 15));
```

### 3. Real-Time Streaming
```dart
Stream<Notification> subscribe(Session session, List<String> channelIds) async* {
  // WebSocket streaming
}
```

### 4. Flutter Service Pattern
```dart
class MyService extends ChangeNotifier {
  static MyService get instance => _instance ??= MyService._();
  // Singleton with ChangeNotifier for UI updates
}
```

## Files in This Directory

- `project-structure.md` - Folder and file naming conventions
- `serverpod-patterns.md` - Server-side development patterns
- `flutter-patterns.md` - Flutter/client-side patterns

## Important Notes

1. **Always use underscores** in folder names (`real_time` not `real-time`)
2. **Run `serverpod generate`** after creating/modifying `.spy.yaml` files
3. **Use barrel exports** for complex modules
4. **Include rate limiting** on all public endpoints
5. **Cache high-volume data** (broadcasts, public configs)
