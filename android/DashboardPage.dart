import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const Color bgColor = Color(0xFFF8F9FC);
  static const Color textColor = Color(0xFF0D131C);
  static const Color primary900 = Color(0xFF094EBE);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const double cardRadius = 16;

  String? _selectedDriveName;
  String? _selectedDriveImageUrl;
  String _selectedPasses = '3 Passes (Recommended)';
  final List<String> _passesOptions = [
    '1 Pass',
    '2 Passes',
    '3 Passes (Recommended)',
    '4 Passes',
    '5 Passes',
    '6 Passes',
    '7 Passes',
  ];

  final Map<String, String> _sampleDrives = {
    'Internal SSD — 512GB': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBecMcdVakUiolM-Xj_ggQ3cWm-Q5gIJ1BqY6Y0_oMR4WClvkny8MPgkJZLJ9Bz6rxiOj_7WzcZ30bj2B8U97qEppDXrvC_lg1c8xG-4CYdfn7kzcrhjJCdoSzvOZ9QLahYl_ofuXlRg2jf2ZAHpL0DR-NzG8JIe-kLRNIl115vp8keldnLHKlzK-fKDiQqeUKDu8nsQYUijYlKoJficFi5k0zJOum3tulKGFzNBHgamaXGx9updqcDlZhJALCmSgHL6pJeZAfX1hI',
    'External HDD — 2TB': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDp3jrqiE_sENFRM1UmzlD_IJxnCf7SRWlTdlWOdU28KP71QD2ZeBTrabXQBJXTFwqJmm7KJkvHRnXR_7DjP1WxgJhyhoTlLhoTTk2AVjvtn7vt6cyGsosvKNQwPyfWXcDEfrxtcnPKPymWMpYUTyWzrxkew3IX5w1GyBz3brgyDKDJ8S7kKneXX00shJet0b7YO4ksHwb7uY-WupPTQqE_knsw3ADCoqfvjNnxqdykdVwRTsgnGoeV4eO2bctMTMu2o2JNaNZZW_s',
    'USB Drive — 64GB': 'https://via.placeholder.com/150?text=USB+64GB',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Secure Data Wipe',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                  ),
                  Container(width: 40, height: 40),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const SizedBox(height: 6),
                    Card(
                      color: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.05),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(cardRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Drive Selection',
                                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700,color: Colors.black),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Select the drive you want to securely wipe.',
                                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: _onBrowseDrives,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: slate100,
                                      foregroundColor: Colors.grey[850],
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Browse Drives'),
                                        SizedBox(width: 8),
                                        Icon(Icons.chevron_right, size: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 96,
                                height: 96,
                                color: Colors.grey[200],
                                child: _selectedDriveImageUrl != null
                                    ? Image.network(
                                        _selectedDriveImageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => _drivePlaceholder(),
                                      )
                                    : _drivePlaceholder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: Colors.white,
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.05),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cardRadius)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Wipe Settings', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700,color: Colors.black)),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Configure the number of overwrite passes for secure data deletion.',
                                    style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: slate100,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedPasses,
                                        isExpanded: true,
                                        items: _passesOptions.map((p) {
                                          return DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.inter(fontWeight: FontWeight.w600,color: Colors.black)));
                                        }).toList(),
                                        onChanged: (v) {
                                          if (v == null) return;
                                          setState(() => _selectedPasses = v);
                                        },
                                        icon: const Icon(Icons.expand_more, color: Colors.black54),
                                        dropdownColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 96,
                                height: 96,
                                color: Colors.grey[200],
                                child: Image.network(
                                  _sampleDrives.values.elementAt(1),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _drivePlaceholder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: slate100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: primary900.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.shield, color: primary900),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Security level: ',
                                style: GoogleFonts.inter(fontSize: 14,color: Colors.black),
                                children: [
                                  TextSpan(text: 'High', style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.red)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      // The container below contained the 'Start Wipe' button and its surrounding safe area/box decoration.
                      // Removed the unnecessary white background container for the start wipe button.
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: SafeArea(
                        top: false,
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _selectedDriveName != null ? _onStartWipe : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _selectedDriveName != null ? primary900 : primary900.withOpacity(0.45),
                              foregroundColor: Colors.white, // Visible text
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            child: const Text('Start Wipe'),
                          ),
                        ),
                      ),
                    ),
                    // START WIPE button had surrounding container for shadow, I will re-add a minimal one
                    // to keep the visual style consistent with the original intent.
                    // The old structure was: Container > SafeArea > SizedBox > ElevatedButton
                    // I'll ensure the surrounding container is gone and the button stands alone in the list view.
                    
                    // REMOVED: The following block containing the always-visible 'Generate Certificate' button.
                    // const SizedBox(height: 16),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       Navigator.of(context).pushNamed('/certificate');
                    //     },
                    //     // ... styles ...
                    //     child: const Text('Generate Certificate'),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drivePlaceholder() {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: Icon(Icons.storage, color: Colors.grey[500], size: 36),
    );
  }

  void _onBrowseDrives() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DrivelistBottomSheet(drives: _sampleDrives);
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedDriveName = selected;
        _selectedDriveImageUrl = _sampleDrives[selected];
      });
    }
  }

  void _onStartWipe() {
    if (_selectedDriveName == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => WipeProgressPage(
      driveName: _selectedDriveName!,
      passes: _selectedPasses,
    )));
  }
}

class DrivelistBottomSheet extends StatelessWidget {
  final Map<String, String> drives;
  const DrivelistBottomSheet({super.key, required this.drives});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 4, width: 36, margin: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 6),
            Text('Select Drive', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: drives.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, idx) {
                  final name = drives.keys.elementAt(idx);
                  final url = drives.values.elementAt(idx);
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.storage),
                        ),
                      ),
                    ),
                    title: Text(name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    subtitle: Text(idx == 0 ? 'Internal' : idx == 1 ? 'External' : 'Removable', style: GoogleFonts.inter(fontSize: 12)),
                    onTap: () => Navigator.of(context).pop(name),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class WipeProgressPage extends StatefulWidget {
  final String driveName;
  final String passes;
  const WipeProgressPage({super.key, required this.driveName, required this.passes});

  @override
  State<WipeProgressPage> createState() => _WipeProgressPageState();
}

class _WipeProgressPageState extends State<WipeProgressPage> {
  double _progress = 0;
  late Timer _timer;
  int _currentPass = 0;
  late int _totalPasses;

  @override
  void initState() {
    super.initState();
    final match = RegExp(r'(\d+)').firstMatch(widget.passes);
    _totalPasses = match != null ? int.tryParse(match.group(1)!) ?? 3 : 3;
    _currentPass = 0;
    _startSimulation(_totalPasses);
  }

  void _startSimulation(int passes) {
    const totalMs = 5000;
    const tickMs = 150;
    final numTicks = totalMs ~/ tickMs;
    int tickCount = 0;
    _timer = Timer.periodic(const Duration(milliseconds: tickMs), (t) {
      tickCount++;
      setState(() => _progress = (tickCount / numTicks).clamp(0.0, 1.0));
      final passNow = ((tickCount / numTicks) * passes).floor();
      if (passNow > _currentPass && passNow <= passes) {
        setState(() => _currentPass = passNow);
      }
      if (tickCount >= numTicks) {
        t.cancel();
        if (mounted) {
          // MODIFIED: Navigate to WipeCompletePage instead of showing an AlertDialog
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => WipeCompletePage(
              method: 'DoD 5220.22-M',
              securityLevel: 'High',
              totalPasses: _totalPasses,
            ),
          ));
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wipe Progress', style: GoogleFonts.inter(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 6),
            LinearProgressIndicator(value: _progress, minHeight: 8),
            const SizedBox(height: 16),
            Text('${(_progress * 100).toStringAsFixed(0)}%', style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Status: In secure wipe operation', style: GoogleFonts.inter(color: Colors.grey[700])),
            const SizedBox(height: 18),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Method', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      Text('DoD 5220.22-M', style: GoogleFonts.inter(color: Colors.grey[700])),
                    ]),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Passes completed', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      Text('$_currentPass', style: GoogleFonts.inter(color: Colors.grey[700])),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _totalPasses,
                itemBuilder: (ctx, idx) {
                  final passed = idx < _currentPass;
                  final inProgress = idx == _currentPass;
                  return ListTile(
                    leading: Icon(
                      passed ? Icons.check_circle : (inProgress ? Icons.timelapse : Icons.pending), 
                      color: passed ? Colors.green : (inProgress ? Colors.orange : Colors.grey)
                    ),
                    title: Text(
                      'Pass ${idx + 1} ${passed ? 'complete' : (inProgress ? 'in progress' : 'pending')}', 
                      style: GoogleFonts.inter()
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MINIMAL PLACEHOLDER for WipeCompletePage to ensure WipeProgressPage can navigate.
// This page is where the 'Generate Certificate' button should now reside.
class WipeCompletePage extends StatelessWidget {
  final String method;
  final String securityLevel;
  final int totalPasses;
  const WipeCompletePage({super.key, required this.method, required this.securityLevel, required this.totalPasses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wipe Complete')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text('Drive Internal SSD — 512GB wiped successfully!', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 32),
            // The Generate Certificate button is now correctly placed on the completion screen
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/certificate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF094EBE),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Generate Certificate'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Return to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}