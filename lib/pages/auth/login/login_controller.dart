// lib/pages/auth/login/login_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/routes.dart';
import '../../../models/user.dart';
import '../../../services/session_service.dart';
import '../../../services/user_service.dart';

class LoginController extends GetxController {
  final UserService _userService = Get.find();

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

    final mail = email.value.trim();
    final pass = password.value;

    final response = await _userService.login(mail, pass);

    isLoading.value = false;

    if (response.success && response.data != null) {
      final user = response.data!;
      await SessionService.to.saveUser(user);

      String roleName = user.role == UserRole.admin
          ? 'Administrador'
          : 'Practicante';

      Get.snackbar(
        'Bienvenido',
        'Sesión iniciada como $roleName',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(AppRoutes.root);
    } else {
      Get.snackbar(
        'Error',
        response.message,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goToRegister() {
    if (Get.previousRoute == AppRoutes.roleSelect ||
        Get.previousRoute == AppRoutes.register) {
      Get.back();
    } else {
      Get.toNamed(AppRoutes.roleSelect);
    }
  }

  void goBack() => Get.back();
}
