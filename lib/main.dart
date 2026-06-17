// lib/main.dart

import 'package:asist_app/pages/admin_schedule_validation/admin_schedule_validation_detail_page.dart';
import 'package:asist_app/pages/admin_schedule_validation/admin_schedule_validation_page.dart';
import 'package:asist_app/pages/schedule_change/schedule_change_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import './configs/routes.dart';
import './configs/theme.dart';
import './services/attendance_record_service.dart';
import './services/attendance_request_service.dart';
import './services/organization_service.dart';
import './services/schedule_change_request_service.dart';
import './services/schedule_service.dart';
import './services/session_service.dart';
import './services/trainee_service.dart';
import './services/user_service.dart';
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
import 'pages/home/home_page.dart';
import 'pages/setup/org_code/org_code_page.dart';
import 'pages/setup/pending/pending_page.dart';
import 'pages/auth/register/register_page.dart';
import 'pages/setup/role_select/role_select_page.dart';
import './pages/root/root_page.dart';
import './pages/welcome/welcome_page.dart';
import 'pages/pdf_report/pdf_report_page.dart';
import 'pages/admin_activity_log/admin_activity_log_page.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
        ? AppRoutes.root
        : AppRoutes.welcome;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AsistApp',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      initialBinding: BindingsBuilder(() {
        Get.lazyPut(() => UserService(), fenix: true);
        Get.lazyPut(() => OrganizationService(), fenix: true);
        Get.lazyPut(() => TraineeService(), fenix: true);
        Get.lazyPut(() => ScheduleService(), fenix: true);
        Get.lazyPut(() => ScheduleChangeRequestService(), fenix: true);
        Get.lazyPut(() => AttendanceRecordService(), fenix: true);
        Get.lazyPut(() => AttendanceRequestService(), fenix: true);
      }),
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: AppRoutes.welcome, page: () => const WelcomePage()),
        GetPage(name: AppRoutes.roleSelect, page: () => const RoleSelectPage()),
        GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
        GetPage(name: AppRoutes.orgCode, page: () => const OrgCodePage()),
        GetPage(name: AppRoutes.pending, page: () => const PendingPage()),
        GetPage(name: AppRoutes.login, page: () => const LoginPage()),
        GetPage(name: AppRoutes.root, page: () => const RootPage()),
        GetPage(name: AppRoutes.home, page: () => const HomePage()),
        GetPage(name: AppRoutes.adminHome, page: () => const AdminHomePage()),
        GetPage(
          name: AppRoutes.adminValidate,
          page: () => const AdminValidatePage(),
        ),
        GetPage(
          name: AppRoutes.adminAnalytics,
          page: () => const AdminAnalyticsPage(),
        ),
        GetPage(
          name: AppRoutes.adminConfig,
          page: () => const AdminConfigPage(),
        ),
        GetPage(name: AppRoutes.adminSetup, page: () => const AdminSetupPage()),
        GetPage(
          name: AppRoutes.adminSetupSuccess,
          page: () => const AdminSetupSuccessPage(),
        ),
        GetPage(
          name: AppRoutes.adminNewMembers,
          page: () => const AdminNewMembersPage(),
        ),
        GetPage(
          name: AppRoutes.adminMemberRequest,
          page: () => const AdminMemberRequestPage(),
        ),
        GetPage(
          name: AppRoutes.adminMemberDetail,
          page: () => const AdminMemberDetailPage(),
        ),
        GetPage(
          name: AppRoutes.adminScheduleValidation,
          page: () => const AdminScheduleValidationPage(),
        ),
        GetPage(
          name: AppRoutes.adminScheduleValidationDetail,
          page: () => const AdminScheduleValidationDetailPage(),
        ),
        GetPage(
          name: AppRoutes.scheduleChange,
          page: () => const ScheduleChangePage(),
        ),
        GetPage(name: AppRoutes.pdfReport, page: () => const PdfReportPage()),
        GetPage(
          name: AppRoutes.adminActivityLog,
          page: () => const AdminActivityLogPage(),
        ),
      ],
    );
  }
}
