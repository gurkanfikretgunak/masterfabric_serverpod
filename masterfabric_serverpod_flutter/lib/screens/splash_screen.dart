import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

import '../main.dart';
import '../services/translation_service.dart';
import '../utils/responsive.dart';

/// Splash screen that shows server status on first boot.
/// 
/// This screen:
/// - Fetches server status from the public status endpoint
/// - Displays server info (name, version, environment, uptime, etc.)
/// - Shows a "Done" button to continue to the home screen
class SplashScreen extends StatefulWidget {
  /// The widget to navigate to after the splash screen
  final Widget child;

  const SplashScreen({
    super.key,
    required this.child,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  ServerStatus? _serverStatus;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _error;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _fetchServerStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchServerStatus({bool isRefresh = false}) async {
    setState(() {
      if (isRefresh) {
        _isRefreshing = true;
      } else {
        _isLoading = true;
        _error = null;
      }
    });

    try {
      final status = await client.status.getStatus();
      setState(() {
        _serverStatus = status;
        if (isRefresh) {
          _isRefreshing = false;
        } else {
          _isLoading = false;
          _animationController.forward();
          
          // Check maintenance mode only on initial load
          if (status.maintenanceMode) {
            _showMaintenanceBottomSheet();
          }
        }
      });
    } catch (e) {
      setState(() {
        if (isRefresh) {
          _isRefreshing = false;
          // Don't show error on refresh, just silently fail
        } else {
          _error = e.toString();
          _isLoading = false;
        }
      });
    }
  }

  void _continue() {
    // Only navigate if maintenance mode is false
    if (_serverStatus != null && _serverStatus!.maintenanceMode) {
      _showMaintenanceBottomSheet();
      return;
    }
    
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => widget.child),
    );
  }

  void _showMaintenanceBottomSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Icon(
                  Icons.build_rounded,
                  size: 48,
                  color: Colors.grey[600],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Title
              Text(
                tr('splash.maintenance.title'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Text(
                tr('splash.maintenance.description'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Check Again Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _fetchServerStatus();
                  },
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    tr('splash.maintenance.checkAgain'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[900],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveLayout(
          child: Column(
            children: [
              Expanded(
                child: _isLoading
                    ? _buildLoadingState()
                    : _error != null
                        ? _buildErrorState()
                        : _buildSuccessState(),
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Icon(
              Icons.hub_rounded,
              size: 40,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            tr('splash.title'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            tr('splash.subtitle'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[700]!),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tr('splash.loading'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 56,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              tr('splash.connectionFailed'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              tr('splash.connectionFailedDesc'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _fetchServerStatus,
              icon: const Icon(Icons.refresh),
              label: Text(tr('splash.retry')),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                side: BorderSide(color: Colors.grey[300]!),
                foregroundColor: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState() {
    final status = _serverStatus!;
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Icon(
                Icons.hub_rounded,
                size: 40,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              tr('splash.connected'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tr('splash.online'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Server Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey[200]!, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tr('splash.serverInfo'),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                      ),
                      _isRefreshing
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey[600]!,
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: () => _fetchServerStatus(isRefresh: true),
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              tooltip: tr('splash.retry'),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  const SizedBox(height: 20),

                  // Server Info Items
                  _buildInfoRow(
                    label: tr('splash.appName'),
                    value: status.appName,
                  ),
                  _buildInfoRow(
                    label: tr('splash.version'),
                    value: status.appVersion,
                    valueColor: Colors.grey[700],
                  ),
                  _buildInfoRow(
                    label: tr('splash.environment'),
                    value: status.environment.toUpperCase(),
                    valueColor: Colors.grey[700],
                  ),
                  _buildInfoRow(
                    label: tr('splash.uptime'),
                    value: status.uptime,
                    valueColor: Colors.grey[700],
                  ),
                  _buildInfoRow(
                    label: tr('splash.serverTime'),
                    value: dateFormat.format(status.serverTime),
                  ),
                  _buildInfoRow(
                    label: tr('splash.serverStartTime'),
                    value: dateFormat.format(status.serverStartTime),
                  ),

                  const SizedBox(height: 20),
                  Divider(height: 1, thickness: 1, color: Colors.grey[200]),
                  const SizedBox(height: 20),

                  // Status Indicators
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildStatusChip(
                        label: tr('splash.debugMode'),
                        isActive: status.debugMode,
                      ),
                      _buildStatusChip(
                        label: tr('splash.maintenanceMode'),
                        isActive: status.maintenanceMode,
                        activeColor: Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.grey[800],
                    fontSize: 14,
                  ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required bool isActive,
    Color? activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? Colors.grey[600] : Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    final isEnabled = !_isLoading && 
                      _error == null && 
                      _serverStatus != null && 
                      !_serverStatus!.maintenanceMode;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: isEnabled ? _continue : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[900],
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.grey[200],
            disabledForegroundColor: Colors.grey[400],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: isEnabled ? 2 : 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                tr('splash.continue'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
