// lib/pages/admin_setup/admin_setup_controller.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../configs/routes.dart';
import '../../services/organization_service.dart';
import '../../services/session_service.dart';

class AdminSetupController extends GetxController {
  final OrganizationService _organizationService = Get.find();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  final RxInt tardinessLimit = 10.obs;
  final Rx<Uint8List?> laboratoryPhotoBytes = Rx<Uint8List?>(null);
  final RxBool isNameValid = false.obs;
  final RxBool isLoading = false.obs;

  bool get canCreate => isNameValid.value && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_validateRequiredFields);
  }

  @override
  void onClose() {
    nameController
      ..removeListener(_validateRequiredFields)
      ..dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _validateRequiredFields() {
    isNameValid.value = nameController.text.trim().isNotEmpty;
  }

  void decreaseTardinessLimit() {
    if (tardinessLimit.value > 0) {
      tardinessLimit.value -= 5;
    }
  }

  void increaseTardinessLimit() {
    if (tardinessLimit.value < 60) {
      tardinessLimit.value += 5;
    }
  }

  Future<void> selectPhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (photo == null) return;
    laboratoryPhotoBytes.value = await photo.readAsBytes();
  }

  Future<void> createOrganization() async {
    if (!canCreate) return;

    final String organizationName = nameController.text.trim().toUpperCase();
    final String? description = descriptionController.text.trim().isEmpty
        ? null
        : descriptionController.text.trim();

    isLoading.value = true;
    try {
      final org = await _organizationService.createOrganization(
        name: organizationName,
        lateTimeLimit: tardinessLimit.value,
        description: description,
      );
      await SessionService.to.saveOrganization(org);
      Get.offNamed(
        AppRoutes.adminSetupSuccess,
        arguments: {
          'organizationName': org.name,
          'organizationCode': org.code,
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
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
