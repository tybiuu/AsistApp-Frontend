// lib/pages/auth/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../configs/routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final RxBool showPass = false.obs;
  final RxString email = ''.obs;
  final RxString password = ''.obs;

  final RxBool isLoading = false.obs;

  void toggleShowPass() => showPass.toggle();

  void setEmail(String val) => email.value = val;
  void setPassword(String val) => password.value = val;

  Future<void> handleLogin() async {
    if (isLoading.value) return;
    isLoading.value = true;
    
    // Simulate delay
    await Future.delayed(const Duration(seconds: 1));
    
    isLoading.value = false;

    // Based on actual logic, it routes to home page after login.
    Get.offAllNamed(AppRoutes.home);
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.roleSelect);
  }

  void goBack() {
    Get.back();
  }
}
