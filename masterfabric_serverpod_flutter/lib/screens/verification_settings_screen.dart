import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';
import '../main.dart';

/// Screen for managing verification channel preferences
///
/// Allows users to:
/// - Select preferred verification channel (Email, Telegram, WhatsApp)
/// - Link Telegram account
/// - Verify phone number for WhatsApp
/// - Set backup verification channel
class VerificationSettingsScreen extends StatefulWidget {
  const VerificationSettingsScreen({super.key});

  @override
  State<VerificationSettingsScreen> createState() => _VerificationSettingsScreenState();
}

class _VerificationSettingsScreenState extends State<VerificationSettingsScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  List<VerificationChannel> _availableChannels = [];
  UserVerificationPreferences? _preferences;
  Map<String, String?>? _telegramBotInfo;

  VerificationChannel? _selectedChannel;
  VerificationChannel? _selectedBackupChannel;
  String? _selectedLocale;
  final _phoneController = TextEditingController();
  final _verificationCodeController = TextEditingController();
  
  // Available locales
  final List<Map<String, String>> _availableLocales = [
    {'code': 'en', 'name': 'English'},
    {'code': 'tr', 'name': 'Türkçe'},
    {'code': 'de', 'name': 'Deutsch'},
    {'code': 'es', 'name': 'Español'},
  ];

  // Telegram linking state
  bool _isLinkingTelegram = false;

  // Phone verification state
  bool _isVerifyingPhone = false;
  bool _showPhoneVerificationCode = false;

  @override
  void initState() {
    super.initState();
    // Initialize loading state before checking service
    _isLoading = true;
    // Load data asynchronously - UI will show loading state until data is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load available channels and user preferences in parallel
      // (Service handles authentication internally)
      final results = await Future.wait([
        client.verificationPreferences.getAvailableChannels(),
        client.verificationPreferences.getPreferences(),
        client.verificationPreferences.getTelegramBotInfo(),
      ]);

      final channels = results[0] as List<VerificationChannel>;
      final preferences = results[1] as UserVerificationPreferences?;
      final botInfo = results[2] as Map<String, String?>;

      setState(() {
        _availableChannels = channels;
        _preferences = preferences;
        _telegramBotInfo = botInfo;
        _selectedChannel = preferences?.preferredChannel ?? VerificationChannel.email;
        _selectedBackupChannel = preferences?.backupChannel;
        _selectedLocale = preferences?.locale ?? 'en';
        if (preferences?.phoneNumber != null) {
          _phoneController.text = preferences!.phoneNumber!;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _savePreferences() async {
    if (_selectedChannel == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = await client.verificationPreferences.updatePreferences(
        preferredChannel: _selectedChannel!,
        backupChannel: _selectedBackupChannel,
        phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        locale: _selectedLocale,
      );

      setState(() {
        _preferences = updated;
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification preferences saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startTelegramLinking() async {
    setState(() {
      _isLinkingTelegram = true;
    });

    try {
      final response = await client.verificationPreferences.generateTelegramLinkCode();

      if (response.success) {
        setState(() {
          _isLinkingTelegram = false;
        });

        _showTelegramLinkDialog();
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      setState(() {
        _isLinkingTelegram = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate link code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showTelegramLinkDialog() {
    final botUsername = _telegramBotInfo?['botUsername'];
    final botUrl = _telegramBotInfo?['botUrl'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(LucideIcons.send, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            const Text('Link Telegram'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('To link your Telegram account:'),
            const SizedBox(height: 16),
            _buildStep('1', 'Check your email for the verification code'),
            const SizedBox(height: 8),
            _buildStep('2', botUsername != null
                ? 'Open Telegram and search for @$botUsername'
                : 'Open our Telegram bot'),
            const SizedBox(height: 8),
            _buildStep('3', 'Send the verification code to the bot'),
            const SizedBox(height: 16),
            if (botUrl != null)
              OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: botUrl));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bot URL copied to clipboard')),
                  );
                },
                icon: const Icon(LucideIcons.copy, size: 16),
                label: Text('@$botUsername'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Future<void> _startPhoneVerification() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate phone number format
    if (!_isValidPhoneNumber(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid phone number format. Use E.164 format (e.g., +14155551234)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isVerifyingPhone = true;
    });

    try {
      final response = await client.verificationPreferences.sendPhoneVerificationCode(phone);

      if (response.success) {
        setState(() {
          _isVerifyingPhone = false;
          _showPhoneVerificationCode = true;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      setState(() {
        _isVerifyingPhone = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send code: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _verifyPhoneCode() async {
    final phone = _phoneController.text.trim();
    final code = _verificationCodeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the verification code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isVerifyingPhone = true;
    });

    try {
      final success = await client.verificationPreferences.verifyPhoneNumber(phone, code);

      if (success) {
        setState(() {
          _isVerifyingPhone = false;
          _showPhoneVerificationCode = false;
          _verificationCodeController.clear();
        });

        // Reload preferences to get updated state
        await _loadData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Phone number verified successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isVerifyingPhone = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool _isValidPhoneNumber(String phone) {
    final e164Regex = RegExp(r'^\+[1-9]\d{6,14}$');
    return e164Regex.hasMatch(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Verification Settings'),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(LucideIcons.refreshCw),
              tooltip: 'Refresh',
              onPressed: _loadData,
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Show loading state first - don't render UI until data is loaded
    if (_isLoading) {
      return Center(
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
                LucideIcons.shield,
                size: 48,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Loading Verification Settings',
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
      );
    }

    // Show error state if loading failed
    if (_error != null) {
      return Center(
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
                onPressed: _loadData,
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
      );
    }

    // Only render the settings UI once data is successfully loaded

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Card
          _buildInfoCard(),
          const SizedBox(height: 20),

          // Preferred Channel Card
          _buildPreferredChannelCard(),
          const SizedBox(height: 20),

          // Telegram Linking Card
          if (_availableChannels.contains(VerificationChannel.telegram))
            ...[
              _buildTelegramCard(),
              const SizedBox(height: 20),
            ],

          // WhatsApp Phone Verification Card
          if (_availableChannels.contains(VerificationChannel.whatsapp))
            ...[
              _buildWhatsAppCard(),
              const SizedBox(height: 20),
            ],

          // Locale Card
          _buildLocaleCard(),
          const SizedBox(height: 20),

          // Backup Channel Card
          _buildBackupChannelCard(),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSaving ? null : _savePreferences,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Save Preferences',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.info, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Choose how you want to receive verification codes for secure account actions.',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferredChannelCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.shield, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text(
                'Preferred Channel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Select your primary method for receiving verification codes',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          ..._availableChannels.map((channel) => _buildChannelOption(
                channel,
                _selectedChannel == channel,
                (value) {
                  setState(() {
                    _selectedChannel = channel;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget _buildChannelOption(
    VerificationChannel channel,
    bool isSelected,
    ValueChanged<bool?> onChanged,
  ) {
    final isConfigured = _isChannelConfigured(channel);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: isConfigured ? () => onChanged(true) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.blue.shade300 : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                _getChannelIcon(channel),
                color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getChannelName(channel),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isConfigured ? Colors.black87 : Colors.grey,
                      ),
                    ),
                    Text(
                      _getChannelDescription(channel),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (!isConfigured)
                      Text(
                        _getChannelSetupHint(channel),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(LucideIcons.circleCheck, color: Colors.blue.shade600),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTelegramCard() {
    final isLinked = _preferences?.telegramLinked ?? false;
    final botUsername = _telegramBotInfo?['botUsername'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.send, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text(
                'Telegram',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isLinked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.circleCheck, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Linked',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isLinked
                ? 'Your Telegram account is linked. You can receive verification codes via Telegram.'
                : 'Link your Telegram account to receive verification codes via our bot.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          if (botUsername != null && !isLinked) ...[
            const SizedBox(height: 8),
            Text(
              'Bot: @$botUsername',
              style: TextStyle(
                color: Colors.blue.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (isLinked)
            OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Unlink Telegram?'),
                    content: const Text(
                      'You will no longer receive verification codes via Telegram.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Unlink'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    await client.verificationPreferences.unlinkTelegramAccount();
                    await _loadData();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Telegram account unlinked'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to unlink: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              icon: const Icon(LucideIcons.unlink, size: 16),
              label: const Text('Unlink Telegram'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade200),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: _isLinkingTelegram ? null : _startTelegramLinking,
              icon: _isLinkingTelegram
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.link, size: 16),
              label: Text(_isLinkingTelegram ? 'Generating code...' : 'Link Telegram Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWhatsAppCard() {
    final isVerified = _preferences?.whatsappVerified ?? false;
    final currentPhone = _preferences?.phoneNumber;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.messageCircle, color: Colors.green.shade600),
              const SizedBox(width: 8),
              const Text(
                'WhatsApp',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.circleCheck, size: 14, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isVerified
                ? 'Your phone number is verified for WhatsApp notifications.'
                : 'Add and verify your phone number to receive verification codes via WhatsApp.',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          // Phone Number Input
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '+14155551234',
              helperText: 'Use E.164 format (e.g., +14155551234)',
              prefixIcon: const Icon(LucideIcons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: isVerified && currentPhone == _phoneController.text
                  ? Icon(LucideIcons.circleCheck, color: Colors.green.shade600)
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          if (_showPhoneVerificationCode) ...[
            TextFormField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Verification Code',
                hintText: 'Enter 6-digit code',
                prefixIcon: const Icon(LucideIcons.keyRound),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showPhoneVerificationCode = false;
                        _verificationCodeController.clear();
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isVerifyingPhone ? null : _verifyPhoneCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: _isVerifyingPhone
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Verify'),
                  ),
                ),
              ],
            ),
          ] else
            ElevatedButton.icon(
              onPressed: _isVerifyingPhone ? null : _startPhoneVerification,
              icon: _isVerifyingPhone
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.send, size: 16),
              label: Text(_isVerifyingPhone
                  ? 'Sending...'
                  : isVerified
                      ? 'Verify New Number'
                      : 'Send Verification Code'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBackupChannelCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.lifeBuoy, color: Colors.orange.shade600),
              const SizedBox(width: 8),
              const Text(
                'Backup Channel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Optional fallback if your preferred channel is unavailable',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<VerificationChannel?>(
            value: _selectedBackupChannel,
            decoration: InputDecoration(
              labelText: 'Backup Channel',
              prefixIcon: const Icon(LucideIcons.layers),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: [
              const DropdownMenuItem<VerificationChannel?>(
                value: null,
                child: Text('None'),
              ),
              ..._availableChannels
                  .where((c) => c != _selectedChannel)
                  .map((channel) => DropdownMenuItem(
                        value: channel,
                        child: Row(
                          children: [
                            Icon(_getChannelIcon(channel), size: 18),
                            const SizedBox(width: 8),
                            Text(_getChannelName(channel)),
                          ],
                        ),
                      )),
            ],
            onChanged: (value) {
              setState(() {
                _selectedBackupChannel = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocaleCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.languages, color: Colors.purple.shade600),
              const SizedBox(width: 8),
              const Text(
                'Language Preference',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Select your preferred language for verification messages',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedLocale ?? 'en',
            decoration: InputDecoration(
              labelText: 'Language',
              prefixIcon: const Icon(LucideIcons.globe),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: _availableLocales.map((locale) {
              return DropdownMenuItem<String>(
                value: locale['code'],
                child: Text(locale['name']!),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedLocale = value;
              });
            },
          ),
        ],
      ),
    );
  }

  bool _isChannelConfigured(VerificationChannel channel) {
    switch (channel) {
      case VerificationChannel.email:
        return true; // Email is always available
      case VerificationChannel.telegram:
        return _preferences?.telegramLinked ?? false;
      case VerificationChannel.whatsapp:
        return _preferences?.whatsappVerified ?? false;
      case VerificationChannel.sms:
        return _preferences?.phoneNumber != null;
    }
  }

  IconData _getChannelIcon(VerificationChannel channel) {
    switch (channel) {
      case VerificationChannel.email:
        return LucideIcons.mail;
      case VerificationChannel.telegram:
        return LucideIcons.send;
      case VerificationChannel.whatsapp:
        return LucideIcons.messageCircle;
      case VerificationChannel.sms:
        return LucideIcons.smartphone;
    }
  }

  String _getChannelName(VerificationChannel channel) {
    switch (channel) {
      case VerificationChannel.email:
        return 'Email';
      case VerificationChannel.telegram:
        return 'Telegram';
      case VerificationChannel.whatsapp:
        return 'WhatsApp';
      case VerificationChannel.sms:
        return 'SMS';
    }
  }

  String _getChannelDescription(VerificationChannel channel) {
    switch (channel) {
      case VerificationChannel.email:
        return 'Receive codes via email';
      case VerificationChannel.telegram:
        return 'Receive codes via Telegram bot';
      case VerificationChannel.whatsapp:
        return 'Receive codes via WhatsApp';
      case VerificationChannel.sms:
        return 'Receive codes via SMS';
    }
  }

  String _getChannelSetupHint(VerificationChannel channel) {
    switch (channel) {
      case VerificationChannel.email:
        return '';
      case VerificationChannel.telegram:
        return 'Link your Telegram account below';
      case VerificationChannel.whatsapp:
        return 'Verify your phone number below';
      case VerificationChannel.sms:
        return 'Add your phone number below';
    }
  }
}
