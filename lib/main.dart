// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './configs/routes.dart';
import './configs/theme.dart';
import './pages/auth/login_page.dart';
import './pages/auth/role_select_page.dart';
import './pages/home/home_page.dart';
import './pages/onboarding/onboarding_page.dart';
import './services/preferences_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _hasSeenOnboarding() async {
    final PreferencesService preferencesService = PreferencesService();
    return preferencesService.hasSeenOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme baseTextTheme = Typography.material2021().englishLike;
    final MaterialTheme materialTheme = MaterialTheme(baseTextTheme);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AsistApp',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      routes: {
        AppRoutes.onboarding: (context) => const OnboardingPage(),
        AppRoutes.roleSelect: (context) => const RoleSelectPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const HomePage(),
      },
      home: FutureBuilder<bool>(
        future: _hasSeenOnboarding(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SplashLoadingPage();
          }

          if (snapshot.hasError) {
            return const OnboardingPage();
          }

          final bool hasSeenOnboarding = snapshot.data ?? false;

          if (hasSeenOnboarding) {
            return const LoginPage();
          }

          return const OnboardingPage();
        },
      ),
    );
  }
}

class SplashLoadingPage extends StatelessWidget {
  const SplashLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff0f1117) : AppColors.background,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}