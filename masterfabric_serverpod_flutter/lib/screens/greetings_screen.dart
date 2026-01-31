import 'package:flutter/material.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

import '../main.dart';
import '../services/translation_service.dart';
import '../widgets/rate_limit_banner.dart';

class GreetingsScreen extends StatefulWidget {
  final Future<void> Function()? onSignOut;
  const GreetingsScreen({super.key, this.onSignOut});

  @override
  State<GreetingsScreen> createState() => _GreetingsScreenState();
}

class _GreetingsScreenState extends State<GreetingsScreen> {
  /// Holds the last greeting response or null if no result exists yet.
  GreetingResponse? _greetingResult;

  /// Holds the last error message that we've received from the server or null
  /// if no error exists yet.
  String? _errorMessage;

  /// Rate limit exception if we're currently rate limited
  RateLimitException? _rateLimitException;

  /// Rate limit info from successful responses
  int? _rateLimitRemaining;
  int? _rateLimitMax;
  int? _rateLimitCurrent;

  /// Loading state
  bool _isLoading = false;

  final _textEditingController = TextEditingController();

  /// Current locale for UI updates
  String _currentLocale = TranslationService.currentLocale;

  /// Calls the `hello` method of the `greeting` endpoint. Will set either the
  /// `_resultMessage` or `_errorMessage` field, depending on if the call
  /// is successful.
  void _callHello() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await client.greeting.hello(_textEditingController.text);
      setState(() {
        _rateLimitException = null;
        _errorMessage = null;
        _greetingResult = result;
        // Update rate limit info from response
        _rateLimitRemaining = result.rateLimitRemaining;
        _rateLimitMax = result.rateLimitMax;
        _rateLimitCurrent = result.rateLimitCurrent;
      });
    } on RateLimitException catch (e) {
      // Handle rate limit specifically
      setState(() {
        _rateLimitException = e;
        _greetingResult = null;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
        _rateLimitException = null;
        _greetingResult = null;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Dismiss rate limit banner and reset state
  void _dismissRateLimit() {
    setState(() {
      _rateLimitException = null;
    });
  }

  /// Change the locale and reload translations
  Future<void> _changeLocale(String locale) async {
    try {
      await TranslationService.changeLocale(client, locale);
      setState(() {
        _currentLocale = TranslationService.currentLocale;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to change locale: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableLocales = TranslationService.availableLocales;
    
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Rate limit banner (shows when rate limited)
            if (_rateLimitException != null) ...[
              RateLimitBanner(
                exception: _rateLimitException!,
                onRetry: _callHello,
                onDismiss: _dismissRateLimit,
              ),
              const SizedBox(height: 8),
            ],
            
            // Rate limit indicator (shows remaining requests)
            if (_rateLimitRemaining != null && 
                _rateLimitMax != null && 
                _rateLimitException == null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RateLimitIndicator(
                    current: _rateLimitCurrent ?? 0,
                    limit: _rateLimitMax!,
                    remaining: _rateLimitRemaining!,
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Language selector
            if (availableLocales.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr('common.loading').contains('common.') 
                      ? 'Language:' 
                      : '${tr('common.loading').split('.').first}:'),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: availableLocales.contains(_currentLocale) 
                        ? _currentLocale 
                        : availableLocales.first,
                    items: availableLocales.map((locale) {
                      return DropdownMenuItem(
                        value: locale,
                        child: Text(_getLocaleDisplayName(locale)),
                      );
                    }).toList(),
                    onChanged: (locale) {
                      if (locale != null) {
                        _changeLocale(locale);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            
            // Welcome message using translations
            Text(
              tr('welcome.title', args: {'name': 'User'}),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              tr('welcome.subtitle'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            
            if (widget.onSignOut != null) ...[
              Text(tr('login.success')),
              ElevatedButton(
                onPressed: widget.onSignOut,
                child: Text(tr('common.back')),
              ),
            ],
            const SizedBox(height: 32),
            
            // Input field
            TextField(
              controller: _textEditingController,
              enabled: !_isLoading && _rateLimitException == null,
              decoration: InputDecoration(
                hintText: tr('login.email').contains('login.') 
                    ? 'Enter your name' 
                    : tr('login.email'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: _rateLimitException != null 
                    ? Colors.grey.shade100 
                    : Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            
            // Send button with loading state
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading || _rateLimitException != null 
                    ? null 
                    : _callHello,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        tr('common.save').contains('common.') 
                            ? 'Send to Server' 
                            : tr('common.save'),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Result display (only show if not rate limited)
            if (_rateLimitException == null)
              GreetingResultCard(
                greetingResult: _greetingResult,
                errorMessage: _errorMessage,
              ),
          ],
        ),
      ),
    );
  }

  /// Get display name for locale
  String _getLocaleDisplayName(String locale) {
    switch (locale.toLowerCase()) {
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'de':
        return 'Deutsch';
      case 'fr':
        return 'Français';
      case 'es':
        return 'Español';
      case 'zh':
        return '中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'ar':
        return 'العربية';
      default:
        return locale.toUpperCase();
    }
  }
}

/// Modern card widget to display greeting response or error
class GreetingResultCard extends StatelessWidget {
  final GreetingResponse? greetingResult;
  final String? errorMessage;

  const GreetingResultCard({
    super.key,
    this.greetingResult,
    this.errorMessage,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Error state
    if (errorMessage != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.error_outline,
                color: Colors.red.shade700,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.red.shade800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    errorMessage!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Success state with greeting
    if (greetingResult != null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.teal.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withAlpha(26),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with success icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100.withAlpha(128),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Server Response',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _formatTimestamp(greetingResult!.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Message content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 18,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Message',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          greetingResult!.message,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Author info
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 20,
                                color: Colors.teal.shade400,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Author',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Text(
                                    greetingResult!.author,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 20,
                                color: Colors.blue.shade400,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Time',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                  Text(
                                    '${greetingResult!.timestamp.hour.toString().padLeft(2, '0')}:'
                                    '${greetingResult!.timestamp.minute.toString().padLeft(2, '0')}:'
                                    '${greetingResult!.timestamp.second.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Empty state
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.send_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            'No response yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Enter a name and tap "Send to Server"',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
