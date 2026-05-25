// lib/pages/admin_dashboard/admin_dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/custom_bottom_nav.dart';
import '../admin_analytics/admin_analytics_page.dart';
import '../admin_config/admin_config_page.dart';
import '../admin_home/admin_home_page.dart';
import '../admin_validate/admin_validate_page.dart';
import 'admin_dashboard_controller.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminDashboardController controller =
        Get.put(AdminDashboardController());

    final views = [
      const AdminHomePage(),
      const AdminValidatePage(),
      const AdminAnalyticsPage(),
      const AdminConfigPage(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: views,
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          isAdmin: true,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
