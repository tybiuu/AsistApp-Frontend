// lib/pages/admin_setup_success/admin_setup_success_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../configs/routes.dart';

class AdminSetupSuccessController extends GetxController {
  late final String organizationName;
  late final String organizationCode;

  @override
  void onInit() {
    super.onInit();

    final Map<String, dynamic> args =
        (Get.arguments as Map<String, dynamic>?) ?? {};
    organizationName = (args['organizationName'] as String?)?.trim() ?? '';
    organizationCode = (args['organizationCode'] as String?)?.trim() ?? '';

    if (organizationName.isEmpty || organizationCode.isEmpty) {
      Get.offNamed(AppRoutes.adminSetup);
    }
  }

  Future<void> copyCode() async {
    await Clipboard.setData(ClipboardData(text: organizationCode));
    Get.snackbar(
      'Codigo copiado',
      'El codigo de organizacion se copio al portapapeles.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void goHome() {
    Get.offAllNamed(AppRoutes.home);
  }
}
