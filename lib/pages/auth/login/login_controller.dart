// lib/pages/auth/login/login_controller.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    try {
      final String response = await rootBundle.loadString('assets/jsons/mock_users.json');
      final List<dynamic> data = jsonDecode(response);
      
      Map<String, dynamic>? foundUserMap;

      for (var item in data) {
        if (item['institutional_email'] == mail && item['password'] == pass) {
          foundUserMap = item;
          break;
        }
      }

      if (foundUserMap != null) {
        final user = User.fromJson(foundUserMap);
        await SessionService.to.saveUser(user);

        String roleName = user.role == UserRole.admin ? 'Administrador' : 'Practicante';

        Get.snackbar(
          'Bienvenido',
          'Sesión iniciada como $roleName',
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error al cargar los datos de prueba.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goToRegister() {
    if (Get.previousRoute == AppRoutes.roleSelect || Get.previousRoute == AppRoutes.register) {
      Get.back();
    } else {
      Get.toNamed(AppRoutes.roleSelect);
    }
  }

  void goBack() => Get.back();
}
