// lib/pages/admin_home/admin_member_request/admin_member_request_controller.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../models/user.dart';
import '../admin_new_members/admin_new_members_controller.dart';

class AdminMemberRequestController extends GetxController {
  late final User member;

  @override
  void onInit() {
    super.onInit();
    member = Get.arguments as User;
  }

  Future<void> acceptMember() async {
    try {
      if (Get.isRegistered<AdminNewMembersController>()) {
        await Get.find<AdminNewMembersController>().acceptMember(member);
      }
    } catch (e) {
      debugPrint('[AdminMemberRequestController] Error al aceptar: $e');
    } finally {
      Get.back();
    }
  }

  Future<void> rejectMember() async {
    try {
      if (Get.isRegistered<AdminNewMembersController>()) {
        await Get.find<AdminNewMembersController>().rejectMember(member);
      }
    } catch (e) {
      debugPrint('[AdminMemberRequestController] Error al rechazar: $e');
    } finally {
      Get.back();
    }
  }
}
