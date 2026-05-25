// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './configs/routes.dart';
import './configs/theme.dart';
import 'pages/admin_analytics/admin_analytics_page.dart';
import 'pages/admin_config/admin_config_page.dart';
import 'pages/admin_dashboard/admin_dashboard_page.dart';
import 'pages/admin_home/admin_home_page.dart';
import 'pages/admin_setup/admin_setup_page.dart';
import 'pages/admin_setup_success/admin_setup_success_page.dart';
import 'pages/admin_validate/admin_validate_page.dart';
import 'pages/auth/login/login_page.dart';
import 'pages/setup/org_code/org_code_page.dart';
import 'pages/setup/pending/pending_page.dart';
import 'pages/auth/register/register_page.dart';
import 'pages/setup/role_select/role_select_page.dart';
import './pages/dashboard/dashboard_page.dart';
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
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      routes: {
        AppRoutes.welcome: (context) => const WelcomePage(),
        AppRoutes.roleSelect: (context) => const RoleSelectPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.orgCode: (context) => const OrgCodePage(),
        AppRoutes.pending: (context) => const PendingPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const DashboardPage(),
        AppRoutes.adminDashboard: (context) => const AdminDashboardPage(),
        AppRoutes.adminHome: (context) => const AdminHomePage(),
        AppRoutes.adminValidate: (context) => const AdminValidatePage(),
        AppRoutes.adminAnalytics: (context) => const AdminAnalyticsPage(),
        AppRoutes.adminConfig: (context) => const AdminConfigPage(),
        AppRoutes.adminSetup: (context) => AdminSetupPage(),
        AppRoutes.adminSetupSuccess: (context) => AdminSetupSuccessPage(),
      },
      home: const WelcomePage(),
    );
  }
}
