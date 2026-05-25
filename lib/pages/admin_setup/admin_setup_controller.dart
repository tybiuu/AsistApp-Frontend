// lib/pages/admin_setup/admin_setup_controller.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../configs/routes.dart';

class AdminSetupController extends GetxController {
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

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.home);
  }

  void goBack() {
    Get.back();
  }
}
