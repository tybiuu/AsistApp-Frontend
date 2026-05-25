// lib/pages/auth/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../configs/routes.dart';
import 'role_select_controller.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final RxBool showPass = false.obs;
  final RxBool showConfirmPass = false.obs;

  final RxInt selectedCiclo = 5.obs;
  final RxString selectedCarrera = ''.obs;

  final RxBool isLoading = false.obs;

  RoleOption get role {
    try {
      final roleSelectCtrl = Get.find<RoleSelectController>();
      return roleSelectCtrl.selectedRole.value ?? RoleOption.practitioner;
    } catch (_) {
      return RoleOption.practitioner;
    }
  }

  void toggleShowPass() => showPass.toggle();
  void toggleShowConfirmPass() => showConfirmPass.toggle();

  void decreaseCiclo() {
    if (selectedCiclo.value > 5) {
      selectedCiclo.value--;
    }
  }

  void increaseCiclo() {
    if (selectedCiclo.value < 10) {
      selectedCiclo.value++;
    }
  }

  void setCarrera(String carrera) {
    selectedCarrera.value = carrera;
  }

  void handleCreate() async {
    if (isLoading.value) return;
    isLoading.value = true;
    
    // Simulate delay
    await Future.delayed(const Duration(seconds: 1));
    
    isLoading.value = false;

    if (role == RoleOption.admin) {
      Get.toNamed('/admin-setup');
    } else {
      Get.toNamed('/org-code');
    }
  }

  void goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  void goBack() {
    Get.back();
  }
}
