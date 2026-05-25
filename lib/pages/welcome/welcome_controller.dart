// lib/pages/welcome/welcome_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../configs/routes.dart';
class WelcomeController extends GetxController {

  BuildContext? context;

  RxBool isLoading = false.obs;

  Future<void> goToRoleSelect(BuildContext context) async {
    isLoading.value = true;

    // Simulate some loading if needed, or just remove
    isLoading.value = false;

    if (!context.mounted) return;

    Get.toNamed(AppRoutes.roleSelect);
  }

  Future<void> goToLogin(BuildContext context) async {
    isLoading.value = true;

    isLoading.value = false;

    if (!context.mounted) return;

    Get.toNamed(AppRoutes.login);
  }

}
