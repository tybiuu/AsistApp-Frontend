// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import './configs/routes.dart';
import './configs/theme.dart';
import './services/session_service.dart';
import 'pages/admin_analytics/admin_analytics_page.dart';
import 'pages/admin_config/admin_config_page.dart';
import 'pages/admin_home/admin_home_page.dart';
import 'pages/admin_home/admin_member_detail/admin_member_detail_page.dart';
import 'pages/admin_home/admin_member_request/admin_member_request_page.dart';
import 'pages/admin_home/admin_new_members/admin_new_members_page.dart';
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

Future<void> main() async {
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize SessionService and restore any saved session from prefs.
  await Get.putAsync<SessionService>(() => SessionService().init());

  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme baseTextTheme = Typography.material2021().englishLike;
    final MaterialTheme materialTheme = MaterialTheme(baseTextTheme);

    final String initialRoute = SessionService.to.isLoggedIn
        ? AppRoutes.home
        : AppRoutes.welcome;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AsistApp',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      initialRoute: initialRoute,
      routes: {
        AppRoutes.welcome: (context) => const WelcomePage(),
        AppRoutes.roleSelect: (context) => const RoleSelectPage(),
        AppRoutes.register: (context) => const RegisterPage(),
        AppRoutes.orgCode: (context) => const OrgCodePage(),
        AppRoutes.pending: (context) => const PendingPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const DashboardPage(),
        AppRoutes.adminHome: (context) => const AdminHomePage(),
        AppRoutes.adminValidate: (context) => const AdminValidatePage(),
        AppRoutes.adminAnalytics: (context) => const AdminAnalyticsPage(),
        AppRoutes.adminConfig: (context) => const AdminConfigPage(),
        AppRoutes.adminSetup: (context) => AdminSetupPage(),
        AppRoutes.adminSetupSuccess: (context) => AdminSetupSuccessPage(),
        AppRoutes.adminNewMembers: (context) => const AdminNewMembersPage(),
        AppRoutes.adminMemberRequest: (context) =>
            const AdminMemberRequestPage(),
        AppRoutes.adminMemberDetail: (context) =>
            const AdminMemberDetailPage(),
      },
    );
  }
}
