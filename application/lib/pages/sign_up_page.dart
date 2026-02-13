import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../services/api_service.dart';

/// =========================
/// UI helpers (only UI layer)
/// =========================

const _bgGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF6F95FA),
    Color(0xFF7AC6E6),
  ],
);

const _primaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF717BFB),
    Color(0xFF64D3E9),
  ],
);

class _GradientText extends StatelessWidget {
  const _GradientText(
    this.text, {
    required this.style,
    super.key,
  });

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => _primaryGradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style),
    );
  }
}

class _LockBadge extends StatelessWidget {
  const _LockBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F5FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(
        Icons.lock_outline_rounded,
        color: Color(0xFF717BFB),
        size: 30,
      ),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF717BFB)),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF6F8FF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _primaryGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.black.withOpacity(0.12))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text("or", style: TextStyle(color: Colors.black45)),
        ),
        Expanded(child: Divider(color: Colors.black.withOpacity(0.12))),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({
    required this.child,
    this.onTap,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F5FF),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(child: child),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _apiMessage = "Checking API connection...";
  String _registrationMessage = "";

  // UI state only
  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkApi();
  }

  Future<void> _checkApi() async {
    final apiService = APIService();

    try {
      final message = await apiService.checkConnection(); // <-- String dönüyor
      if (!mounted) return;

      setState(() {
        _apiMessage = message;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _apiMessage = "Error: $e";
      });
    }
  }

  Future<void> _registerUser() async {
    final String email = _emailController.text.trim();
    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      setState(() {
        _registrationMessage = "One of the required fields is left empty";
      });
      return;
    }

    // ✅ APIService.baseUrl yok -> AppConfig.apiBaseUrl kullan
    final url = Uri.parse('${AppConfig.apiBaseUrl}/register');

    final Map<String, String> body = {
      'email': email,
      'username': username,
      'password': password,
    };

    setState(() {
      _registrationMessage = 'Registering User...';
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final dynamic decoded = jsonDecode(response.body);
      final Map<String, dynamic> responseData =
          decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 202) {
        setState(() {
          _registrationMessage =
              (responseData['message'] as String?) ?? 'Registration successful!';
        });
      } else {
        setState(() {
          _registrationMessage =
              (responseData['message'] as String?) ?? 'Registration failed';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _registrationMessage = 'Network Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = _registrationMessage.toLowerCase().contains('success') ||
        _registrationMessage.toLowerCase().contains('successfully');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: _bgGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _LockBadge(),
                      const SizedBox(height: 14),

                      _GradientText(
                        "Create Account",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Sign up to continue",
                        style: TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        _apiMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _AuthTextField(
                        controller: _emailController,
                        hintText: "Email",
                        icon: Icons.alternate_email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),

                      _AuthTextField(
                        controller: _usernameController,
                        hintText: "Username",
                        icon: Icons.person_outline_rounded,
                      ),
                      const SizedBox(height: 14),

                      _AuthTextField(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (v) {
                              setState(() {
                                _rememberMe = v ?? true;
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            side: BorderSide(color: Colors.black.withOpacity(0.2)),
                            activeColor: const Color(0xFF717BFB),
                          ),
                          const Text(
                            "Remember me",
                            style: TextStyle(color: Colors.black87),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              // Optional: forgot password
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(color: Color(0xFFFF5A66)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      _GradientButton(
                        text: "Register",
                        onPressed: _registerUser,
                      ),

                      const SizedBox(height: 12),

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _registrationMessage.isEmpty
                            ? const SizedBox.shrink()
                            : Text(
                                _registrationMessage,
                                key: ValueKey(_registrationMessage),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSuccess ? Colors.green : Colors.red,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),

                      const SizedBox(height: 18),
                      const _OrDivider(),
                      const SizedBox(height: 14),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SocialIconButton(
                            onTap: () {
                              // Optional: Google sign-in
                            },
                            child: const Text(
                              "G",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF717BFB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          _SocialIconButton(
                            onTap: () {
                              // Optional: Apple sign-in
                            },
                            child: const Icon(
                              Icons.apple,
                              color: Color(0xFF717BFB),
                              size: 22,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w800,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

