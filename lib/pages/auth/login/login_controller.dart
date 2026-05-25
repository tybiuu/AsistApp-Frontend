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

    final mail = email.value.trim();
    final pass = password.value;

    if (mail == 'admin@ulima.edu.pe' && pass == 'admin123') {
      Get.snackbar(
        'Bienvenido',
        'Sesión iniciada como Administrador',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(AppRoutes.home, arguments: {'isAdmin': true});
    } else if (mail == 'practicante@ulima.edu.pe' && pass == 'practicante123') {
      Get.snackbar(
        'Bienvenido',
        'Sesión iniciada como Practicante',
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed(AppRoutes.home, arguments: {'isAdmin': false});
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

  void goToRegister() {
    Get.toNamed(AppRoutes.roleSelect);
  }

  void goBack() {
    Get.back();
  }
}
