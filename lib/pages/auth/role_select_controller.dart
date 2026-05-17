// lib/pages/auth/role_select_controller.dart

import 'package:get/get.dart';
import '../../configs/routes.dart';

enum RoleOption { practitioner, validator, admin }

class RoleSelectController extends GetxController {
  final Rx<RoleOption?> selectedRole = Rx<RoleOption?>(null);

  void selectRole(RoleOption role) {
    selectedRole.value = role;
  }

  void handleContinue() {
    if (selectedRole.value == null) return;
    
    // TODO: Save role in a global state if needed
    // setRegisterRole(selectedRole.value);
    
    Get.toNamed(AppRoutes.register); // Navigation as per React code
  }
  
  void goBack() {
    Get.back();
  }
}
