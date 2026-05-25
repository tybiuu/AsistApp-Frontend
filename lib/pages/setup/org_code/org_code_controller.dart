// lib/pages/auth/org_code_controller.dart
import 'package:get/get.dart';

import '../../../configs/routes.dart';

class OrgCodeController extends GetxController {
  final RxString code = ''.obs;

  void setCode(String val) {
    code.value = val.toUpperCase();
  }

  void submitCode() {
    if (code.value.length >= 8) {
      Get.toNamed(AppRoutes.pending);
    }
  }

  void goBack() {
    Get.back();
  }
}
