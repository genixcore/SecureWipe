// lib/login_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;
  bool _remember = false;
  bool _isSigningIn = false;

  // Colors
  static const Color _bg = Color(0xFFF8F9FC);
  static const Color _primary = Color(0xFF094EBE);
  static const Color _muted = Color(0xFF49699C);
  static const Color _text = Color(0xFF0D131C);
  static const Color _border = Color(0xFFCED8E8);

  final RegExp _emailRegExp = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");

  bool get _isFormValid {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    return email.isNotEmpty && _emailRegExp.hasMatch(email) && password.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFieldChange);
    _passwordController.addListener(_onFieldChange);
  }

  void _onFieldChange() => setState(() {});

  @override
  void dispose() {
    _emailController.removeListener(_onFieldChange);
    _passwordController.removeListener(_onFieldChange);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildInputWithLeadingIcon({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(icon, color: _muted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              style: GoogleFonts.inter(color: _text, fontSize: 15),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: _muted),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Future<void> _onSignInPressed() async {
    if (!_isFormValid || _isSigningIn) return;
    setState(() => _isSigningIn = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isSigningIn = false);

    // Navigate to profile page (intermediate)
    Navigator.of(context).pushReplacementNamed('/profile');
  }

  @override
  Widget build(BuildContext context) {
    final double cardMaxWidth = 360;
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: cardMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Icon(Icons.watch_later_outlined, color: Colors.white, size: 22)),
                  ),
                  const SizedBox(height: 12),
                  Text('Welcome Back', style: GoogleFonts.inter(fontSize: 30, fontWeight: FontWeight.w700, color: _text)),
                  const SizedBox(height: 8),
                  Text('Sign in to access your secure dashboard',
                      style: GoogleFonts.inter(fontSize: 15, color: _muted), textAlign: TextAlign.center),
                  const SizedBox(height: 24),

                  // inputs
                  _buildInputWithLeadingIcon(icon: Icons.mail_outlined, hint: 'Email Address', controller: _emailController, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      _buildInputWithLeadingIcon(icon: Icons.lock_outline, hint: 'Password', controller: _passwordController, obscureText: _obscure),
                      Positioned(
                        right: 12,
                        child: IconButton(
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 32),
                          onPressed: () => setState(() => _obscure = !_obscure),
                          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: _muted),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () => setState(() => _remember = !_remember),
                        child: Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: _border),
                                color: _remember ? _primary : Colors.white,
                              ),
                              child: _remember ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 8),
                            Text('Remember me', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: _text)),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(60, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        child: Text('Forgot password?', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: _primary)),
                      )
                    ],
                  ),

                  const SizedBox(height: 18),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isFormValid && !_isSigningIn ? _onSignInPressed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFormValid ? _primary : _primary.withOpacity(0.45),
                        foregroundColor: Colors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isSigningIn ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Sign In'),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(children: [
                    Expanded(child: Container(height: 1, color: _border)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 12.0), child: Text('or continue with', style: GoogleFonts.inter(color: _muted, fontSize: 13))),
                    Expanded(child: Container(height: 1, color: _border)),
                  ]),

                  const SizedBox(height: 20),

                  Row(children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(elevation: 2, backgroundColor: Colors.white, foregroundColor: _text, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _border)), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          // simple google icon (circle)
                          Container(width: 20, height: 20, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.transparent), child: const Icon(Icons.g_mobiledata, size: 18, color: Colors.black)),
                          const SizedBox(width: 8),
                          Text('Google', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(elevation: 2, backgroundColor: Colors.white, foregroundColor: _text, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: _border)), padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          const Icon(Icons.apple, size: 18),
                          const SizedBox(width: 8),
                          Text('Apple', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 28),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(color: _muted, fontSize: 13),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(text: 'Sign up', style: GoogleFonts.inter(color: _primary, fontWeight: FontWeight.w600), recognizer: TapGestureRecognizer()..onTap = () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
