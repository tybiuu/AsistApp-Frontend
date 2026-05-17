// lib/pages/onboarding/onboarding_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../configs/routes.dart';
import '../../services/preferences_service.dart';

class OnboardingController extends GetxController {
  final PreferencesService preferencesService = PreferencesService();

  BuildContext? context;

  RxBool isLoading = false.obs;

  Future<void> goToRoleSelect(BuildContext context) async {
    isLoading.value = true;

    await preferencesService.setOnboardingSeen();

    isLoading.value = false;

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.roleSelect,
    );
  }

  Future<void> goToLogin(BuildContext context) async {
    isLoading.value = true;

    await preferencesService.setOnboardingSeen();

    isLoading.value = false;

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  Future<void> resetOnboarding() async {
    await preferencesService.clearOnboardingSeen();
  }
}