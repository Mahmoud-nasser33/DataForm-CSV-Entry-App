import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
}

class AppTypography {
  static const TextStyle heading = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textInverse,
    letterSpacing: 0.15,
  );

  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const TextStyle input = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const DataFormApp());
}

class DataFormApp extends StatelessWidget {
  const DataFormApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DataForm CSV Entry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: '.SF Pro Display',
      ),
      home: const WelcomeScreen(),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final String label;
  final String? loadingLabel;
  final VoidCallback onTap;
  final bool isLoading;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    this.loadingLabel,
    required this.onTap,
    this.isLoading = false,
    this.height = 52,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => _ctrl.forward(),
      onTapUp: widget.isLoading
          ? null
          : (_) {
              _ctrl.reverse();
              widget.onTap();
            },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox(
          height: widget.height,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.7),
              foregroundColor: AppColors.textInverse,
              elevation: 0,
              shadowColor: AppColors.primary.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: widget.isLoading
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
                      Text(
                        widget.loadingLabel ?? widget.label,
                        style: AppTypography.button,
                      ),
                    ],
                  )
                : Text(widget.label, style: AppTypography.button),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double height;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.border, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class AppInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData leadingIcon;
  final bool isPassword;
  final bool capsLockEnabled;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;

  const AppInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.leadingIcon,
    this.isPassword = false,
    this.capsLockEnabled = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _obscure = true;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (mounted) setState(() => _focused = widget.focusNode?.hasFocus ?? false);
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
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
            onFieldSubmitted: (_) => widget.onSubmitted?.call(),
            style: AppTypography.input,
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
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                widget.leadingIcon,
                color: _focused ? AppColors.primary : AppColors.textMuted,
                size: 20,
              ),
              suffixIcon: widget.isPassword
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.capsLockEnabled)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
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
                          onPressed: () =>
                              setState(() => _obscure = !_obscure),
                        ),
                      ],
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppColors.primary, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.error, width: 1.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.error, width: 1.5),
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
        ),
      ],
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR CONTINUE WITH',
            style: AppTypography.caption,
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const SocialLoginButton({
    super.key,
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
          side: BorderSide(color: AppColors.border, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surface,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 15),
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

class DemoAccountCard extends StatelessWidget {
  const DemoAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Try Demo Account',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Email:', 'admin@dataform.com'),
                const SizedBox(height: 4),
                _detailRow('Password:', 'admin123'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class BackgroundGlow extends StatelessWidget {
  const BackgroundGlow({super.key});

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

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.table_chart_outlined,
                  color: AppColors.textInverse,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              Text('DataForm', style: AppTypography.heading),
              const SizedBox(height: 6),
              Text(
                'CSV Entry App',
                style: AppTypography.heading.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Import, manage, and export your data effortlessly.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body,
                ),
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                label: 'Login',
                onTap: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, a, b) => const LoginScreen(),
                    transitionsBuilder: (_, a, b, child) =>
                        FadeTransition(opacity: a, child: child),
                    transitionDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Create Account',
                onTap: () {},
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _capsLock = false;

  late final AnimationController _entranceCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeOffset;

  static const String _demoEmail = 'admin@dataform.com';
  static const String _demoPassword = 'admin123';

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceCtrl,
      curve: Curves.easeOutCubic,
    ));
    _entranceCtrl.forward();

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _shakeOffset = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: -3.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -3.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeCtrl,
      curve: Curves.easeInOut,
    ));

    _passwordFocus.addListener(_updateCapsLock);
  }

  void _updateCapsLock() {
    if (_passwordFocus.hasFocus) {
      final on = HardwareKeyboard.instance
          .lockModesEnabled
          .contains(KeyboardLockMode.capsLock);
      if (on != _capsLock) setState(() => _capsLock = on);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _entranceCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      _shakeCtrl.forward(from: 0);
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() => _isLoading = false);

    final email = _emailCtrl.text.trim().toLowerCase();
    final password = _passwordCtrl.text;

    if (email == _demoEmail && password == _demoPassword) {
      HapticFeedback.mediumImpact();

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, b) => const SuccessScreen(),
          transitionsBuilder: (_, a, b, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
    } else {
      HapticFeedback.heavyImpact();
      _shakeCtrl.forward(from: 0);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Invalid email or password',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () {
              _emailCtrl.clear();
              _passwordCtrl.clear();
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundGlow(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: AnimatedBuilder(
                      animation: _shakeCtrl,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(_shakeOffset.value, 0),
                        child: child,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 440),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color.fromRGBO(148, 163, 184, 0.15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(15, 23, 42, 0.08),
                              blurRadius: 40,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '\u{1F44B} Welcome Back',
                              style: AppTypography.heading,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to continue managing your workspace.',
                              style: AppTypography.subtitle,
                            ),
                            const SizedBox(height: 28),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AppInputField(
                                    controller: _emailCtrl,
                                    label: 'Email address',
                                    hint: 'you@example.com',
                                    leadingIcon:
                                        Icons.mail_outline_rounded,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    focusNode: _emailFocus,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: () =>
                                        FocusScope.of(context)
                                            .requestFocus(_passwordFocus),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Email is required';
                                      }
                                      if (!v.contains('@') ||
                                          !v.contains('.')) {
                                        return 'Enter a valid email address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  AppInputField(
                                    controller: _passwordCtrl,
                                    label: 'Password',
                                    hint: 'Enter your password',
                                    leadingIcon:
                                        Icons.lock_outline_rounded,
                                    isPassword: true,
                                    capsLockEnabled: _capsLock,
                                    focusNode: _passwordFocus,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: _login,
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Password is required';
                                      }
                                      if (v.length < 6) {
                                        return 'Minimum 6 characters required';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Checkbox(
                                              value: _rememberMe,
                                              onChanged: (v) => setState(
                                                  () => _rememberMe =
                                                      v ?? false),
                                              activeColor: AppColors.primary,
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              side: BorderSide(
                                                color: AppColors.border,
                                                width: 1.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Remember me',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: const Text(
                                                'Reset link sent to your email',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape:
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              margin: const EdgeInsets
                                                  .fromLTRB(16, 0, 16, 24),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap,
                                        ),
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  PrimaryButton(
                                    label: 'Login',
                                    loadingLabel: 'Signing in...',
                                    onTap: _login,
                                    isLoading: _isLoading,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),
                            const OrDivider(),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                SocialLoginButton(
                                  label: 'Google',
                                  onTap: () {},
                                  icon: const Text(
                                    'G',
                                    style: TextStyle(
                                      color: Color(0xFFDB4437),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                SocialLoginButton(
                                  label: 'Facebook',
                                  onTap: () {},
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const DemoAccountCard(),
                          ],
                        ),
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
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Welcome!',
                  style: AppTypography.heading,
                ),
                const SizedBox(height: 8),
                Text(
                  'You have successfully logged in.',
                  style: AppTypography.subtitle,
                ),
                const SizedBox(height: 40),
                PrimaryButton(
                  label: 'Sign Out',
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, a, b) => const WelcomeScreen(),
                        transitionsBuilder: (_, a, b, child) =>
                            FadeTransition(opacity: a, child: child),
                        transitionDuration:
                            const Duration(milliseconds: 300),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Your teammate can add the\nregistration flow here.',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
