import 'package:flutter/material.dart';
import 'package:asist_app/configs/theme.dart';
import 'package:get/get.dart';
import '../../../../../components/primary_button.dart';
import '../register_controller.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegisterController>();
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
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: controller.goToLogin,
              child: const Text(
                'Inicia sesión',
                style: TextStyle(
                  color: AppColors.chart1,
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
