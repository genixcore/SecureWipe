// lib/profile_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Mythic-level Profile / Details page
/// - high contrast labels/placeholders (no invisible text)
/// - frosted glass card, subtle animations, gradient CTA
/// - client-side validation, Continue enabled only when form valid
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  // controllers
  final TextEditingController _username = TextEditingController();
  final TextEditingController _organization = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _serial = TextEditingController();

  bool _agree = false;
  bool _autoValidate = false;
  bool _submitting = false;

  // theme tokens
  static const Color _primary = Color(0xFF094EBE);
  static const Color _primary700 = Color(0xFF0844A9);
  static const Color _bg = Color(0xFFF6F8FB);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _muted = Color(0xFF6B7280);
  static const Color _text = Color(0xFF0D131C);

  late final AnimationController _entrance;
  late final Animation<double> _cardOpacity;
  late final Animation<Offset> _cardOffset;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // small entrance animation for the content card
    _entrance = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
    _cardOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOut));
    _cardOffset = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic));
    Timer(const Duration(milliseconds: 120), () => _entrance.forward());

    // listen to controllers to update form state live
    _username.addListener(_onChanged);
    _organization.addListener(_onChanged);
    _email.addListener(_onChanged);
    _serial.addListener(_onChanged);
  }

  @override
  void dispose() {
    _entrance.dispose();
    _username.dispose();
    _organization.dispose();
    _email.dispose();
    _serial.dispose();
    super.dispose();
  }

  void _onChanged() {
    // rebuild to update Continue button state / inline validation if autoValidate is true
    if (mounted) setState(() {});
  }

  bool get _isFormFilled =>
      _username.text.trim().isNotEmpty &&
          _organization.text.trim().isNotEmpty &&
          _email.text.trim().isNotEmpty &&
          _serial.text.trim().isNotEmpty &&
          _agree;

  // small email regex (client-side only)
  final RegExp _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!_emailRe.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _validateNotEmpty(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  Future<void> _onContinue() async {
    setState(() => _autoValidate = true);

    // validate form fields
    if (!(_formKey.currentState?.validate() ?? false) || !_agree) {
      // show a small snackbar if agreement missing
      if (!_agree) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You must agree before continuing.'),
          behavior: SnackBarBehavior.floating,
        ));
      }
      return;
    }

    setState(() => _submitting = true);

    // simulate small processing delay (offline)
    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;
    setState(() => _submitting = false);

    // navigate to dashboard (replace)
    Navigator.of(context).pushReplacementNamed('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final double maxContentWidth = 720; // scales on wider devices if needed

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Background: subtle radial gradient to feel premium
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(-0.6, -0.8),
                    radius: 1.0,
                    colors: [_bg, const Color(0xFFF0F3F8)],
                  ),
                ),
                child: const SizedBox.shrink(),
              ),
            ),

            // top-left accent blob (pure decoration)
            Positioned(
              left: -60,
              top: -40,
              child: Transform.rotate(
                angle: -0.35,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [_primary.withOpacity(0.14), _primary.withOpacity(0.06)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(48),
                    boxShadow: [BoxShadow(color: _primary.withOpacity(0.06), blurRadius: 20, offset: const Offset(8, 10))],
                  ),
                ),
              ),
            ),

            // Content area
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxContentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),

                      // Header with small icon
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: _text,
                            tooltip: 'Back',
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                // App icon + title
                                ScaleTransition(
                                  scale: CurvedAnimation(parent: _entrance, curve: Curves.easeOut),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: [_primary, _primary700]),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [BoxShadow(color: _primary.withOpacity(0.18), blurRadius: 20, offset: const Offset(0, 8))],
                                    ),
                                    child: const Center(child: Icon(Icons.watch_later_outlined, color: Colors.white, size: 30)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text('Profile', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w800, color: _text)),
                                const SizedBox(height: 6),
                                Text('Fill in details before continuing', style: GoogleFonts.inter(color: _muted)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 48), // keep header symmetrical
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Animated card (frosted glass look)
                      FadeTransition(
                        opacity: _cardOpacity,
                        child: SlideTransition(
                          position: _cardOffset,
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: _card,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 18, offset: const Offset(0, 8)),
                              ],
                              border: Border.all(color: Colors.white.withOpacity(0.6)),
                            ),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Intro line
                                  Text('Detail section', style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 16, color: _text)),
                                  const SizedBox(height: 12),

                                  // Username
                                  _buildField(
                                    label: 'Username / Full Name',
                                    controller: _username,
                                    hint: 'Enter your name',
                                    validator: (v) => _validateNotEmpty(v, 'Name'),
                                    icon: Icons.person_outline,
                                  ),
                                  const SizedBox(height: 12),

                                  // Organization
                                  _buildField(
                                    label: 'Organization',
                                    controller: _organization,
                                    hint: 'Enter organization',
                                    validator: (v) => _validateNotEmpty(v, 'Organization'),
                                    icon: Icons.domain,
                                  ),
                                  const SizedBox(height: 12),

                                  // Email
                                  _buildField(
                                    label: 'Email',
                                    controller: _email,
                                    hint: 'Enter email address',
                                    keyboard: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                    icon: Icons.mail_outline,
                                  ),
                                  const SizedBox(height: 12),

                                  // Device serial
                                  _buildField(
                                    label: 'Device Serial Number',
                                    controller: _serial,
                                    hint: 'serial number',
                                    validator: (v) => _validateNotEmpty(v, 'Device Serial Number'),
                                    icon: Icons.sd_storage,
                                  ),
                                  const SizedBox(height: 12),

                                  // Agreement
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        borderRadius: BorderRadius.circular(6),
                                        onTap: () => setState(() => _agree = !_agree),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 220),
                                          width: 22,
                                          height: 22,
                                          decoration: BoxDecoration(
                                            color: _agree ? _primary : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: _agree ? _primary : Colors.grey.shade300, width: 1.6),
                                          ),
                                          child: _agree
                                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            text: 'I agree to wipe all data permanently and understand it cannot be recovered.',
                                            style: GoogleFonts.inter(color: Colors.grey[800], height: 1.35),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // helper text if not agreed but attempted continue (only visible after attempted validation)
                                  if (_autoValidate && !_agree)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text('You must agree to continue.', style: GoogleFonts.inter(color: Colors.red[700], fontSize: 13)),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // CTA group
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _isFormFilled && !_submitting ? _onContinue : null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: _isFormFilled && !_submitting
                                      ? const LinearGradient(colors: [_primary, _primary700])
                                      : LinearGradient(colors: [_primary.withOpacity(0.45), _primary700.withOpacity(0.45)]),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: _isFormFilled
                                      ? [BoxShadow(color: _primary.withOpacity(0.22), blurRadius: 18, offset: const Offset(0, 10))]
                                      : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 3))],
                                ),
                                child: Center(
                                  child: _submitting
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white))
                                      : Text(
                                    'Continue',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 110,
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: BorderSide(color: Colors.grey.shade200),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Text('Cancel', style: GoogleFonts.inter(color: Colors.grey[800], fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build labeled fields with icon and validation-friendly InputDecoration
  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboard = TextInputType.text,
    IconData? icon,
  }) {
    final bool showError = _autoValidate && (validator?.call(controller.text) != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label (always visible and high contrast)
        Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: _text)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          autovalidateMode: _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
          validator: validator,
          style: GoogleFonts.inter(fontSize: 15, color: _text),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
            prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600) : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primary, width: 1.8),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 1.6),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade700, width: 1.8),
            ),
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 4),
            child: Text(
              validator?.call(controller.text) ?? '',
              style: GoogleFonts.inter(color: Colors.red[700], fontSize: 12),
            ),
          ),
      ],
    );
  }

  // Helper validators used above

}
