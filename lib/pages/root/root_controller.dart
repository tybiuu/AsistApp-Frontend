// lib/pages/root/root_controller.dart

import 'package:get/get.dart';

import '../../services/session_service.dart';

class RootController extends GetxController {
  final RxInt currentIndex = 0.obs;

  /// Derived from the persisted session — no route arguments needed.
  bool get isAdmin => SessionService.to.isAdmin;

  void changeTab(int index) {
    currentIndex.value = index;
  }
}
