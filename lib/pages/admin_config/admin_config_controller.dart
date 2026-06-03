// lib/pages/admin_config/admin_config_controller.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../configs/routes.dart';
import '../../models/organization.dart';
import '../../models/user.dart';
import '../../services/organization_service.dart';
import '../../services/session_service.dart';

class AdminConfigController extends GetxController {
  final OrganizationService _organizationService = OrganizationService();
  final ImagePicker _imagePicker = ImagePicker();

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final Rxn<Organization> organization = Rxn<Organization>();
  final RxBool editingOrganization = false.obs;
  final RxBool editingProfile = false.obs;
  final RxInt tardinessLimit = 10.obs;
  final Rx<Uint8List?> organizationPhotoBytes = Rx<Uint8List?>(null);
  final Rx<Uint8List?> savedOrganizationPhotoBytes = Rx<Uint8List?>(null);

  final TextEditingController organizationNameController =
      TextEditingController();
  final TextEditingController organizationDescriptionController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  User? get admin => SessionService.to.currentUser.value;

  @override
  void onInit() {
    super.onInit();
    loadConfig();
  }

  Future<void> loadConfig() async {
    isLoading.value = true;

    final response = await _organizationService.fetchCurrent();
    if (response.success && response.data != null) {
      organization.value = response.data;
      _syncOrganizationFields(response.data!);
      message.value = '';
    } else {
      message.value = response.message;
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    organizationNameController.dispose();
    organizationDescriptionController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> copyOrganizationCode() async {
    final String code = organization.value?.code ?? '';
    if (code.isEmpty) return;

    await Clipboard.setData(ClipboardData(text: code));
    Get.snackbar(
      'Código copiado',
      'El código de organización se copió al portapapeles.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }

  void editOrganization() {
    final Organization? current = organization.value;
    if (current == null) return;

    _syncOrganizationFields(current);
    editingOrganization.value = true;
  }

  void cancelOrganizationEdit() {
    final Organization? current = organization.value;
    if (current != null) {
      _syncOrganizationFields(current);
    }
    editingOrganization.value = false;
  }

  Future<void> selectOrganizationPhoto() async {
    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (photo == null) return;
    organizationPhotoBytes.value = await photo.readAsBytes();
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

  void saveOrganization() {
    final Organization? current = organization.value;
    if (current == null) return;

    savedOrganizationPhotoBytes.value =
        organizationPhotoBytes.value ?? savedOrganizationPhotoBytes.value;
    organization.value = Organization(
      id: current.id,
      name: organizationNameController.text.trim(),
      code: current.code,
      photoUrl: current.photoUrl,
      description: organizationDescriptionController.text.trim(),
      lateTimeLimit: tardinessLimit.value,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );
    editingOrganization.value = false;
  }

  void editProfile() {
    final User? current = admin;
    if (current == null) return;

    _syncProfileFields(current);
    editingProfile.value = true;
  }

  void cancelProfileEdit() {
    final User? current = admin;
    if (current != null) {
      _syncProfileFields(current);
    }
    editingProfile.value = false;
  }

  Future<void> saveProfile() async {
    final User? current = admin;
    if (current == null) return;

    final User updated = User(
      id: current.id,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      institutionalEmail: current.institutionalEmail,
      phoneNumber: phoneController.text.trim(),
      career: current.career,
      cycle: current.cycle,
      organizationId: current.organizationId,
      role: current.role,
      status: current.status,
      deviceToken: current.deviceToken,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );

    await SessionService.to.updateUser(updated);
    editingProfile.value = false;
  }

  void openActivityLog() => Get.toNamed(AppRoutes.adminActivityLog);

  Future<void> logout() async {
    await SessionService.to.logout();
    Get.offAllNamed(AppRoutes.welcome);
  }

  void _syncOrganizationFields(Organization current) {
    organizationNameController.text = current.name;
    organizationDescriptionController.text = current.description ?? '';
    tardinessLimit.value = current.lateTimeLimit;
    organizationPhotoBytes.value = null;
  }

  void _syncProfileFields(User current) {
    firstNameController.text = current.firstName;
    lastNameController.text = current.lastName;
    phoneController.text = current.phoneNumber;
  }
}
