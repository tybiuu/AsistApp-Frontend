// lib/pages/welcome/welcome_controller.dart

import 'package:get/get.dart';

import '../../configs/routes.dart';

class WelcomeController extends GetxController {
  RxBool isLoading = false.obs;

  void goToRoleSelect() => Get.toNamed(AppRoutes.roleSelect);

  void goToLogin() => Get.toNamed(AppRoutes.login);
}
