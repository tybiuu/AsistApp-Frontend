import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/input_field.dart';
import '../register_controller.dart';

class PasswordFields extends StatelessWidget {
  const PasswordFields({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    return Column(
      children: [
        const SizedBox(height: 16),
        Obx(() => InputField(
          label: 'Contraseña',
          placeholder: 'Mínimo 8 caracteres',
          obscureText: !controller.showPass(),
          icon: const Icon(Icons.lock, size: 18),
          controller: controller.passwordCtrl,
          onChanged: (val) => controller.password.value = val,
          rightIcon: IconButton(
            icon: Icon(controller.showPass() ? Icons.visibility_off : Icons.visibility, size: 18),
            onPressed: controller.toggleShowPass,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        )),
        const SizedBox(height: 16),
        Obx(() => InputField(
          label: 'Confirmar contraseña',
          placeholder: 'Repite tu contraseña',
          obscureText: !controller.showConfirmPass(),
          icon: const Icon(Icons.lock, size: 18),
          controller: controller.confirmPasswordCtrl,
          onChanged: (val) => controller.confirmPassword.value = val,
          rightIcon: IconButton(
            icon: Icon(controller.showConfirmPass() ? Icons.visibility_off : Icons.visibility, size: 18),
            onPressed: controller.toggleShowConfirmPass,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        )),
      ],
    );
  }
}
