// lib/pages/auth/pending_controller.dart
import 'package:get/get.dart';

import '../../../configs/routes.dart';

class PendingController extends GetxController {
  
  void goToHome() {
    // Navigates to home if needed, or simply acts as a back button depending on requirements.
    Get.offAllNamed(AppRoutes.welcome);
  }
}
