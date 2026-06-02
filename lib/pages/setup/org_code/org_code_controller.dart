// lib/pages/auth/org_code_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/routes.dart';
import '../../../services/organization_service.dart';

class OrgCodeController extends GetxController {
  final RxString code = ''.obs;
  final RxBool isLoading = false.obs;

  void setCode(String val) {
    code.value = val.toUpperCase();
  }

  Future<void> submitCode() async {
    if (code.value.length < 8 || isLoading.value) return;
    isLoading.value = true;

    final response = await OrganizationService().fetchCurrent();

    isLoading.value = false;

    if (response.success && response.data != null &&
        response.data!.code == code.value) {
      Get.toNamed(
        AppRoutes.pending,
        arguments: {'organizationName': response.data!.name},
      );
    } else {
      Get.snackbar(
        'Código inválido',
        'No encontramos ninguna organización con ese código.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goBack() {
    Get.back();
  }
}
