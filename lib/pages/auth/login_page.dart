// lib/pages/auth/login_page.dart

import 'package:flutter/material.dart';

import '../../configs/theme.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff0f1117) : AppColors.background,
      body: Center(
        child: Text(
          'Login',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.foreground,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}