// lib/pages/auth/register_page.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/input_field.dart';
import '../../../components/primary_button.dart';
import 'register_controller.dart';
import '../../setup/role_select/role_select_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
  }

  @override
  void dispose() {
    Get.delete<RegisterController>();
    super.dispose();
  }

  String _getCicloLabel(int n) {
    const suffixes = {
      1: 'er',
      2: 'do',
      3: 'er',
      4: 'to',
      5: 'to',
      6: 'to',
      7: 'mo',
      8: 'vo',
      9: 'no',
      10: 'mo'
    };
    return '$n${suffixes[n] ?? 'mo'} ciclo';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final role = controller.role;
    final bool isPractitioner = role == RoleOption.practitioner;

    final Color roleColor = isPractitioner ? AppColors.chart1 : Theme.of(context).colorScheme.onSurface;
    final Color roleBg = isDark 
        ? roleColor.withValues(alpha: 0.2) 
        : Theme.of(context).colorScheme.primaryContainer;
    final IconData roleIcon = isPractitioner ? Icons.school_rounded : Icons.shield_rounded;
    final String roleTitle = isPractitioner ? 'Practicante' : 'Administrador';
    final String roleSubtitle = isPractitioner ? 'Estudiante universitario' : 'Profesional del laboratorio';

    final List<String> carreras = [
      'Administración',
      'Comunicación',
      'Derecho',
      'Ingeniería Ambiental',
      'Ingeniería Industrial',
      'Ingeniería de Sistemas',
      'Negocios Internacionales',
      'Arquitectura',
      'Contabilidad y Finanzas',
      'Economía',
      'Ingeniería Civil',
      'Ingeniería Mecatrónica',
      'Marketing',
      'Psicología',
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
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
                    'Crea tu cuenta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: roleBg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(roleIcon, size: 16, color: roleColor),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            roleTitle,
                            style: TextStyle(
                              color: roleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            roleSubtitle,
                            style: TextStyle(
                              color: roleColor.withValues(alpha: 0.7),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InputField(
                            label: 'Nombres',
                            placeholder: 'Juan Carlos',
                            icon: const Icon(Icons.person, size: 18),
                            controller: controller.nombresCtrl,
                            onChanged: (val) => controller.nombres.value = val,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InputField(
                            label: 'Apellidos',
                            placeholder: 'Pérez Torres',
                            icon: const Icon(Icons.person, size: 18),
                            controller: controller.apellidosCtrl,
                            onChanged: (val) => controller.apellidos.value = val,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Correo institucional',
                      placeholder: 'usuario@universidad.edu.pe',
                      keyboardType: TextInputType.emailAddress,
                      icon: const Icon(Icons.email, size: 18),
                      controller: controller.correoCtrl,
                      onChanged: (val) => controller.correo.value = val,
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      label: 'Celular',
                      placeholder: '987 654 321',
                      keyboardType: TextInputType.phone,
                      icon: const Icon(Icons.phone, size: 18),
                      prefixText: '+51',
                      controller: controller.celularCtrl,
                      onChanged: (val) => controller.celular.value = val,
                    ),
                    
                    if (isPractitioner) ...[
                      const SizedBox(height: 16),
                      Text(
                        'Carrera',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Obx(() => DropdownButtonFormField<String>(
                        initialValue: controller.selectedCarrera().isEmpty ? null : controller.selectedCarrera(),
                        hint: Text(
                          'Selecciona tu carrera',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        items: carreras.map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c),
                        )).toList(),
                        onChanged: (val) {
                          if (val != null) controller.setCarrera(val);
                        },
                        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceContainer,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(height: 16),
                      
                      Text(
                        'Ciclo académico',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: controller.decreaseCiclo,
                              icon: const Icon(Icons.remove),
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                              ),
                            ),
                            Expanded(
                              child: Obx(() => Column(
                                children: [
                                  Text(
                                    '${controller.selectedCiclo()}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xfff97316),
                                    ),
                                  ),
                                  Text(
                                    _getCicloLabel(controller.selectedCiclo()),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            IconButton(
                              onPressed: controller.increaseCiclo,
                              icon: const Icon(Icons.add),
                              style: IconButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.surface,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

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

                    const SizedBox(height: 24),
                    
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
                    const SizedBox(height: 20),
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
