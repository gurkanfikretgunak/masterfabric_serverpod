import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masterfabric_serverpod_client/masterfabric_serverpod_client.dart';
import '../main.dart';
import '../services/translation_service.dart';
import '../utils/responsive.dart';
import 'verification_settings_screen.dart';

/// User profile screen for viewing and editing user information
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  CurrentUserResponse? _user;
  List<Gender> _genderOptions = [];
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isSavingExtended = false;
  String? _error;

  final _fullNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  // Extended profile fields
  DateTime? _selectedBirthDate;
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    TranslationService.instance.addListener(_onLocaleChanged);
    _loadProfile();
    _loadGenderOptions();
  }

  @override
  void dispose() {
    TranslationService.instance.removeListener(_onLocaleChanged);
    _fullNameController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }
  
  Future<void> _loadGenderOptions() async {
    try {
      final options = await client.userProfile.getGenderOptions();
      setState(() {
        _genderOptions = options;
      });
    } catch (e) {
      debugPrint('Failed to load gender options: $e');
    }
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final user = await client.userProfile.getCurrentUser();
      setState(() {
        _user = user;
        _fullNameController.text = user.fullName ?? '';
        _userNameController.text = user.userName ?? '';
        _selectedBirthDate = user.birthDate;
        _selectedGender = user.gender;
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(tr('profile.title')),
        actions: [
          if (!_isLoading && _user != null)
            IconButton(
              icon: const Icon(LucideIcons.refreshCw),
              tooltip: tr('profile.refresh'),
              onPressed: _loadProfile,
            ),
        ],
      ),
      body: ResponsiveLayout(
        maxWidth: 600,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(tr('profile.loading')),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.circleAlert, size: 48, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                tr('profile.failedToLoad'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadProfile,
                icon: const Icon(LucideIcons.refreshCw),
                label: Text(tr('profile.retry')),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            _buildProfileHeader(),
            const SizedBox(height: 20),

            // Account Status Card
            _buildAccountStatusCard(),
            const SizedBox(height: 20),

            // Editable Profile Card
            _buildEditableProfileCard(),
            const SizedBox(height: 20),

            // Account Actions Card
            _buildAccountActionsCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                ),
                child: CircleAvatar(
                  radius: context.isMobile ? 32 : 36,
                  backgroundColor: Colors.white.withAlpha(50),
                  backgroundImage: _user?.imageUrl != null
                      ? NetworkImage(_user!.imageUrl!)
                      : null,
                  child: _user?.imageUrl == null
                      ? Icon(LucideIcons.user, size: context.isMobile ? 28 : 32, color: Colors.white)
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(LucideIcons.camera, size: 12, color: Colors.blue.shade600),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user?.fullName ?? _user?.userName ?? tr('profile.title'),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: context.isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white.withAlpha(200),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (_user?.emailVerified == true)
                      _buildHeaderBadge(tr('profile.header.verified'), LucideIcons.circleCheck),
                    if (_user?.blocked == true)
                      _buildHeaderBadge(tr('profile.header.blocked'), LucideIcons.ban, isWarning: true),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBadge(String text, IconData icon, {bool isWarning = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isWarning ? Colors.red.withAlpha(50) : Colors.white.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildCompactInfoRow(LucideIcons.hash, tr('profile.info.userId'), _user?.id ?? 'Unknown'),
          const Divider(height: 16),
          _buildCompactInfoRow(LucideIcons.calendar, tr('profile.info.memberSince'), 
            _user != null ? _formatDate(_user!.createdAt) : 'Unknown'),
        ],
      ),
    );
  }

  Widget _buildCompactInfoRow(IconData icon, String label, String value) {
    final displayValue = value.length > 24 
        ? '${value.substring(0, 8)}...${value.substring(value.length - 6)}'
        : value;
    
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade500),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const Spacer(),
        Text(
          displayValue,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
        if (value.length > 24) ...[
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _copyToClipboard(value),
            child: Icon(LucideIcons.copy, size: 14, color: Colors.grey.shade400),
          ),
        ],
      ],
    );
  }

  Widget _buildEditableProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(LucideIcons.userPen, size: 18, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              Text(
                tr('profile.edit.title'),
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Full Name
          _buildCompactTextField(
            controller: _fullNameController,
            label: tr('profile.edit.fullName'),
            icon: LucideIcons.user,
          ),
          const SizedBox(height: 12),
          
          // Username
          _buildCompactTextField(
            controller: _userNameController,
            label: tr('profile.edit.userName'),
            icon: LucideIcons.atSign,
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length < 3) {
                return tr('profile.edit.minChars');
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          
          // Birth Date
          _buildCompactDateField(),
          const SizedBox(height: 12),
          
          // Gender
          _buildCompactGenderField(),
          const SizedBox(height: 16),
          
          // Single Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isSaving || _isSavingExtended) ? null : _saveAllChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: (_isSaving || _isSavingExtended)
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(LucideIcons.shieldCheck, size: 16),
                        const SizedBox(width: 8),
                        Text(tr('profile.edit.save'), style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        prefixIcon: Icon(icon, size: 18),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildCompactDateField() {
    return InkWell(
      onTap: _selectBirthDate,
      borderRadius: BorderRadius.circular(10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: tr('profile.edit.birthDate'),
          labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          prefixIcon: const Icon(LucideIcons.cake, size: 18),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedBirthDate != null 
                  ? _formatDate(_selectedBirthDate!) 
                  : tr('profile.edit.selectDate'),
              style: TextStyle(
                fontSize: 14,
                color: _selectedBirthDate != null ? Colors.grey.shade800 : Colors.grey.shade500,
              ),
            ),
            Icon(LucideIcons.calendarDays, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactGenderField() {
    // Show loading state if gender options haven't loaded yet
    if (_genderOptions.isEmpty) {
      return InputDecorator(
        decoration: InputDecoration(
          labelText: tr('profile.edit.gender'),
          labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          prefixIcon: const Icon(LucideIcons.user, size: 18),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              tr('profile.edit.loadingOptions'),
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<Gender>(
      value: _selectedGender,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        labelText: tr('profile.edit.gender'),
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        prefixIcon: Icon(
          _selectedGender != null ? _getGenderIcon(_selectedGender!) : LucideIcons.user,
          size: 18,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 1.5),
        ),
      ),
      items: _genderOptions.map((gender) {
        return DropdownMenuItem<Gender>(
          value: gender,
          child: Row(
            children: [
              Icon(
                _getGenderIcon(gender),
                size: 16,
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 10),
              Text(_getGenderLabel(gender)),
            ],
          ),
        );
      }).toList(),
      onChanged: (Gender? newValue) {
        setState(() => _selectedGender = newValue);
      },
      hint: Text(tr('profile.edit.selectGender'), style: TextStyle(color: Colors.grey.shade500)),
      isExpanded: true,
    );
  }

  void _saveAllChanges() {
    if (!_formKey.currentState!.validate()) return;
    
    _showVerificationBottomSheet(
      fullName: _fullNameController.text.trim().isEmpty ? null : _fullNameController.text.trim(),
      userName: _userNameController.text.trim().isEmpty ? null : _userNameController.text.trim(),
      birthDate: _selectedBirthDate,
      gender: _selectedGender,
    );
  }

  Widget _buildAccountActionsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildActionItem(
            icon: LucideIcons.key,
            label: tr('profile.actions.changePassword'),
            onTap: () => _showComingSoon(tr('profile.actions.changePassword')),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildActionItem(
            icon: LucideIcons.shield,
            label: tr('profile.actions.twoFactor'),
            onTap: () => _showComingSoon(tr('profile.actions.twoFactor')),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildActionItem(
            icon: LucideIcons.smartphone,
            label: tr('profile.actions.activeSessions'),
            onTap: () => _showComingSoon(tr('profile.actions.activeSessions')),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildActionItem(
            icon: LucideIcons.shieldCheck,
            label: tr('profile.actions.verificationSettings'),
            onTap: () => _navigateToVerificationSettings(),
            isLast: true,
          ),
        ],
      ),
    );
  }

  void _navigateToVerificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VerificationSettingsScreen(),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
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
              child: Text(label, style: const TextStyle(fontSize: 14)),
            ),
            Icon(LucideIcons.chevronRight, size: 18, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('profile.copiedToClipboard')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tr('profile.comingSoon', args: {'feature': feature})),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthDate) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  String _getGenderLabel(Gender gender) {
    switch (gender) {
      case Gender.male:
        return tr('profile.gender.male');
      case Gender.female:
        return tr('profile.gender.female');
      case Gender.other:
        return tr('profile.gender.other');
      case Gender.preferNotToSay:
        return tr('profile.gender.preferNotToSay');
      case Gender.notApplicable:
        return tr('profile.gender.notApplicable');
      case Gender.unknown:
        return tr('profile.gender.unknown');
    }
  }
  
  IconData _getGenderIcon(Gender gender) {
    switch (gender) {
      case Gender.male:
        return LucideIcons.user;
      case Gender.female:
        return LucideIcons.user;
      case Gender.other:
        return LucideIcons.users;
      case Gender.preferNotToSay:
        return LucideIcons.userX;
      case Gender.notApplicable:
        return LucideIcons.userMinus;
      case Gender.unknown:
        return LucideIcons.circleUser;
    }
  }

  void _showVerificationBottomSheet({
    String? fullName,
    String? userName,
    DateTime? birthDate,
    Gender? gender,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _VerificationBottomSheet(
        fullName: fullName,
        userName: userName,
        birthDate: birthDate,
        gender: gender,
        onVerified: (updatedUser) async {
          // Update local state first
          setState(() {
            _user = updatedUser;
            if (fullName != null) _fullNameController.text = fullName;
            if (userName != null) _userNameController.text = userName;
          });
          
          // Refresh page to get fresh data from server
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) {
            _loadProfile();
          }
        },
      ),
    );
  }
}

/// Verification bottom sheet widget
class _VerificationBottomSheet extends StatefulWidget {
  final String? fullName;
  final String? userName;
  final DateTime? birthDate;
  final Gender? gender;
  final Function(CurrentUserResponse) onVerified;

  const _VerificationBottomSheet({
    this.fullName,
    this.userName,
    this.birthDate,
    this.gender,
    required this.onVerified,
  });

  @override
  State<_VerificationBottomSheet> createState() => _VerificationBottomSheetState();
}

class _VerificationBottomSheetState extends State<_VerificationBottomSheet> {
  final _codeController = TextEditingController();
  final List<TextEditingController> _digitControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isRequestingCode = false;
  bool _isVerifying = false;
  bool _codeSent = false;
  int _expiresInSeconds = 0;
  int _resendCooldown = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _requestCode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    for (final controller in _digitControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendCooldown(int seconds) {
    _resendCooldown = seconds;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _resendCooldown = _resendCooldown > 0 ? _resendCooldown - 1 : 0;
      });
      return _resendCooldown > 0;
    });
  }

  Future<void> _requestCode() async {
    if (_resendCooldown > 0) return;
    
    setState(() {
      _isRequestingCode = true;
      _error = null;
    });

    try {
      final response = await client.userProfile.requestProfileUpdateCode();
      setState(() {
        _isRequestingCode = false;
        _codeSent = response.success;
        _expiresInSeconds = response.expiresInSeconds ?? 300;
      });
      
      // Start resend cooldown timer
      final cooldown = response.resendCooldownSeconds ?? 30;
      _startResendCooldown(cooldown);
      
      // Focus first digit field
      if (_codeSent && mounted) {
        _focusNodes[0].requestFocus();
      }
      
      // Handle cooldown error from server
      if (!response.success && response.resendCooldownSeconds != null) {
        setState(() {
          _error = response.message;
        });
      }
    } catch (e) {
      setState(() {
        _isRequestingCode = false;
        _error = e.toString();
      });
    }
  }

  String get _enteredCode {
    return _digitControllers.map((c) => c.text).join();
  }

  Future<void> _verifyAndUpdate() async {
    final code = _enteredCode;
    if (code.length != 6) {
      setState(() => _error = tr('profile.verification.enterCode'));
      return;
    }

    setState(() {
      _isVerifying = true;
      _error = null;
    });

    try {
      final request = ProfileUpdateRequest(
        verificationCode: code,
        fullName: widget.fullName,
        userName: widget.userName,
        birthDate: widget.birthDate,
        gender: widget.gender,
      );

      final updatedUser = await client.userProfile.updateProfileWithVerification(request);
      
      if (mounted) {
        Navigator.pop(context);
        widget.onVerified(updatedUser);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tr('profile.verification.profileUpdated')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isVerifying = false;
        _error = e.toString().contains('Invalid') 
            ? tr('profile.verification.invalidCode')
            : e.toString().contains('expired')
            ? tr('profile.verification.codeExpired')
            : tr('profile.verification.verificationFailed');
      });
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Auto-verify when all digits entered
    if (_enteredCode.length == 6) {
      _verifyAndUpdate();
    }
  }

  void _onKeyPressed(int index, KeyEvent event) {
    if (event.logicalKey.keyLabel == 'Backspace' && 
        _digitControllers[index].text.isEmpty && 
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
                color: Colors.blue.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.shieldCheck,
                size: 32,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              tr('profile.verification.title'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              _codeSent 
                  ? tr('profile.verification.subtitle')
                  : tr('profile.verification.requesting'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),

            if (_isRequestingCode) ...[
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(height: 16),
            ] else if (_codeSent) ...[
              // 6-digit code input - compact size
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: 38,
                    height: 46,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: KeyboardListener(
                      focusNode: FocusNode(),
                      onKeyEvent: (event) => _onKeyPressed(index, event),
                      child: TextField(
                        controller: _digitControllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.blue, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        onChanged: (value) => _onDigitChanged(index, value),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              
              // Timer and resend
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.clock, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${tr('profile.verification.expiresIn')} ${_expiresInSeconds ~/ 60}:${(_expiresInSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: (_isRequestingCode || _resendCooldown > 0) ? null : _requestCode,
                    child: Text(
                      _resendCooldown > 0 
                          ? '${tr('profile.verification.resendIn')} ${_resendCooldown}s'
                          : tr('profile.verification.resendCode'),
                    ),
                  ),
                ],
              ),
            ],
            
            // Error message
            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.circleAlert, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Verify button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_isVerifying || !_codeSent) ? null : _verifyAndUpdate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isVerifying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(tr('profile.verification.verifyUpdate')),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr('profile.verification.cancel')),
            ),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
