import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../main.dart';
import '../widgets/health_status_bar.dart';
import '../widgets/rate_limit_banner.dart';
import '../services/health_service.dart';

/// Service testing screen for development and debugging
class ServiceTestScreen extends StatefulWidget {
  const ServiceTestScreen({super.key});

  @override
  State<ServiceTestScreen> createState() => _ServiceTestScreenState();
}

class _ServiceTestScreenState extends State<ServiceTestScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Testing'),
        actions: const [
          HealthStatusIndicator(),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(LucideIcons.activity), text: 'Health'),
            Tab(icon: Icon(LucideIcons.plug), text: 'API'),
            Tab(icon: Icon(LucideIcons.lock), text: 'Auth'),
            Tab(icon: Icon(LucideIcons.gauge), text: 'Rate Limit'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _HealthTab(),
          _ApiTestTab(),
          _AuthTestTab(),
          _RateLimitTestTab(),
        ],
      ),
    );
  }
}

/// Health monitoring tab
class _HealthTab extends StatelessWidget {
  const _HealthTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const HealthStatusCard(),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => HealthService.instance.checkHealth(),
            icon: const Icon(LucideIcons.refreshCw),
            label: const Text('Run Health Check'),
          ),
          const SizedBox(height: 24),
          _buildAutoCheckToggle(),
        ],
      ),
    );
  }

  Widget _buildAutoCheckToggle() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Auto Health Check',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enable automatic health checks every 30 seconds',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => HealthService.instance.startAutoCheck(),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => HealthService.instance.stopAutoCheck(),
                  child: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// API testing tab
class _ApiTestTab extends StatefulWidget {
  const _ApiTestTab();

  @override
  State<_ApiTestTab> createState() => _ApiTestTabState();
}

class _ApiTestTabState extends State<_ApiTestTab> {
  final _nameController = TextEditingController(text: 'Test User');
  String? _greetingResult;
  String? _translationResult;
  String? _configResult;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildGreetingTest(),
          const SizedBox(height: 16),
          _buildTranslationTest(),
          const SizedBox(height: 16),
          _buildConfigTest(),
          if (_error != null) ...[
            const SizedBox(height: 16),
            _buildErrorCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildGreetingTest() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(LucideIcons.handMetal, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Greeting Service',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isLoading ? null : _testGreeting,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Test Greeting'),
            ),
            if (_greetingResult != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_greetingResult!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationTest() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(LucideIcons.languages, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Translation Service',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => _testTranslation('en'),
                  child: const Text('English'),
                ),
                ElevatedButton(
                  onPressed: () => _testTranslation('tr'),
                  child: const Text('Turkish'),
                ),
                ElevatedButton(
                  onPressed: () => _testTranslation('de'),
                  child: const Text('German'),
                ),
                ElevatedButton(
                  onPressed: () => _testTranslation('es'),
                  child: const Text('Spanish'),
                ),
              ],
            ),
            if (_translationResult != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _translationResult!,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigTest() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(LucideIcons.settings, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'App Config Service',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _testConfig,
              child: const Text('Load Config'),
            ),
            if (_configResult != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _configResult!,
                  maxLines: 10,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withAlpha(100)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.circleAlert, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red))),
          IconButton(
            icon: const Icon(LucideIcons.x),
            onPressed: () => setState(() => _error = null),
          ),
        ],
      ),
    );
  }

  Future<void> _testGreeting() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await client.greeting.hello(_nameController.text);
      setState(() {
        _greetingResult = '${response.message}\n'
            'Author: ${response.author}\n'
            'Rate Limit: ${response.rateLimitCurrent}/${response.rateLimitMax}\n'
            'Remaining: ${response.rateLimitRemaining}';
      });
    } on RateLimitException catch (e) {
      setState(() {
        _error = 'Rate limited! Retry in ${e.retryAfterSeconds}s';
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _testTranslation(String locale) async {
    setState(() => _error = null);

    try {
      final response = await client.translation.getTranslations(locale: locale);
      setState(() {
        _translationResult = 'Locale: ${response.locale}\n'
            'Data: ${response.translationsJson.substring(0, response.translationsJson.length.clamp(0, 200))}...';
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _testConfig() async {
    setState(() => _error = null);

    try {
      final config = await client.appConfig.getConfig();
      setState(() {
        _configResult = 'App: ${config.appSettings.appName}\n'
            'Version: ${config.appSettings.appVersion}\n'
            'Maintenance: ${config.appSettings.maintenanceMode}\n'
            'Onboarding: ${config.featureFlags.onboardingEnabled}\n'
            'Analytics: ${config.featureFlags.analyticsEnabled}';
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }
}

/// Auth testing tab
class _AuthTestTab extends StatefulWidget {
  const _AuthTestTab();

  @override
  State<_AuthTestTab> createState() => _AuthTestTabState();
}

class _AuthTestTabState extends State<_AuthTestTab> {
  bool _isSignedIn = false;
  String? _authStatus;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAuthStatusCard(),
          const SizedBox(height: 16),
          if (_isSignedIn) ...[
            _buildAuthenticatedActions(),
          ] else ...[
            _buildUnauthenticatedActions(),
          ],
          if (_error != null) ...[
            const SizedBox(height: 16),
            _buildErrorCard(),
          ],
        ],
      ),
    );
  }

  Widget _buildAuthStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _isSignedIn ? LucideIcons.lockOpen : LucideIcons.lock,
                  color: _isSignedIn ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  _isSignedIn ? 'Authenticated' : 'Not Authenticated',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _isSignedIn ? Colors.green : Colors.grey,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.refreshCw),
                  onPressed: _checkAuthStatus,
                ),
              ],
            ),
            if (_authStatus != null) ...[
              const Divider(),
              Text(_authStatus!, style: const TextStyle(fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAuthenticatedActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authenticated Actions',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _testGetProfile,
                  icon: const Icon(LucideIcons.user),
                  label: const Text('Get Profile'),
                ),
                ElevatedButton.icon(
                  onPressed: _testGetSessions,
                  icon: const Icon(LucideIcons.smartphone),
                  label: const Text('Get Sessions'),
                ),
                ElevatedButton.icon(
                  onPressed: _testPasswordValidation,
                  icon: const Icon(LucideIcons.keyRound),
                  label: const Text('Test Password'),
                ),
                OutlinedButton.icon(
                  onPressed: _signOut,
                  icon: const Icon(LucideIcons.logOut),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnauthenticatedActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Authentication Required',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to test authenticated endpoints.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to sign in or show sign in dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Navigate to Sign In screen to authenticate'),
                  ),
                );
              },
              icon: const Icon(LucideIcons.logIn),
              label: const Text('Go to Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.circleAlert, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red))),
          IconButton(
            icon: const Icon(LucideIcons.x),
            onPressed: () => setState(() => _error = null),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Try to get profile - will fail if not authenticated
      await client.userProfile.getProfile();
      setState(() {
        _isSignedIn = true;
        _authStatus = 'User is authenticated';
      });
    } catch (e) {
      // If profile fetch fails, user is likely not authenticated
      setState(() {
        _isSignedIn = false;
        _authStatus = 'Not authenticated (${e.toString().split(':').first})';
      });
    }
  }

  Future<void> _testGetProfile() async {
    try {
      final profile = await client.userProfile.getProfile();
      setState(() {
        _authStatus = 'Profile loaded:\n'
            'Name: ${profile.fullName ?? "N/A"}\n'
            'Username: ${profile.userName ?? "N/A"}';
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _testGetSessions() async {
    try {
      final sessions = await client.sessionManagement.getActiveSessions();
      setState(() {
        _authStatus = 'Active sessions: ${sessions.length}';
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _testPasswordValidation() async {
    try {
      final result = await client.passwordManagement.validatePasswordStrength(
        password: 'TestPassword123!',
      );
      setState(() {
        _authStatus = 'Password strength test:\n'
            'Score: ${result.score}/100\n'
            'Valid: ${result.isValid}';
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _signOut() async {
    try {
      await client.auth.signOutDevice();
      _checkAuthStatus();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }
}

/// Rate limit testing tab
class _RateLimitTestTab extends StatefulWidget {
  const _RateLimitTestTab();

  @override
  State<_RateLimitTestTab> createState() => _RateLimitTestTabState();
}

class _RateLimitTestTabState extends State<_RateLimitTestTab> {
  int _requestCount = 0;
  int _successCount = 0;
  int _rateLimitedCount = 0;
  bool _isTesting = false;
  RateLimitException? _lastRateLimitException;
  final List<String> _logs = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_lastRateLimitException != null)
            RateLimitBanner(
              exception: _lastRateLimitException!,
              onDismiss: () => setState(() => _lastRateLimitException = null),
            ),
          _buildStatsCard(),
          const SizedBox(height: 16),
          _buildTestControls(),
          const SizedBox(height: 16),
          _buildLogCard(),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rate Limit Statistics',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', _requestCount, Colors.blue),
                _buildStatItem('Success', _successCount, Colors.green),
                _buildStatItem('Limited', _rateLimitedCount, Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTestControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rate Limit Test',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Send multiple requests to test rate limiting (20 requests/minute)',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _isTesting ? null : () => _sendRequests(1),
                  child: const Text('Send 1'),
                ),
                ElevatedButton(
                  onPressed: _isTesting ? null : () => _sendRequests(5),
                  child: const Text('Send 5'),
                ),
                ElevatedButton(
                  onPressed: _isTesting ? null : () => _sendRequests(10),
                  child: const Text('Send 10'),
                ),
                ElevatedButton(
                  onPressed: _isTesting ? null : () => _sendRequests(25),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Send 25 (trigger limit)'),
                ),
                OutlinedButton(
                  onPressed: _resetStats,
                  child: const Text('Reset'),
                ),
              ],
            ),
            if (_isTesting) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Request Log',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.trash2),
                  onPressed: () => setState(() => _logs.clear()),
                  tooltip: 'Clear logs',
                ),
              ],
            ),
            const Divider(),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[_logs.length - 1 - index];
                  return Text(
                    log,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: log.contains('LIMIT') ? Colors.red : Colors.black87,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendRequests(int count) async {
    setState(() => _isTesting = true);

    for (var i = 0; i < count; i++) {
      _requestCount++;
      final timestamp = DateTime.now().toString().substring(11, 19);

      try {
        final response = await client.greeting.hello('RateTest-$i');
        _successCount++;
        _addLog('[$timestamp] #$_requestCount OK - ${response.rateLimitRemaining}/${response.rateLimitMax} remaining');
        setState(() {});
      } on RateLimitException catch (e) {
        _rateLimitedCount++;
        _lastRateLimitException = e;
        _addLog('[$timestamp] #$_requestCount RATE LIMIT - retry in ${e.retryAfterSeconds}s');
        setState(() {});
      } catch (e) {
        _addLog('[$timestamp] #$_requestCount ERROR - $e');
        setState(() {});
      }

      // Small delay between requests
      if (i < count - 1) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
    }

    setState(() => _isTesting = false);
  }

  void _addLog(String message) {
    _logs.add(message);
    if (_logs.length > 100) {
      _logs.removeAt(0);
    }
  }

  void _resetStats() {
    setState(() {
      _requestCount = 0;
      _successCount = 0;
      _rateLimitedCount = 0;
      _lastRateLimitException = null;
      _logs.clear();
    });
  }
}
