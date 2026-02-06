import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';

/// Service for managing user app settings with real-time updates
/// 
/// Handles loading, saving, and listening to settings changes from the server.
class UserAppSettingsService extends ChangeNotifier {
  static final UserAppSettingsService _instance = UserAppSettingsService._internal();
  
  factory UserAppSettingsService.instance() => _instance;
  
  UserAppSettingsService._internal();

  Client? _client;
  StreamSubscription<UserAppSettingsEvent>? _streamSubscription;
  
  UserAppSettings? _settings;
  bool _isLoading = false;
  bool _isConnected = false;
  String? _error;

  /// Current settings
  UserAppSettings? get settings => _settings;

  /// Whether settings are being loaded
  bool get isLoading => _isLoading;

  /// Whether connected to settings stream
  bool get isConnected => _isConnected;

  /// Current error message
  String? get error => _error;

  /// Initialize the service with a client
  void initialize(Client client) {
    _client = client;
  }

  /// Load settings from server
  Future<void> loadSettings() async {
    if (_client == null) {
      _error = 'Client not initialized';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _client!.userAppSettings.get();
      
      if (response.success && response.settings != null) {
        _settings = response.settings;
        debugPrint('Settings loaded: ${_settings?.toJson()}');
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'Failed to load settings: $e';
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update settings on server
  /// 
  /// [updateRequest] - Settings update request
  /// [requireVerification] - Whether to request verification code for hard settings
  Future<bool> updateSettings(
    UserAppSettingsUpdateRequest updateRequest, {
    bool requireVerification = false,
  }) async {
    if (_client == null) {
      _error = 'Client not initialized';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // If updating hard settings and verification code not provided, request it
      if (requireVerification && 
          updateRequest.twoFactorEnabled != null &&
          (updateRequest.verificationCode == null || 
           updateRequest.verificationCode!.isEmpty)) {
        // Request verification code first
        final verificationResponse = await _client!.userAppSettings.requestVerificationCode();
        
        if (!verificationResponse.success) {
          _error = verificationResponse.message;
          _isLoading = false;
          notifyListeners();
          return false;
        }
        
        // Return false to indicate verification code is needed
        _isLoading = false;
        notifyListeners();
        return false; // Caller should prompt for verification code
      }

      final response = await _client!.userAppSettings.update(updateRequest);
      
      if (response.success && response.settings != null) {
        _settings = response.settings;
        debugPrint('Settings updated: ${_settings?.toJson()}');
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Failed to update settings: $e';
      debugPrint('Error updating settings: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update settings with verification code
  /// 
  /// [updateRequest] - Settings update request (must include verificationCode)
  Future<bool> updateSettingsWithVerification(
    UserAppSettingsUpdateRequest updateRequest,
  ) async {
    if (updateRequest.verificationCode == null || 
        updateRequest.verificationCode!.isEmpty) {
      _error = 'Verification code is required';
      notifyListeners();
      return false;
    }

    return await updateSettings(updateRequest, requireVerification: false);
  }

  /// Subscribe to real-time settings updates
  Future<void> subscribeToUpdates() async {
    if (_client == null) {
      _error = 'Client not initialized';
      notifyListeners();
      return;
    }

    // Cancel existing subscription
    await _streamSubscription?.cancel();

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final stream = _client!.userAppSettingsStream.subscribe();
      
      _streamSubscription = stream.listen(
        _onSettingsEvent,
        onError: _onStreamError,
        onDone: _onStreamDone,
      );
      
      _isConnected = true;
      _isLoading = false;
      notifyListeners();
      
      debugPrint('Subscribed to settings updates');
    } catch (e) {
      _error = 'Failed to subscribe: $e';
      _isLoading = false;
      _isConnected = false;
      notifyListeners();
      debugPrint('Error subscribing to settings updates: $e');
    }
  }

  /// Unsubscribe from settings updates
  Future<void> unsubscribe() async {
    await _streamSubscription?.cancel();
    _streamSubscription = null;
    _isConnected = false;
    notifyListeners();
    debugPrint('Unsubscribed from settings updates');
  }

  void _onSettingsEvent(UserAppSettingsEvent event) {
    debugPrint('Settings event received: ${event.type}');
    
    if (event.type == 'updated' && event.settings != null) {
      _settings = event.settings;
      notifyListeners();
    } else if (event.type == 'deleted') {
      _settings = null;
      notifyListeners();
    }
  }

  void _onStreamError(Object error) {
    _error = 'Stream error: $error';
    _isConnected = false;
    notifyListeners();
    debugPrint('Settings stream error: $error');
  }

  void _onStreamDone() {
    _isConnected = false;
    notifyListeners();
    debugPrint('Settings stream closed');
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
