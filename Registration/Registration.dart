import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Copy these from your main.dart if importing separately ──────────────────
// AppColors, AppTypography, PrimaryButton, SecondaryButton, AppInputField,
// BackgroundGlow — they are referenced below.
// ────────────────────────────────────────────────────────────────────────────

class AppColors {
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryHover = Color(0xFF4338CA);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}

// ── Registration entry point ────────────────────────────────────────────────

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  int _step = 0; // 0 = account info | 1 = password | 2 = profile

  // Step 1 controllers & keys
  final _step1Key = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _usernameFocus = FocusNode();

  // Step 2 controllers & keys
  final _step2Key = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _capsLock = false;

  // Step 3
  int _selectedAvatar = 0;
  String? _selectedRole;

  bool _isLoading = false;

  // Entrance animation
  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  static const List<String> _avatars = ['🧑‍💻', '👨‍🔬', '🦊', '🐼', '🚀'];
  static const List<String> _roles = [
    'Data Analyst',
    'Developer',
    'Student',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));
    _entranceCtrl.forward();

    _passwordFocus.addListener(_updateCapsLock);
  }

  void _updateCapsLock() {
    if (_passwordFocus.hasFocus) {
      final on = HardwareKeyboard.instance.lockModesEnabled
          .contains(KeyboardLockMode.capsLock);
      if (on != _capsLock) setState(() => _capsLock = on);
    }
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────

  void _nextStep() {
    if (_step == 0 && !(_step1Key.currentState?.validate() ?? false)) {
      HapticFeedback.mediumImpact();
      return;
    }
    if (_step == 1 && !(_step2Key.currentState?.validate() ?? false)) {
      HapticFeedback.mediumImpact();
      return;
    }
    setState(() => _step++);
    HapticFeedback.selectionClick();
  }

  void _prevStep() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _createAccount() async {
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    setState(() => _isLoading = false);
    HapticFeedback.mediumImpact();

    // TODO: Replace with your actual registration logic.
    // On success, navigate to home/success screen:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Account created successfully!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.success,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pop(context); // Go back to login / welcome
  }

  // ── Password strength ───────────────────────────────────────────────────────

  _PasswordStrength _getStrength(String v) {
    if (v.isEmpty) return _PasswordStrength.none;
    int score = 0;
    if (v.length >= 8) score++;
    if (v.contains(RegExp(r'[A-Z]'))) score++;
    if (v.contains(RegExp(r'[0-9]'))) score++;
    if (v.contains(RegExp(r'[^A-Za-z0-9]'))) score++;
    if (score <= 1) return _PasswordStrength.weak;
    if (score == 2) return _PasswordStrength.fair;
    if (score == 3) return _PasswordStrength.good;
    return _PasswordStrength.strong;
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _BackgroundGlow(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 440),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color.fromRGBO(148, 163, 184, 0.15),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(15, 23, 42, 0.08),
                            blurRadius: 40,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _StepIndicator(currentStep: _step, totalSteps: 3),
                          const SizedBox(height: 24),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.05, 0),
                                  end: Offset.zero,
                                ).animate(anim),
                                child: child,
                              ),
                            ),
                            child: _buildStep(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _Step1AccountInfo(
          key: const ValueKey('step1'),
          formKey: _step1Key,
          firstNameCtrl: _firstNameCtrl,
          lastNameCtrl: _lastNameCtrl,
          emailCtrl: _emailCtrl,
          usernameCtrl: _usernameCtrl,
          firstNameFocus: _firstNameFocus,
          lastNameFocus: _lastNameFocus,
          emailFocus: _emailFocus,
          usernameFocus: _usernameFocus,
          onNext: _nextStep,
          onSignIn: () => Navigator.pop(context),
        );
      case 1:
        return _Step2Password(
          key: const ValueKey('step2'),
          formKey: _step2Key,
          passwordCtrl: _passwordCtrl,
          confirmCtrl: _confirmCtrl,
          passwordFocus: _passwordFocus,
          confirmFocus: _confirmFocus,
          capsLock: _capsLock,
          getStrength: _getStrength,
          onNext: _nextStep,
          onBack: _prevStep,
        );
      case 2:
        return _Step3Profile(
          key: const ValueKey('step3'),
          avatars: _avatars,
          roles: _roles,
          selectedAvatar: _selectedAvatar,
          selectedRole: _selectedRole,
          isLoading: _isLoading,
          onAvatarSelected: (i) => setState(() => _selectedAvatar = i),
          onRoleSelected: (r) => setState(() => _selectedRole = r),
          onSubmit: _createAccount,
          onBack: _prevStep,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Step Indicator ──────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive = i <= currentStep;
        final isCurrent = i == currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isCurrent ? 28 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

// ── Step 1: Account Info ────────────────────────────────────────────────────

class _Step1AccountInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController usernameCtrl;
  final FocusNode firstNameFocus;
  final FocusNode lastNameFocus;
  final FocusNode emailFocus;
  final FocusNode usernameFocus;
  final VoidCallback onNext;
  final VoidCallback onSignIn;

  const _Step1AccountInfo({
    super.key,
    required this.formKey,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.usernameCtrl,
    required this.firstNameFocus,
    required this.lastNameFocus,
    required this.emailFocus,
    required this.usernameFocus,
    required this.onNext,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('👋 Create account', style: _headingStyle),
          const SizedBox(height: 6),
          const Text(
            'Start managing your CSV data today.',
            style: _subtitleStyle,
          ),
          const SizedBox(height: 28),

          // First & Last name row
          Row(
            children: [
              Expanded(
                child: _RegInputField(
                  controller: firstNameCtrl,
                  label: 'First name',
                  hint: 'Ebrahim',
                  icon: Icons.person_outline_rounded,
                  focusNode: firstNameFocus,
                  textInputAction: TextInputAction.next,
                  onSubmitted: () =>
                      FocusScope.of(context).requestFocus(lastNameFocus),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _RegInputField(
                  controller: lastNameCtrl,
                  label: 'Last name',
                  hint: 'Rabie',
                  icon: Icons.person_outline_rounded,
                  focusNode: lastNameFocus,
                  textInputAction: TextInputAction.next,
                  onSubmitted: () =>
                      FocusScope.of(context).requestFocus(emailFocus),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          _RegInputField(
            controller: emailCtrl,
            label: 'Email address',
            hint: 'you@example.com',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            focusNode: emailFocus,
            textInputAction: TextInputAction.next,
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(usernameFocus),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@') || !v.contains('.')) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          _RegInputField(
            controller: usernameCtrl,
            label: 'Username',
            hint: 'ebrahimrabie',
            icon: Icons.alternate_email_rounded,
            focusNode: usernameFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: onNext,
            validator: (v) {
              if (v == null || v.trim().length < 3) {
                return 'Min 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          _PrimaryRegButton(label: 'Continue', onTap: onNext),
          const SizedBox(height: 24),

          const _OrDivider(),
          const SizedBox(height: 16),

          Row(
            children: [
              _SocialBtn(
                label: 'Google',
                icon: const Text(
                  'G',
                  style: TextStyle(
                    color: Color(0xFFDB4437),
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                onTap: () {},
              ),
              const SizedBox(width: 12),
              _SocialBtn(
                label: 'Facebook',
                icon: Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1877F2),
                  ),
                  child: const Text(
                    'f',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 20),

          Center(
            child: RichText(
              text: TextSpan(
                text: 'Already have an account? ',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                children: [
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: onSignIn,
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Password ────────────────────────────────────────────────────────

class _Step2Password extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordCtrl;
  final TextEditingController confirmCtrl;
  final FocusNode passwordFocus;
  final FocusNode confirmFocus;
  final bool capsLock;
  final _PasswordStrength Function(String) getStrength;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _Step2Password({
    super.key,
    required this.formKey,
    required this.passwordCtrl,
    required this.confirmCtrl,
    required this.passwordFocus,
    required this.confirmFocus,
    required this.capsLock,
    required this.getStrength,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<_Step2Password> createState() => _Step2PasswordState();
}

class _Step2PasswordState extends State<_Step2Password> {
  bool _agreed = false;
  _PasswordStrength _strength = _PasswordStrength.none;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('🔐 Secure your account', style: _headingStyle),
          const SizedBox(height: 6),
          const Text(
            'Choose a strong password to protect your data.',
            style: _subtitleStyle,
          ),
          const SizedBox(height: 28),

          _RegInputField(
            controller: widget.passwordCtrl,
            label: 'Password',
            hint: 'Enter password',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            capsLockEnabled: widget.capsLock,
            focusNode: widget.passwordFocus,
            textInputAction: TextInputAction.next,
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(widget.confirmFocus),
            onChanged: (v) =>
                setState(() => _strength = widget.getStrength(v)),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 8) return 'Minimum 8 characters';
              return null;
            },
          ),

          if (_strength != _PasswordStrength.none) ...[
            const SizedBox(height: 8),
            _StrengthBar(strength: _strength),
          ],

          const SizedBox(height: 14),

          _RegInputField(
            controller: widget.confirmCtrl,
            label: 'Confirm password',
            hint: 'Re-enter password',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            focusNode: widget.confirmFocus,
            textInputAction: TextInputAction.done,
            onSubmitted: widget.onNext,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              if (v != widget.passwordCtrl.text) return "Passwords don't match";
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Terms checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(
                  value: _agreed,
                  onChanged: (v) => setState(() => _agreed = v ?? false),
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(color: AppColors.border, width: 1.5),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: const TextSpan(
                    text: 'I agree to the ',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _PrimaryRegButton(
            label: 'Continue',
            onTap: () {
              if (!_agreed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please agree to the Terms of Service'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: AppColors.error,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  ),
                );
                return;
              }
              widget.onNext();
            },
          ),
          const SizedBox(height: 16),
          _BackLink(onTap: widget.onBack),
        ],
      ),
    );
  }
}

// ── Step 3: Profile ─────────────────────────────────────────────────────────

class _Step3Profile extends StatelessWidget {
  final List<String> avatars;
  final List<String> roles;
  final int selectedAvatar;
  final String? selectedRole;
  final bool isLoading;
  final ValueChanged<int> onAvatarSelected;
  final ValueChanged<String?> onRoleSelected;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  const _Step3Profile({
    super.key,
    required this.avatars,
    required this.roles,
    required this.selectedAvatar,
    required this.selectedRole,
    required this.isLoading,
    required this.onAvatarSelected,
    required this.onRoleSelected,
    required this.onSubmit,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '🎉 You\'re all set!',
          style: _headingStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const Text(
          'Personalize your profile before we get started.',
          style: _subtitleStyle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),

        // Avatar picker
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Choose an avatar', style: _labelStyle),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(avatars.length, (i) {
            final selected = i == selectedAvatar;
            return GestureDetector(
              onTap: () => onAvatarSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                    width: selected ? 2.5 : 1.5,
                  ),
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  avatars[i],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),

        // Role dropdown
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Role (optional)', style: _labelStyle),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.surface,
          ),
          child: DropdownButtonFormField<String>(
            value: selectedRole,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.work_outline_rounded,
                color: AppColors.textMuted,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
            hint: const Text(
              'Select your role',
              style: TextStyle(color: AppColors.textMuted, fontSize: 15),
            ),
            items: roles
                .map(
                  (r) => DropdownMenuItem(
                    value: r,
                    child: Text(r),
                  ),
                )
                .toList(),
            onChanged: onRoleSelected,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textMuted),
            dropdownColor: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Create account button
        SizedBox(
          height: 52,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              disabledBackgroundColor: AppColors.success.withValues(alpha: 0.7),
              foregroundColor: AppColors.textInverse,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.textInverse.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Creating account...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textInverse,
                        ),
                      ),
                    ],
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_rounded, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textInverse,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        _BackLink(onTap: onBack),
      ],
    );
  }
}

// ── Reusable sub-widgets ────────────────────────────────────────────────────

class _RegInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool isPassword;
  final bool capsLockEnabled;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  const _RegInputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.capsLockEnabled = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.validator,
  });

  @override
  State<_RegInputField> createState() => _RegInputFieldState();
}

class _RegInputFieldState extends State<_RegInputField> {
  bool _obscure = true;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocus);
  }

  void _onFocus() {
    if (mounted) {
      setState(() => _focused = widget.focusNode?.hasFocus ?? false);
    }
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ]
            : null,
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscure,
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        textInputAction: widget.textInputAction,
        validator: widget.validator,
        onChanged: widget.onChanged,
        onFieldSubmitted: (_) => widget.onSubmitted?.call(),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: TextStyle(
            color: _focused ? AppColors.primary : AppColors.textMuted,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 15,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: _focused ? AppColors.primary : AppColors.textMuted,
            size: 20,
          ),
          suffixIcon: widget.isPassword
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.capsLockEnabled)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.keyboard_capslock,
                          color: AppColors.textMuted,
                          size: 18,
                        ),
                      ),
                    IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ],
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.error, width: 1.5),
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          floatingLabelStyle: TextStyle(
            color: _focused ? AppColors.primary : AppColors.textMuted,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  final _PasswordStrength strength;

  const _StrengthBar({required this.strength});

  @override
  Widget build(BuildContext context) {
    final colors = {
      _PasswordStrength.weak: [
        AppColors.error,
        AppColors.border,
        AppColors.border,
        AppColors.border,
      ],
      _PasswordStrength.fair: [
        AppColors.warning,
        AppColors.warning,
        AppColors.border,
        AppColors.border,
      ],
      _PasswordStrength.good: [
        AppColors.success,
        AppColors.success,
        AppColors.success,
        AppColors.border,
      ],
      _PasswordStrength.strong: [
        AppColors.success,
        AppColors.success,
        AppColors.success,
        AppColors.success,
      ],
    };

    final labels = {
      _PasswordStrength.weak: 'Weak',
      _PasswordStrength.fair: 'Fair',
      _PasswordStrength.good: 'Good',
      _PasswordStrength.strong: 'Strong',
    };

    final labelColors = {
      _PasswordStrength.weak: AppColors.error,
      _PasswordStrength.fair: AppColors.warning,
      _PasswordStrength.good: AppColors.success,
      _PasswordStrength.strong: AppColors.success,
    };

    final segs = colors[strength]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: segs
              .map(
                (c) => Expanded(
                  child: Container(
                    height: 4,
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 4),
        Text(
          labels[strength]!,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: labelColors[strength],
          ),
        ),
      ],
    );
  }
}

class _PrimaryRegButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryRegButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textInverse,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textInverse,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _BackLink extends StatelessWidget {
  final VoidCallback onTap;

  const _BackLink({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: EdgeInsets.zero,
        ),
        icon: const Icon(Icons.arrow_back_rounded, size: 16),
        label: const Text(
          'Back',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.border, thickness: 1),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR CONTINUE WITH',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.border, thickness: 1),
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialBtn({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -180,
          left: -180,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.06),
                  AppColors.primary.withValues(alpha: 0.02),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -160,
          right: -160,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.04),
                  AppColors.primary.withValues(alpha: 0.01),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Enums ───────────────────────────────────────────────────────────────────

enum _PasswordStrength { none, weak, fair, good, strong }

// ── Shared text styles ──────────────────────────────────────────────────────

const _headingStyle = TextStyle(
  fontSize: 26,
  fontWeight: FontWeight.w700,
  color: AppColors.textPrimary,
  letterSpacing: -0.6,
  height: 1.2,
);

const _subtitleStyle = TextStyle(
  fontSize: 15,
  color: AppColors.textSecondary,
  height: 1.5,
);

const _labelStyle = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: AppColors.textSecondary,
);