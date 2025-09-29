// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Pages/DashboardPage.dart';
import 'Pages/LoginPage.dart';
import 'Pages/profile_page.dart';
import 'Pages/certificate_page.dart';  // Import the new page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const DataWiperApp());
}

class DataWiperApp extends StatelessWidget {
  const DataWiperApp({super.key});

  ThemeData _buildLightTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8F9FC),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(bodyColor: const Color(0xFF0D131C)),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF094EBE), brightness: Brightness.light),
    );
  }

  ThemeData _buildDarkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF094EBE), brightness: Brightness.dark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DataWiper',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      routes: {
        '/': (context) => const LoginPage(),
        '/profile': (context) => const ProfilePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/certificate': (context) => const CertificatePage(),   // Add your new route here
      },
      initialRoute: '/',
    );
  }
}
