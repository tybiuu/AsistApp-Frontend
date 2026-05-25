// lib/pages/auth/register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/routes.dart';
import '../../setup/role_select/role_select_controller.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final RxBool showPass = false.obs;
  final RxBool showConfirmPass = false.obs;

  final RxInt selectedCiclo = 5.obs;
  final RxString selectedCarrera = ''.obs;

  final RxBool isLoading = false.obs;

  RoleOption get role {
    try {
      final roleSelectCtrl = Get.find<RoleSelectController>();
      return roleSelectCtrl.selectedRole.value ?? RoleOption.practitioner;
    } catch (_) {
      return RoleOption.practitioner;
    }
  }

  final nombresCtrl = TextEditingController();
  final apellidosCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  final celularCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  @override
  void onClose() {
    nombresCtrl.dispose();
    apellidosCtrl.dispose();
    correoCtrl.dispose();
    celularCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }

  final RxString nombres = ''.obs;
  final RxString apellidos = ''.obs;
  final RxString correo = ''.obs;
  final RxString celular = ''.obs;
  final RxString password = ''.obs;
  final RxString confirmPassword = ''.obs;

  bool get isFormValid {
    // Read all reactive variables first so GetX tracks them properly
    final n = nombres().trim();
    final a = apellidos().trim();
    final c = correo().trim();
    final cel = celular().trim();
    final p = password();
    final carr = selectedCarrera();

    if (n.isEmpty) return false;
    if (a.isEmpty) return false;
    if (c.isEmpty || !GetUtils.isEmail(c)) return false;
    if (cel.isEmpty || cel.length < 9) return false;
    if (p.isEmpty || p.length < 8) return false;
    // Removed strict password match constraint here to handle it in handleCreate
    
    if (role == RoleOption.practitioner) {
      if (carr.isEmpty) return false;
    }
    return true;
  }

  void toggleShowPass() => showPass.toggle();
  void toggleShowConfirmPass() => showConfirmPass.toggle();

  void decreaseCiclo() {
    if (selectedCiclo.value > 5) {
      selectedCiclo.value--;
    }
  }

  void increaseCiclo() {
    if (selectedCiclo.value < 10) {
      selectedCiclo.value++;
    }
  }

  void setCarrera(String carrera) {
    selectedCarrera.value = carrera;
  }

  void handleCreate() async {
    if (!isFormValid) return;

    if (password() != confirmPassword()) {
      Get.snackbar(
        'Contraseñas no coinciden',
        'Por favor, asegúrate de que ambas contraseñas sean idénticas.',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (isLoading.value) return;
    isLoading.value = true;
    
    // Form values log
    debugPrint('--- Registro Nuevo ---');
    debugPrint('Rol: ${role.toString()}');
    debugPrint('Nombres: ${nombres()}');
    debugPrint('Apellidos: ${apellidos()}');
    debugPrint('Correo: ${correo()}');
    debugPrint('Celular: ${celular()}');
    if (role == RoleOption.practitioner) {
      debugPrint('Carrera: ${selectedCarrera()}');
      debugPrint('Ciclo: ${selectedCiclo()}');
    }
    debugPrint('Password: ${password()}');
    debugPrint('----------------------');

    // Simulate delay
    await Future.delayed(const Duration(seconds: 1));
    
    isLoading.value = false;

    if (role == RoleOption.admin) {
      Get.toNamed('/admin-setup');
    } else {
      Get.toNamed('/org-code');
    }
  }

  void goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  void goBack() {
    Get.back();
  }
}
