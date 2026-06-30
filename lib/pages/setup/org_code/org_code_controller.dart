// lib/pages/auth/org_code_controller.dart
import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/routes.dart';
import '../../../services/organization_service.dart';
import '../../../services/session_service.dart';
import '../../../services/user_service.dart';


class OrgCodeController extends GetxController {
  final OrganizationService _organizationService = Get.find();
  final UserService _userService = Get.find();

  final RxString code = ''.obs;
  final RxBool isLoading = false.obs;
  final TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    textController.addListener(_onTextChanged);
  }

  @override
  void onClose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.onClose();
  }

  void _onTextChanged() {
    final val = textController.text;
    final raw = val.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();

    final String formatted;
    if (raw.length > 5) {
      formatted = '${raw.substring(0, 5)}-${raw.substring(5)}';
    } else {
      formatted = raw;
    }

    if (formatted != val) {
      textController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    code.value = formatted;
  }

  Future<void> submitCode() async {
    if (code.value.length < 9 || isLoading.value) return;

    final currentUser = SessionService.to.currentUser.value;
    if (currentUser == null) return;

    isLoading.value = true;

    try {
      final org = await _organizationService.fetchByCode(code.value);
      await SessionService.to.saveOrganization(org);

      final response = await _userService.updateUser(
        currentUser.id,
        {'organizationId': org.id},
      );

      if (!response.success || response.data == null) {
        throw Exception(response.message);
      }

      await SessionService.to.updateUser(response.data!);

      Get.toNamed(
        AppRoutes.pending,
        arguments: {'organizationName': org.name},
      );
    } catch (e) {
      Get.snackbar(
        'Código inválido',
        'No encontramos ninguna organización con ese código.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goBack() {
    Get.back();
  }
}
