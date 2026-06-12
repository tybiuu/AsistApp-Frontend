import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custom_bottom_nav.dart';
import 'root_controller.dart';
import '../admin_analytics/admin_analytics_page.dart';
import '../admin_config/admin_config_page.dart';
import '../admin_home/admin_home_page.dart';
import '../admin_validate/admin_validate_page.dart';
import '../home/home_page.dart';

import '../attendance/attendance_page.dart';
import '../profile/profile_page.dart';
import '../analytics/analytics_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late final RootController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RootController());
  }

  @override
  Widget build(BuildContext context) {
    final practitionerViews = [
      const HomePage(),
      const AttendancePage(),
      const AnalyticsPage(),
      const ProfilePage(),
    ];

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
      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          isAdmin: controller.isAdmin,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
