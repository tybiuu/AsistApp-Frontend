// lib/pages/admin_home/admin_home_controller.dart

import 'package:get/get.dart';

import '../../models/admin_home.dart';
import '../../models/user.dart';
import '../../services/admin_home_service.dart';

class AdminHomeController extends GetxController {
  final AdminHomeService _adminHomeService = AdminHomeService();

  final RxBool isLoading = false.obs;
  final RxString message = ''.obs;
  final Rxn<AdminHomeData> adminHomeData = Rxn<AdminHomeData>();

  String get currentDateLabel {
    final DateTime now = DateTime.now();
    const List<String> weekdays = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    const List<String> months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];

    final String weekday = weekdays[now.weekday - 1];
    final String capitalizedWeekday =
        '${weekday[0].toUpperCase()}${weekday.substring(1)}';

    return '$capitalizedWeekday ${now.day} de ${months[now.month - 1]}';
  }

  @override
  void onInit() {
    super.onInit();
    loadAdminHome();
  }

  Future<void> loadAdminHome() async {
    isLoading.value = true;

    final response = await _adminHomeService.fetchHomeData();
    if (response.success && response.data != null) {
      adminHomeData.value = response.data;
      message.value = '';
    } else {
      message.value = response.message;
    }

    isLoading.value = false;
  }

  void goToPendingRequests() {}

  void openRequest(AdminRequestSummary request) {}

  void openMember(User member) {}
}
