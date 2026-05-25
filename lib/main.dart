// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './configs/routes.dart';
import './configs/theme.dart';
import './pages/auth/login_page.dart';
import './pages/auth/register_page.dart';
import './pages/auth/role_select_page.dart';
import './pages/home/home_page.dart';
import './pages/welcome/welcome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        AppRoutes.welcome: (context) => const WelcomePage(),
        AppRoutes.roleSelect: (context) => const RoleSelectPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const HomePage(),
      },
      home: const WelcomePage(),
    );
  }
}