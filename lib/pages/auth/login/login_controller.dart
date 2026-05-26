// lib/pages/auth/login/login_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/routes.dart';
import '../../../models/user.dart';
import '../../../services/session_service.dart';

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

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    final mail = email.value.trim();
    final pass = password.value;

    if (mail == 'admin@ulima.edu.pe' && pass == 'admin123') {
      // ── Mock admin user ──────────────────────────────────────────────────
      final adminUser = User(
        id: 'usr-admin-001',
        firstName: 'Carlos',
        lastName: 'Ramírez',
        institutionalEmail: mail,
        phoneNumber: '999000001',
        career: null,
        cycle: null,
        organizationId: 'ITLAB',
        role: UserRole.admin,
        status: UserStatus.active,
        createdAt: DateTime(2023, 6, 1),
        updatedAt: DateTime.now(),
      );

      await SessionService.to.saveUser(adminUser);

      Get.snackbar(
        'Bienvenido',
        'Sesión iniciada como Administrador',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(AppRoutes.home);

    } else if (mail == 'practicante@ulima.edu.pe' && pass == 'practicante123') {
      // ── Mock trainee user ────────────────────────────────────────────────
      final traineeUser = User(
        id: 'usr-trainee-001',
        firstName: 'Jose',
        lastName: 'Torres',
        institutionalEmail: mail,
        phoneNumber: '987654321',
        career: 'Ingeniería de Sistemas',
        cycle: 7,
        organizationId: 'org-001',
        role: UserRole.trainee,
        status: UserStatus.active,
        createdAt: DateTime(2024, 1, 15),
        updatedAt: DateTime.now(),
      );

      await SessionService.to.saveUser(traineeUser);

      Get.snackbar(
        'Bienvenido',
        'Sesión iniciada como Practicante',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(AppRoutes.home);

    } else {
      Get.snackbar(
        'Error',
        'Credenciales incorrectas. Intenta con admin@ulima.edu.pe o practicante@ulima.edu.pe',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goToRegister() => Get.toNamed(AppRoutes.roleSelect);
  void goBack() => Get.back();
}
