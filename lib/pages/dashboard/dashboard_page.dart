import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custom_bottom_nav.dart';
import 'dashboard_controller.dart';
import '../admin_analytics/admin_analytics_page.dart';
import '../admin_config/admin_config_page.dart';
import '../admin_home/admin_home_page.dart';
import '../admin_validate/admin_validate_page.dart';
import '../home/home_page.dart';

import '../attendance/attendance_page.dart';
import '../report/report_page.dart';
import '../profile/profile_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    // Practitioner views
    final practitionerViews = [
      const HomePage(),
      const AttendancePage(),
      const ReportPage(),
      const ProfilePage(),
    ];

    // Admin views
    final adminViews = [
      const AdminHomePage(),
      const AdminValidatePage(),
      const AdminAnalyticsPage(),
      const AdminConfigPage(),
    ];

    return Scaffold(
      body: Obx(() {
        final views = controller.isAdmin ? adminViews : practitionerViews;
        return IndexedStack(
          index: controller.currentIndex.value,
          children: views,
        );
      }),
      bottomNavigationBar: Obx(() => CustomBottomNav(
        isAdmin: controller.isAdmin,
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTab,
      )),
    );
  }
}
