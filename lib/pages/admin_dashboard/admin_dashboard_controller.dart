// lib/pages/admin_dashboard/admin_dashboard_controller.dart

import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
