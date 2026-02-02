import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../main.dart';
import '../services/translation_service.dart';
import '../services/app_config_service.dart';
import '../utils/responsive.dart';

/// Settings screen with language selection, about info, and app settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isChangingLanguage = false;
  
  // Settings state (these would normally come from shared preferences)
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _notificationSound = true;
  bool _analytics = true;
  bool _crashReports = true;

  String get _currentLocale => TranslationService.currentLocale;
  List<String> get _availableLocales => TranslationService.availableLocales;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(tr('settings.title')),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
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
            onChanged: (value) => setState(() => _pushNotifications = value),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildSwitchTile(
            icon: LucideIcons.mail,
            title: tr('settings.notifications.email'),
            subtitle: tr('settings.notifications.emailDesc'),
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildSwitchTile(
            icon: LucideIcons.volume2,
            title: tr('settings.notifications.sound'),
            subtitle: tr('settings.notifications.soundDesc'),
            value: _notificationSound,
            onChanged: (value) => setState(() => _notificationSound = value),
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
            onChanged: (value) => setState(() => _analytics = value),
          ),
          Divider(height: 1, color: Colors.grey.shade100),
          _buildSwitchTile(
            icon: LucideIcons.bug,
            title: tr('settings.privacy.crashReports'),
            subtitle: tr('settings.privacy.crashReportsDesc'),
            value: _crashReports,
            onChanged: (value) => setState(() => _crashReports = value),
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
            activeColor: Colors.blue,
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
      await TranslationService.changeLocale(client, locale);
      
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
}
