import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../components/primary_button.dart';
import '../register_controller.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Obx(() => PrimaryButton(
          text: controller.isLoading() ? 'Creando...' : 'Crear cuenta',
          onPressed: (!controller.isFormValid || controller.isLoading()) ? null : controller.handleCreate,
        )),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¿Ya tienes cuenta? ',
              style: TextStyle(
                color: isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280),
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: controller.goToLogin,
              child: const Text(
                'Inicia sesión',
                style: TextStyle(
                  color: Color(0xfff97316),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
