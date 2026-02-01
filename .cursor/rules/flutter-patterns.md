# Flutter Development Patterns

## Service Pattern (ChangeNotifier)

```dart
class MyService extends ChangeNotifier {
  static MyService? _instance;
  static MyService get instance => _instance ??= MyService._();
  MyService._();

  Client? _client;
  
  // State
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;
  
  final List<MyItem> _items = [];
  List<MyItem> get items => List.unmodifiable(_items);

  /// Initialize with Serverpod client
  void initialize(Client client) {
    _client = client;
  }

  /// Load data
  Future<void> load() async {
    if (_client == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _client!.myEndpoint.getData();
      if (response.success) {
        _items.clear();
        _items.addAll(response.data);
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Failed to load: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

## Screen Pattern

```dart
class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final MyService _service = MyService.instance;

  @override
  void initState() {
    super.initState();
    _service.addListener(_onUpdate);
    _load();
  }

  @override
  void dispose() {
    _service.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    await _service.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_service.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_service.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_service.error!),
            ElevatedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    if (_service.items.isEmpty) {
      return const Center(child: Text('No items'));
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _service.items.length,
        itemBuilder: (context, index) {
          final item = _service.items[index];
          return ListTile(title: Text(item.name));
        },
      ),
    );
  }
}
```

## Widget Patterns

### Avoid Overflow

```dart
// Always use Expanded/Flexible in Rows
Row(
  children: [
    Expanded(child: Text(longText, maxLines: 1, overflow: TextOverflow.ellipsis)),
    const SizedBox(width: 8),
    Text(shortText),
  ],
)

// Wrap horizontal scrollable content
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [...]),
)
```

### Safe Area

```dart
SafeArea(
  child: Scaffold(
    body: ...,
  ),
)
```

## Client Initialization

```dart
// In main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = Client('http://localhost:8080/')
    ..connectivityMonitor = FlutterConnectivityMonitor();

  // Initialize services
  MyService.instance.initialize(client);
  HealthService.instance.initialize(client);
  NotificationService.instance.initialize(client);

  runApp(const MyApp());
}
```

## Real-Time Streams

```dart
class NotificationService extends ChangeNotifier {
  StreamSubscription<Notification>? _subscription;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Future<void> subscribe(List<String> channelIds) async {
    await _subscription?.cancel();
    
    final stream = _client!.notificationStream.subscribe(channelIds);
    _subscription = stream.listen(
      _onNotification,
      onError: _onError,
      onDone: _onDone,
    );
    
    _isConnected = true;
    notifyListeners();
  }

  void _onNotification(Notification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void _onError(Object error) {
    _isConnected = false;
    _error = 'Stream error: $error';
    notifyListeners();
  }

  void _onDone() {
    _isConnected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

## Import Conventions

```dart
// Flutter
import 'package:flutter/material.dart' hide Notification; // Hide conflicts

// Packages
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Generated client
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

// Local
import '../services/my_service.dart';
import 'my_widget.dart';
```
