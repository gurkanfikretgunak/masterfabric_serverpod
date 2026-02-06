import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../services/translation_service.dart';
import '../services/app_config_service.dart';
import '../services/user_app_settings_service.dart';
import '../utils/responsive.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Settings screen with language selection, about info, and app settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isChangingLanguage = false;
  bool _isLoading = true;
  String? _error;
  final UserAppSettingsService _settingsService = UserAppSettingsService.instance();
  
  // Settings state (loaded from server)
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _notificationSound = true;
  bool _analytics = true;
  bool _crashReports = true;
  bool _twoFactorEnabled = false;

  String get _currentLocale => TranslationService.currentLocale;
  List<String> get _availableLocales => TranslationService.availableLocales;

  @override
  void initState() {
    super.initState();
    // Initialize loading state before checking service
    _isLoading = true;
    // Load data asynchronously - UI will show loading state until data is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
    // Listen to settings changes
    _settingsService.addListener(_onSettingsChanged);
  }

  @override
  void dispose() {
    _settingsService.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _onSettingsChanged() {
    if (_settingsService.settings != null) {
      setState(() {
        _pushNotifications = _settingsService.settings!.pushNotifications;
        _emailNotifications = _settingsService.settings!.emailNotifications;
        _notificationSound = _settingsService.settings!.notificationSound;
        _analytics = _settingsService.settings!.analytics;
        _crashReports = _settingsService.settings!.crashReports;
        _twoFactorEnabled = _settingsService.settings!.twoFactorEnabled;
      });
    }
  }

  Future<void> _loadSettings() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load settings from server (service handles authentication internally)
      await _settingsService.loadSettings();
      _onSettingsChanged();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(tr('settings.title')),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Main content - only show when loaded
          if (!_isLoading && _error == null)
            SafeArea(
              child: ResponsiveLayout(
                maxWidth: 700,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language Section
                      _buildSectionHeader(tr('settings.language.title')),
                      const SizedBox(height: 8),
                      _buildLanguageCard(),
                      const SizedBox(height: 24),

                      // Notifications Section
                      _buildSectionHeader(tr('settings.notifications.title')),
                      const SizedBox(height: 8),
                      _buildNotificationsCard(),
                      const SizedBox(height: 24),

                      // Privacy Section
                      _buildSectionHeader(tr('settings.privacy.title')),
                      const SizedBox(height: 8),
                      _buildPrivacyCard(),
                      const SizedBox(height: 24),

                      // About Section (App Info Card)
                      _buildSectionHeader(tr('settings.about.title')),
                      const SizedBox(height: 8),
                      _buildAboutCard(),
                      const SizedBox(height: 24),

                      // Cache Section
                      _buildCacheCard(),
                      const SizedBox(height: 24),

                      // Danger Zone
                      _buildDangerZoneCard(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          
          // Loading state
          if (_isLoading)
            _buildLoadingState(),
          
          // Error state
          if (_error != null && !_isLoading)
            _buildErrorState(),
          // Loading overlay
          if (_isChangingLanguage)
            Container(
              color: Colors.black.withAlpha(100),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tr('settings.language.changing'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Current language header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(LucideIcons.globe, color: Colors.blue.shade700, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('settings.language.subtitle'),
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${tr('settings.language.current')}: ',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _getLanguageName(_currentLocale),
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_isChangingLanguage)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          // Language options
          ..._availableLocales.map((locale) => _buildLanguageOption(locale)),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String locale) {
    final isSelected = locale == _currentLocale;
    final isLast = locale == _availableLocales.last;

    return InkWell(
      onTap: isSelected ? null : () => _changeLanguage(locale),
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(12))
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: isLast ? null : Border(bottom: BorderSide(color: Colors.grey.shade100)),
        ),
        child: Row(
          children: [
            Text(
              _getLanguageFlag(locale),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getLanguageName(locale),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.blue : Colors.grey[800],
                    ),
                  ),
                  Text(
                    locale.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(LucideIcons.circleCheck, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: LucideIcons.bell,
            title: tr('settings.notifications.push'),
            subtitle: tr('settings.notifications.pushDesc'),
            value: _pushNotifications,
            onChanged: (value) => _updateSetting('pushNotifications', value),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildSwitchTile(
            icon: LucideIcons.mail,
            title: tr('settings.notifications.email'),
            subtitle: tr('settings.notifications.emailDesc'),
            value: _emailNotifications,
            onChanged: (value) => _updateSetting('emailNotifications', value),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildSwitchTile(
            icon: LucideIcons.volume2,
            title: tr('settings.notifications.sound'),
            subtitle: tr('settings.notifications.soundDesc'),
            value: _notificationSound,
            onChanged: (value) => _updateSetting('notificationSound', value),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: LucideIcons.chartBar,
            title: tr('settings.privacy.analytics'),
            subtitle: tr('settings.privacy.analyticsDesc'),
            value: _analytics,
            onChanged: (value) => _updateSetting('analytics', value),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildSwitchTile(
            icon: LucideIcons.bug,
            title: tr('settings.privacy.crashReports'),
            subtitle: tr('settings.privacy.crashReportsDesc'),
            value: _crashReports,
            onChanged: (value) => _updateSetting('crashReports', value),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildSwitchTile(
            icon: LucideIcons.shield,
            title: tr('settings.privacy.twoFactor'),
            subtitle: tr('settings.privacy.twoFactorDesc'),
            value: _twoFactorEnabled,
            onChanged: (value) => _updateHardSetting('twoFactorEnabled', value),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    final config = AppConfigService.getConfig();
    final appName = config?.appSettings.appName ?? tr('app.name');
    final appVersion = config?.appSettings.appVersion ?? '1.0.0';
    final environment = config?.appSettings.environment ?? 'development';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // App Info Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.indigo.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.boxes,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          environment.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // App Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(tr('settings.about.version'), appVersion),
                const SizedBox(height: 12),
                _buildInfoRow(tr('settings.about.environment'), environment),
                const SizedBox(height: 12),
                _buildInfoRow(tr('about.auth'), tr('about.authDesc')),
                const SizedBox(height: 12),
                _buildInfoRow(tr('about.rateLimit'), tr('about.rateLimitDesc')),
                const SizedBox(height: 12),
                _buildInfoRow(tr('about.caching'), tr('about.cachingDesc')),
                const SizedBox(height: 12),
                _buildInfoRow(tr('about.i18n'), tr('about.i18nDesc')),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          // Links
          _buildLinkTile(
            icon: LucideIcons.fileText,
            title: tr('settings.about.licenses'),
            onTap: () => _showComingSoon(tr('settings.about.licenses')),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildLinkTile(
            icon: LucideIcons.shield,
            title: tr('settings.about.privacyPolicy'),
            onTap: () => _showComingSoon(tr('settings.about.privacyPolicy')),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildLinkTile(
            icon: LucideIcons.scroll,
            title: tr('settings.about.termsOfService'),
            onTap: () => _showComingSoon(tr('settings.about.termsOfService')),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinkTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(12))
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 14)),
            ),
            Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: _clearCache,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.trash2, color: Colors.orange.shade700, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('settings.cache.clear'),
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    Text(
                      tr('settings.cache.clearDesc'),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, color: Colors.grey.shade400, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(LucideIcons.triangleAlert, color: Colors.red.shade600, size: 18),
                const SizedBox(width: 8),
                Text(
                  tr('settings.danger.title'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.red.shade100),
          InkWell(
            onTap: _showDeleteAccountDialog,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(LucideIcons.userX, color: Colors.red.shade600, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr('settings.danger.deleteAccount'),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.red.shade700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          tr('settings.danger.deleteAccountDesc'),
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, color: Colors.red.shade400, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String locale) {
    return tr('languages.$locale');
  }

  String _getLanguageFlag(String locale) {
    switch (locale) {
      case 'en':
        return '🇺🇸';
      case 'tr':
        return '🇹🇷';
      case 'de':
        return '🇩🇪';
      case 'es':
        return '🇪🇸';
      default:
        return '🌐';
    }
  }

  Future<void> _changeLanguage(String locale) async {
    setState(() => _isChangingLanguage = true);

    try {
      // Load translations and wait minimum 1.5 seconds for smooth UX
      await Future.wait([
        TranslationService.changeLocale(client, locale),
        Future.delayed(const Duration(milliseconds: 1500)),
      ]);
      
      if (mounted) {
        setState(() => _isChangingLanguage = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('settings.language.changeSuccess', args: {'language': _getLanguageName(locale)})),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isChangingLanguage = false);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('settings.language.changeFailed')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateSetting(String settingName, bool value) async {
    // Update local state immediately for better UX
    setState(() {
      switch (settingName) {
        case 'pushNotifications':
          _pushNotifications = value;
          break;
        case 'emailNotifications':
          _emailNotifications = value;
          break;
        case 'notificationSound':
          _notificationSound = value;
          break;
        case 'analytics':
          _analytics = value;
          break;
        case 'crashReports':
          _crashReports = value;
          break;
      }
    });

    // Build update request
    final request = UserAppSettingsUpdateRequest(
      pushNotifications: settingName == 'pushNotifications' ? value : null,
      emailNotifications: settingName == 'emailNotifications' ? value : null,
      notificationSound: settingName == 'notificationSound' ? value : null,
      analytics: settingName == 'analytics' ? value : null,
      crashReports: settingName == 'crashReports' ? value : null,
    );

    // Update on server
    final success = await _settingsService.updateSettings(request);
    
    if (!success) {
      // Revert on error
      setState(() {
        switch (settingName) {
          case 'pushNotifications':
            _pushNotifications = !value;
            break;
          case 'emailNotifications':
            _emailNotifications = !value;
            break;
          case 'notificationSound':
            _notificationSound = !value;
            break;
          case 'analytics':
            _analytics = !value;
            break;
          case 'crashReports':
            _crashReports = !value;
            break;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_settingsService.error ?? 'Failed to update setting'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateHardSetting(String settingName, bool value) async {
    // Request verification code first
    final verificationCode = await _showVerificationCodeDialog();
    
    if (verificationCode == null) {
      // User cancelled
      return;
    }

    // Update local state
    setState(() {
      if (settingName == 'twoFactorEnabled') {
        _twoFactorEnabled = value;
      }
    });

    // Build update request with verification code
    final request = UserAppSettingsUpdateRequest(
      twoFactorEnabled: settingName == 'twoFactorEnabled' ? value : null,
      verificationCode: verificationCode,
    );

    // Update on server
    final success = await _settingsService.updateSettingsWithVerification(request);
    
    if (!success) {
      // Revert on error
      setState(() {
        if (settingName == 'twoFactorEnabled') {
          _twoFactorEnabled = !value;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_settingsService.error ?? 'Failed to update setting'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Setting updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<String?> _showVerificationCodeDialog() async {
    String? verificationCode;
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('settings.verification.title')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(tr('settings.verification.message')),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: tr('settings.verification.code'),
                hintText: '123456',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) => verificationCode = value,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () async {
                // Request verification code
                await _settingsService.updateSettings(
                  UserAppSettingsUpdateRequest(),
                  requireVerification: true,
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Verification code sent. Please check your email.'),
                  ),
                );
              },
              child: Text(tr('settings.verification.resend')),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr('common.cancel')),
          ),
          TextButton(
            onPressed: () {
              if (verificationCode != null && verificationCode!.isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
            child: Text(tr('common.confirm')),
          ),
        ],
      ),
    );

    if (result == true && verificationCode != null && verificationCode!.isNotEmpty) {
      return verificationCode;
    }
    return null;
  }

  void _clearCache() {
    // Simulate cache clearing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('settings.cache.cleared')),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('settings.danger.deleteAccount')),
        content: Text(tr('settings.danger.deleteAccountDesc')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('common.cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoon(tr('settings.danger.deleteAccount'));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(tr('common.delete')),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Icon(
                LucideIcons.settings,
                size: 48,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we fetch your preferences...',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade200, width: 1),
                ),
                child: Icon(
                  LucideIcons.circleAlert,
                  size: 48,
                  color: Colors.red.shade300,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Failed to Load Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadSettings,
                icon: const Icon(LucideIcons.refreshCw),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
