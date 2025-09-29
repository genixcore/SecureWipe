// lib/process_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProcessPage extends StatefulWidget {
  // You can pass initial values if desired
  final int initialPercent; // 0..100
  final String method;
  final String securityLevel;
  final int totalPasses;
  const ProcessPage({
    super.key,
    this.initialPercent = 0,
    this.method = 'DoD 5220.22-M',
    this.securityLevel = 'High',
    this.totalPasses = 3,
  });

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> with SingleTickerProviderStateMixin {
  // Colors / tokens from your HTML
  static const Color _primary = Color(0xFF094EBE);
  static const Color _secondary = Color(0xFFE7ECF4);
  static const Color _bg = Color(0xFFF8F9FC);
  static const Color _textPrimary = Color(0xFF0D131C);
  static const Color _textSecondary = Color(0xFF49699C);
  static const double _cardRadius = 16;

  late double _percent; // 0.0..1.0
  late Timer _timer;
  int _currentPass = 1;
  bool _isRunning = true;

  // for pulsing animation of the sync icon
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _percent = (widget.initialPercent.clamp(0, 100)) / 100.0;

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.12).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _pulseController.repeat(reverse: true);

    // start a simulation only if percent < 1.0
    if (_percent < 1.0) {
      _startSimulation();
    } else {
      _isRunning = false;
    }
  }

  void _startSimulation() {
    const tickMs = 120;
    _timer = Timer.periodic(const Duration(milliseconds: tickMs), (t) {
      if (!mounted) return;
      setState(() {
        // advance slowly
        _percent = (_percent + 0.005).clamp(0.0, 1.0);
        // update current pass depending on percent
        final p = ((_percent) * widget.totalPasses).ceil();
        _currentPass = p == 0 ? 1 : p;
      });

      if (_percent >= 1.0) {
        t.cancel();
        _isRunning = false;
        // optionally show completion dialog
        Future.delayed(const Duration(milliseconds: 220), () {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Wipe Complete'),
              content: const Text('Wipe operation finished successfully.'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
              ],
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentInt = (_percent * 100).round();
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Centered title
                  Expanded(
                    child: Text(
                      'Wiping in progress',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _textPrimary,
                        letterSpacing: -0.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Percentage big
                    Column(
                      children: [
                        Text(
                          '$percentInt%',
                          style: GoogleFonts.inter(
                            fontSize: 56, // text-6xl approx
                            fontWeight: FontWeight.w700,
                            color: _primary,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // progress bar container
                        Container(
                          width: double.infinity,
                          height: 10,
                          decoration: BoxDecoration(
                            color: _secondary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Stack(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 160),
                                  width: constraints.maxWidth * _percent,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Info card (Method / Security)
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_cardRadius)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            // In Progress row with spinner
                            Row(
                              children: [
                                // spinner (border-b style)
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: _isRunning
                                      ? CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    valueColor: AlwaysStoppedAnimation<Color>(_primary),
                                  )
                                      : Icon(Icons.check_circle, color: Colors.green[600]),
                                ),
                                const SizedBox(width: 12),
                                Text('In Progress', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary)),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Method & Security rows
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Method', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                    Text(widget.method, style: GoogleFonts.inter(color: _textSecondary)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Security Level', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                                    Text(widget.securityLevel, style: GoogleFonts.inter(color: _textSecondary)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Activity log
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Activity Log', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: _textPrimary)),
                        const SizedBox(height: 12),
                        ...List.generate(widget.totalPasses, (index) {
                          final idx = index + 1;
                          final completed = idx < _currentPass;
                          final inProgress = idx == _currentPass && _isRunning && _percent < 1.0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                if (completed)
                                  Icon(Icons.check_circle, color: Colors.green[600])
                                else if (inProgress)
                                  ScaleTransition(
                                    scale: _pulseAnim,
                                    child: Icon(Icons.sync, color: _primary),
                                  )
                                else
                                  Icon(Icons.timelapse, color: Colors.orange[700]),
                                const SizedBox(width: 12),
                                Text(
                                  completed
                                      ? 'Pass $idx complete'
                                      : inProgress
                                      ? 'Pass $idx in progress'
                                      : 'Pass $idx pending',
                                  style: GoogleFonts.inter(color: completed ? _textSecondary : _textPrimary),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sticky footer with Cancel
            Container(
              color: _bg,
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onCancelPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _secondary,
                      foregroundColor: _textPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Cancel', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCancelPressed() {
    // stop simulation and pop back
    if (_timer.isActive) _timer.cancel();
    _pulseController.stop();
    if (mounted) Navigator.of(context).maybePop();
  }
}
