import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart';
import '../services/auth_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final APIService _api = APIService();
  final AuthStorage _storage = AuthStorage();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePwd = true;
  bool _rememberMe = true;

  final _emailNode = FocusNode();
  final _pwdNode = FocusNode();

  static const _bgGradient = LinearGradient(
    colors: [Color(0xFF6D8BFE), Color(0xFF7ED6DF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const _btnGradient = LinearGradient(
    colors: [Color(0xFF736EFE), Color(0xFF62E0E6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const _btnGradientDisabled = LinearGradient(
    colors: [Color(0xFFBFC6FF), Color(0xFFAEE9EC)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      await _api.login(email: email, password: password);

      if (_rememberMe &&
          _api.accessToken != null &&
          _api.accessToken!.isNotEmpty) {
        await _storage.saveSession(
          AuthSession(
            accessToken: _api.accessToken!,
            refreshToken: _api.refreshToken ?? '',
            expiresAt: _api.expiresAt,
          ),
        );
      }

      if (!mounted) return;

      HapticFeedback.lightImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logged in successfully')),
      );

      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } on ApiException catch (e) {
      if (!mounted) return;

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _onForgotPassword() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password: backend route not implemented yet'),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailNode.dispose();
    _pwdNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: _bgGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 14,
                  shadowColor: Colors.black26,
                  color: isDark ? const Color(0xFF14161A) : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (b) => _btnGradient.createShader(
                              Rect.fromLTWH(0, 0, b.width, b.height),
                            ),
                            child: const Icon(Icons.lock_outline, size: 54),
                          ),
                          const SizedBox(height: 12),
                          ShaderMask(
                            blendMode: BlendMode.srcIn,
                            shaderCallback: (r) => _btnGradient.createShader(
                              Rect.fromLTWH(0, 0, r.width, r.height),
                            ),
                            child: Text(
                              'Welcome Back',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sign in to continue',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            focusNode: _emailNode,
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                            decoration: _inputDecoration(
                              label: 'Email',
                              icon: Icons.alternate_email,
                              isDark: isDark,
                            ),
                            validator: (v) {
                              final value = v?.trim() ?? '';
                              if (value.isEmpty) return 'Please enter email';

                              final emailReg = RegExp(
                                r'^[\w.\-]+@([\w\-]+\.)+[a-zA-Z]{2,}$',
                              );

                              if (!emailReg.hasMatch(value)) {
                                return 'Invalid email format';
                              }

                              return null;
                            },
                            onFieldSubmitted: (_) => _pwdNode.requestFocus(),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            focusNode: _pwdNode,
                            controller: _passwordController,
                            obscureText: _obscurePwd,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onFieldSubmitted: (_) => login(),
                            decoration: _inputDecoration(
                              label: 'Password',
                              icon: Icons.lock,
                              isDark: isDark,
                              suffix: IconButton(
                                onPressed: () {
                                  setState(() => _obscurePwd = !_obscurePwd);
                                },
                                icon: Icon(
                                  _obscurePwd
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                tooltip: _obscurePwd
                                    ? 'Show password'
                                    : 'Hide password',
                              ),
                            ),
                            validator: (v) {
                              final value = v ?? '';
                              if (value.isEmpty) return 'Please enter password';
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (v) {
                                  setState(() => _rememberMe = v ?? true);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const Text('Remember me'),
                              const Spacer(),
                              TextButton(
                                onPressed: _onForgotPassword,
                                child: const Text('Forgot password?'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: _GradientButton(
                              onPressed: _isLoading ? null : login,
                              isLoading: _isLoading,
                              gradient: _isLoading
                                  ? _btnGradientDisabled
                                  : _btnGradient,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  'or',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialIconButton(
                                icon: Icons.g_mobiledata_rounded,
                                tooltip: 'Continue with Google',
                                onTap: () {},
                              ),
                              const SizedBox(width: 12),
                              _SocialIconButton(
                                icon: Icons.apple,
                                tooltip: 'Continue with Apple',
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/signup');
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Don't have an account? ",
                                style: theme.textTheme.bodyMedium,
                                children: const [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
    Widget? suffix,
  }) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: isDark ? const Color(0xFF2B2F36) : const Color(0xFFE6E8EF),
      ),
    );

    return InputDecoration(
      labelText: label,
      prefixIcon: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (b) {
          return _btnGradient.createShader(
            Rect.fromLTWH(0, 0, b.width, b.height),
          );
        },
        child: Icon(icon),
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: isDark ? const Color(0xFF191C22) : const Color(0xFFF7F9FC),
      border: baseBorder,
      enabledBorder: baseBorder,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          width: 1.6,
          color: Color(0xFF736EFE),
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final Gradient gradient;

  const _GradientButton({
    required this.onPressed,
    required this.child,
    required this.gradient,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.6,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Padding(
                      key: const ValueKey('text'),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 56,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [Color(0x33736EFE), Color(0x3362E0E6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (b) => const LinearGradient(
                colors: [Color(0xFF736EFE), Color(0xFF62E0E6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(
                Rect.fromLTWH(0, 0, b.width, b.height),
              ),
              child: Icon(icon, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}