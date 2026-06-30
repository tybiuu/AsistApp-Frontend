// lib/pages/auth/login/login_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/routes.dart';
import '../../../models/user.dart';
import '../../../services/organization_service.dart';
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

      if (user.organizationId != null && user.organizationId!.isNotEmpty) {
        try {
          final org = await Get.find<OrganizationService>().fetchById(user.organizationId!);
          await SessionService.to.saveOrganization(org);
        } catch (_) {}
      }

      final String roleName = user.role == UserRole.admin ? 'Administrador' : 'Practicante';
      Get.snackbar(
        'Bienvenido',
        'Sesión iniciada como $roleName',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );

      _navigateAfterLogin(user);
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

  void _navigateAfterLogin(User user) {
    if (user.role == UserRole.admin) {
      if (user.organizationId != null && user.organizationId!.isNotEmpty) {
        Get.offAllNamed(AppRoutes.root);
      } else {
        Get.offAllNamed(AppRoutes.adminSetup);
      }
      return;
    }

    // Trainee
    if (user.status == UserStatus.active) {
      Get.offAllNamed(AppRoutes.root);
    } else if (user.organizationId != null && user.organizationId!.isNotEmpty) {
      Get.offAllNamed(
        AppRoutes.pending,
        arguments: {
          'organizationName': SessionService.to.currentOrganization.value?.name ?? '',
        },
      );
    } else {
      Get.offAllNamed(AppRoutes.orgCode);
    }
  }

  void goToRegister() {
    if (Get.previousRoute == AppRoutes.login) {
      Get.back();
    } else {
      Get.toNamed(AppRoutes.roleSelect);
    }
  }

  void goBack() => Get.back();
}
