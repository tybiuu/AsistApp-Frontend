// lib/pages/auth/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/input_field.dart';
import '../../../components/primary_button.dart';
import '../../../configs/theme.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar equivalent
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: controller.goBack,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Inicia sesión',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputField(
                      label: 'Correo institucional',
                      placeholder: 'usuario@universidad.edu.pe',
                      keyboardType: TextInputType.emailAddress,
                      icon: const Icon(Icons.email, size: 18),
                      onChanged: controller.setEmail,
                    ),
                    const SizedBox(height: 16),
                    Obx(() => InputField(
                      label: 'Contraseña',
                      placeholder: '••••••••',
                      obscureText: !controller.showPass(),
                      icon: const Icon(Icons.lock, size: 18),
                      onChanged: controller.setPassword,
                      rightIcon: IconButton(
                        icon: Icon(controller.showPass() ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: controller.toggleShowPass,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    )),
                    const SizedBox(height: 40),
                    Obx(() => PrimaryButton(
                      text: controller.isLoading() ? 'Ingresando...' : 'Ingresar',
                      onPressed: controller.isLoading() ? null : controller.handleLogin,
                      fullWidth: true,
                    )),
                    
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'o',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Theme.of(context).colorScheme.outlineVariant)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿No tienes cuenta? ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: controller.goToRegister,
                          child: Text(
                            'Regístrate',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
