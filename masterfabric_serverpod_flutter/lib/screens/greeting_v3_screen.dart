import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

import '../main.dart';

/// Test screen for the GreetingV3Endpoint with RBAC (Role-Based Access Control)
///
/// This screen demonstrates the new RBAC-enabled endpoint that provides:
/// - Role-based access control (user, admin, moderator roles)
/// - Permission-based access control
/// - Public endpoints that bypass authentication
/// - Combined RBAC + rate limiting
///
/// Available methods for testing:
/// 1. `publicHello` - No auth required (public)
/// 2. `hello` - Requires 'user' role
/// 3. `goodbye` - Requires 'user' role
/// 4. `adminHello` - Requires 'user' OR 'admin' role
/// 5. `moderatorHello` - Requires 'moderator' OR 'admin' role
/// 6. `deleteGreeting` - Requires 'user' AND 'admin' role (both!)
/// 7. `strictHello` - Requires 'user' role + strict rate limit
class GreetingV3Screen extends StatefulWidget {
  const GreetingV3Screen({super.key});

  @override
  State<GreetingV3Screen> createState() => _GreetingV3ScreenState();
}

class _GreetingV3ScreenState extends State<GreetingV3Screen> {
  final _nameController = TextEditingController(text: 'World');
  final _greetingIdController = TextEditingController(text: 'greeting-123');
  
  bool _isLoading = false;
  String? _selectedMethod = 'publicHello';
  
  GreetingResponse? _response;
  bool? _deleteResult;
  String? _error;
  String? _errorCode;
  RateLimitException? _rateLimitError;
  
  int _requestCount = 0;
  DateTime? _lastRequestTime;

  final List<_MethodOption> _methods = [
    _MethodOption(
      id: 'publicHello',
      title: 'Public Hello',
      description: 'No auth required',
      icon: LucideIcons.globe,
      color: Colors.green,
      roleInfo: 'Public',
      requiresGreetingId: false,
    ),
    _MethodOption(
      id: 'hello',
      title: 'Hello (User)',
      description: 'Requires user role',
      icon: LucideIcons.user,
      color: Colors.blue,
      roleInfo: 'user',
      requiresGreetingId: false,
    ),
    _MethodOption(
      id: 'goodbye',
      title: 'Goodbye (User)',
      description: 'Requires user role',
      icon: LucideIcons.logOut,
      color: Colors.indigo,
      roleInfo: 'user',
      requiresGreetingId: false,
    ),
    _MethodOption(
      id: 'adminHello',
      title: 'Admin Hello',
      description: 'Requires user OR admin role',
      icon: LucideIcons.shield,
      color: Colors.purple,
      roleInfo: 'user | admin',
      requiresGreetingId: false,
    ),
    _MethodOption(
      id: 'moderatorHello',
      title: 'Moderator Hello',
      description: 'Requires moderator OR admin role',
      icon: LucideIcons.userCog,
      color: Colors.orange,
      roleInfo: 'moderator | admin',
      requiresGreetingId: false,
    ),
    _MethodOption(
      id: 'deleteGreeting',
      title: 'Delete Greeting',
      description: 'Requires user AND admin (both!)',
      icon: LucideIcons.trash2,
      color: Colors.red,
      roleInfo: 'user & admin',
      requiresGreetingId: true,
    ),
    _MethodOption(
      id: 'strictHello',
      title: 'Strict Hello',
      description: 'User role + 5 req/min limit',
      icon: LucideIcons.shieldAlert,
      color: Colors.amber,
      roleInfo: 'user + rate limit',
      requiresGreetingId: false,
    ),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _greetingIdController.dispose();
    super.dispose();
  }

  Future<void> _sendRequest() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _errorCode = null;
      _rateLimitError = null;
      _deleteResult = null;
    });

    try {
      switch (_selectedMethod) {
        case 'publicHello':
          final response = await client.greetingV3.publicHello(_nameController.text);
          setState(() => _response = response);
          break;
        case 'hello':
          final response = await client.greetingV3.hello(_nameController.text);
          setState(() => _response = response);
          break;
        case 'goodbye':
          final response = await client.greetingV3.goodbye(_nameController.text);
          setState(() => _response = response);
          break;
        case 'adminHello':
          final response = await client.greetingV3.adminHello(_nameController.text);
          setState(() => _response = response);
          break;
        case 'moderatorHello':
          final response = await client.greetingV3.moderatorHello(_nameController.text);
          setState(() => _response = response);
          break;
        case 'deleteGreeting':
          final result = await client.greetingV3.deleteGreeting(_greetingIdController.text);
          setState(() {
            _deleteResult = result;
            _response = null;
          });
          break;
        case 'strictHello':
          final response = await client.greetingV3.strictHello(_nameController.text);
          setState(() => _response = response);
          break;
      }

      setState(() {
        _requestCount++;
        _lastRequestTime = DateTime.now();
      });
    } on RateLimitException catch (e) {
      setState(() {
        _rateLimitError = e;
        _response = null;
      });
    } on MiddlewareError catch (e) {
      setState(() {
        _error = e.message;
        _errorCode = e.code;
        _response = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _response = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearResults() {
    setState(() {
      _response = null;
      _deleteResult = null;
      _error = null;
      _errorCode = null;
      _rateLimitError = null;
      _requestCount = 0;
      _lastRequestTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedMethod = _methods.firstWhere((m) => m.id == _selectedMethod);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Greeting V3 (RBAC)'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.refreshCw),
            onPressed: _clearResults,
            tooltip: 'Clear Results',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              _buildHeaderCard(),
              const SizedBox(height: 16),

              // Input Section
              _buildInputSection(selectedMethod),
              const SizedBox(height: 16),

              // Method Selector
              _buildMethodSelector(),
              const SizedBox(height: 16),

              // Send Button
              _buildSendButton(),
              const SizedBox(height: 24),

              // Rate Limit Error
              if (_rateLimitError != null) ...[
                _buildRateLimitCard(),
                const SizedBox(height: 16),
              ],

              // Auth/Role Error
              if (_error != null) ...[
                _buildErrorCard(),
                const SizedBox(height: 16),
              ],

              // Delete Result
              if (_deleteResult != null) ...[
                _buildDeleteResultCard(),
                const SizedBox(height: 16),
              ],

              // Response Card
              if (_response != null) ...[
                _buildResponseCard(),
                const SizedBox(height: 16),
              ],

              // Stats Card
              if (_requestCount > 0) _buildStatsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.indigo.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.shieldCheck,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RBAC System Test',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'GreetingV3Endpoint with Role-Based Access',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeatureChip('Public', LucideIcons.globe),
              _buildFeatureChip('User', LucideIcons.user),
              _buildFeatureChip('Admin', LucideIcons.shield),
              _buildFeatureChip('Moderator', LucideIcons.userCog),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputSection(_MethodOption method) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!method.requiresGreetingId) ...[
            const Text(
              'Enter Name',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Enter your name...',
                prefixIcon: const Icon(LucideIcons.user),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.purple, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ] else ...[
            const Text(
              'Enter Greeting ID',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _greetingIdController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: 'Enter greeting ID to delete...',
                prefixIcon: const Icon(LucideIcons.hash),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Endpoint Method',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          ..._methods.map((method) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildMethodOption(method),
          )),
        ],
      ),
    );
  }

  Widget _buildMethodOption(_MethodOption method) {
    final isSelected = _selectedMethod == method.id;
    
    return GestureDetector(
      onTap: () {
        if (!_isLoading) {
          setState(() => _selectedMethod = method.id);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? method.color.withAlpha(25) : Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? method.color : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? method.color.withAlpha(50) : Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method.icon,
                color: isSelected ? method.color : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? method.color : Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: method.color.withAlpha(25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          method.roleInfo,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: method.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.description,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(LucideIcons.circleCheck, color: method.color, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendRequest,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.send, size: 18),
                  SizedBox(width: 8),
                  Text('Send Request', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                ],
              ),
      ),
    );
  }

  Widget _buildErrorCard() {
    final isAuthError = _errorCode == 'AUTH_REQUIRED' || 
                        _errorCode == 'ROLE_DENIED' || 
                        _errorCode == 'PERMISSION_DENIED';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAuthError ? Colors.orange.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAuthError ? Colors.orange.shade200 : Colors.red.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isAuthError ? Colors.orange.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isAuthError ? LucideIcons.shieldX : LucideIcons.circleX,
                  color: isAuthError ? Colors.orange.shade700 : Colors.red.shade600,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAuthError ? 'Access Denied' : 'Error',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isAuthError ? Colors.orange.shade800 : Colors.red.shade700,
                      ),
                    ),
                    if (_errorCode != null)
                      Text(
                        'Code: $_errorCode',
                        style: TextStyle(
                          fontSize: 11,
                          color: isAuthError ? Colors.orange.shade600 : Colors.red.shade600,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _error!,
            style: TextStyle(
              color: isAuthError ? Colors.orange.shade700 : Colors.red.shade700,
            ),
          ),
          if (isAuthError) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.info, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You need the required role to access this endpoint. '
                      'Try "Public Hello" which requires no authentication.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRateLimitCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(LucideIcons.triangleAlert, color: Colors.orange.shade700, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rate Limit Exceeded',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                    ),
                    Text(
                      _rateLimitError?.message ?? 'Too many requests',
                      style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildRateLimitStat('Limit', '${_rateLimitError?.limit ?? 0}', Colors.orange),
              const SizedBox(width: 12),
              _buildRateLimitStat('Current', '${_rateLimitError?.current ?? 0}', Colors.red),
              const SizedBox(width: 12),
              _buildRateLimitStat('Retry', '${_rateLimitError?.retryAfterSeconds ?? 0}s', Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRateLimitStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteResultCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _deleteResult! ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _deleteResult! ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _deleteResult! ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _deleteResult! ? LucideIcons.check : LucideIcons.x,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _deleteResult! ? 'Greeting Deleted' : 'Delete Failed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _deleteResult! ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                ),
                Text(
                  'Greeting ID: ${_greetingIdController.text}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withAlpha(25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(LucideIcons.check, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Response Received',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildResponseRow('Message', _response!.message, LucideIcons.messageSquare, Colors.blue),
                const SizedBox(height: 12),
                _buildResponseRow('Author', _response!.author, LucideIcons.user, Colors.purple),
                const SizedBox(height: 12),
                _buildResponseRow('Timestamp', _formatTimestamp(_response!.timestamp), LucideIcons.clock, Colors.teal),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.gauge, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            'Rate Limit Info',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildMiniStat('Max', '${_response!.rateLimitMax}'),
                          _buildMiniStat('Current', '${_response!.rateLimitCurrent}'),
                          _buildMiniStat('Remaining', '${_response!.rateLimitRemaining}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.chartBar, color: Colors.grey[600], size: 18),
              const SizedBox(width: 8),
              Text('Session Statistics', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey[700])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Total Requests', '$_requestCount', LucideIcons.send, Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Last Request',
                  _lastRequestTime != null ? _formatTimestamp(_lastRequestTime!) : '-',
                  LucideIcons.clock,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }
}

class _MethodOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String roleInfo;
  final bool requiresGreetingId;

  const _MethodOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.roleInfo,
    required this.requiresGreetingId,
  });
}
