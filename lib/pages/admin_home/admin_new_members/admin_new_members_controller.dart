// lib/pages/admin_home/admin_new_members/admin_new_members_controller.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';
import '../../../services/trainee_service.dart';
import '../../../services/user_service.dart';
import '../admin_home_controller.dart';

class AdminNewMembersController extends GetxController {
  final TraineeService _traineeService = Get.find();
  final UserService _userService = Get.find();

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final RxList<User> pendingMembers = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPendingMembers();
  }

  Future<void> loadPendingMembers() async {
    isLoading.value = true;

    final response = await _traineeService.fetchAll();

    if (response.success && response.data != null) {
      pendingMembers.assignAll(
        response.data!.where(
          (user) => user.status == UserStatus.pending && user.role == UserRole.trainee,
        ),
      );
      message.value = '';
    } else {
      message.value = 'No se pudo cargar las solicitudes';
    }

    isLoading.value = false;
  }

  void openMemberRequest(User member) {
    Get.toNamed('/admin-member-request', arguments: member);
  }

  Future<void> acceptMember(User member) async {
    final response = await _userService.updateUser(
      member.id,
      {'status': 'active'},
    );

    if (response.success) {
      pendingMembers.remove(member);
      if (Get.isRegistered<AdminHomeController>()) {
        Get.find<AdminHomeController>().loadAdminHome();
      }
      Get.snackbar(
        'Solicitud aceptada',
        '${member.fullName} ha sido aceptado como miembro.',
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Error',
        'No se pudo aceptar la solicitud.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> rejectMember(User member) async {
    final response = await _userService.updateUser(
      member.id,
      {'status': 'rejected', 'organizationId': null},
    );

    if (response.success) {
      pendingMembers.remove(member);
      if (Get.isRegistered<AdminHomeController>()) {
        Get.find<AdminHomeController>().loadAdminHome();
      }
      Get.snackbar(
        'Solicitud rechazada',
        'La solicitud de ${member.fullName} fue rechazada.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      );
    } else {
      Get.snackbar(
        'Error',
        'No se pudo rechazar la solicitud.',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
