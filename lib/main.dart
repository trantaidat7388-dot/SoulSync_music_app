import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';
import 'theme/colors.dart';
import 'services/app_language.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLanguage _appLanguage = AppLanguage();

  @override
  void initState() {
    super.initState();
    _appLanguage.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _appLanguage.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoulSync Music',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.backgroundLight,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        // Áp dụng font Plus Jakarta Sans cho toàn bộ app
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const OnboardingScreen(),
    );
  }
}