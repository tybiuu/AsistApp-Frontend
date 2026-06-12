// lib/pages/admin_home/admin_new_members/admin_new_members_controller.dart

import 'package:get/get.dart';

import '../../../models/user.dart';
import '../../../services/trainee_service.dart';

class AdminNewMembersController extends GetxController {
  final TraineeService _traineeService = Get.find();

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
        response.data!.where((user) => user.status == UserStatus.pending),
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

  void acceptMember(User member) {
    pendingMembers.remove(member);
    Get.snackbar(
      'Solicitud aceptada',
      '${member.fullName} ha sido aceptado como miembro.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  void rejectMember(User member) {
    pendingMembers.remove(member);
    Get.snackbar(
      'Solicitud rechazada',
      'La solicitud de ${member.fullName} fue rechazada.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }
}
