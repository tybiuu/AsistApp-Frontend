// lib/pages/admin_home/admin_member_request/admin_member_request_controller.dart

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
    if (Get.isRegistered<AdminNewMembersController>()) {
      await Get.find<AdminNewMembersController>().acceptMember(member);
    }
    Get.back();
  }

  Future<void> rejectMember() async {
    if (Get.isRegistered<AdminNewMembersController>()) {
      await Get.find<AdminNewMembersController>().rejectMember(member);
    }
    Get.back();
  }
}
