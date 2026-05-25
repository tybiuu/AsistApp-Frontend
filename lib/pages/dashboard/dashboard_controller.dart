import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;

  // Since we have simulated login, we can pass a mock role or retrieve it from a global service
  // For now we'll allow passing it as an argument when routing, or default to practitioner.
  bool get isAdmin {
    if (Get.arguments != null && Get.arguments is Map) {
      return Get.arguments['isAdmin'] ?? false;
    }
    return false; // Default to practitioner
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
