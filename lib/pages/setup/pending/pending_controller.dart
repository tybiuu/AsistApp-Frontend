// lib/pages/setup/pending/pending_controller.dart

import 'dart:async';

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/routes.dart';
import '../../../models/user.dart';
import '../../../services/session_service.dart';
import '../../../services/user_service.dart';

class PendingController extends GetxController {
  final UserService _userService = Get.find();

  late final String organizationName;
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    final args = (Get.arguments as Map<String, dynamic>?) ?? {};
    organizationName = args['organizationName'] as String?
        ?? SessionService.to.currentOrganization.value?.name
        ?? '';
    _startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) => _checkStatus());
  }

  Future<void> _checkStatus() async {
    final currentUser = SessionService.to.currentUser.value;
    if (currentUser == null) return;

    try {
      final user = await _userService.fetchById(currentUser.id);
      await SessionService.to.saveUser(user);

      if (user.status == UserStatus.active) {
        _pollingTimer?.cancel();
        Get.offAllNamed(AppRoutes.root);
      } else if (user.status == UserStatus.rejected) {
        _pollingTimer?.cancel();
        await SessionService.to.clearOrganization();
        Get.offAllNamed(AppRoutes.orgCode);
        Get.snackbar(
          'Solicitud rechazada',
          'Tu solicitud fue rechazada. Puedes intentar con otro código.',
          backgroundColor: AppColors.error,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 5),
        );
      }
    } catch (_) {}
  }
}
