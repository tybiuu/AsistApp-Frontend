// lib/pages/auth/register_page.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/input_field.dart';
import '../../components/primary_button.dart';
import 'register_controller.dart';
import 'role_select_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
    final controller = Get.put(RegisterController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final role = controller.role;
    final bool isPractitioner = role == RoleOption.practitioner;

    final Color roleColor = isPractitioner ? AppColors.chart1 : Theme.of(context).colorScheme.secondary;
    final Color roleBg = isDark 
        ? roleColor.withOpacity(0.2) 
        : (isPractitioner ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer);
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
                              color: roleColor.withOpacity(0.7),
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
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InputField(
                            label: 'Apellidos',
                            placeholder: 'Pérez Torres',
                            icon: const Icon(Icons.person, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const InputField(
                      label: 'Correo institucional',
                      placeholder: 'usuario@universidad.edu.pe',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icon(Icons.email, size: 18),
                    ),
                    const SizedBox(height: 16),
                    const InputField(
                      label: 'Celular',
                      placeholder: '987 654 321',
                      keyboardType: TextInputType.phone,
                      icon: Icon(Icons.phone, size: 18),
                      prefixText: '+51',
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
                        value: controller.selectedCarrera.value.isEmpty ? null : controller.selectedCarrera.value,
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
                                    '${controller.selectedCiclo.value}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xfff97316),
                                    ),
                                  ),
                                  Text(
                                    _getCicloLabel(controller.selectedCiclo.value),
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
                      obscureText: !controller.showPass.value,
                      icon: const Icon(Icons.lock, size: 18),
                      rightIcon: IconButton(
                        icon: Icon(controller.showPass.value ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: controller.toggleShowPass,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    )),
                    const SizedBox(height: 16),
                    Obx(() => InputField(
                      label: 'Confirmar contraseña',
                      placeholder: 'Repite tu contraseña',
                      obscureText: !controller.showConfirmPass.value,
                      icon: const Icon(Icons.lock, size: 18),
                      rightIcon: IconButton(
                        icon: Icon(controller.showConfirmPass.value ? Icons.visibility_off : Icons.visibility, size: 18),
                        onPressed: controller.toggleShowConfirmPass,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    )),

                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xff431407).withOpacity(0.1) : Theme.of(context).colorScheme.primaryContainer,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        isPractitioner
                            ? '📍 Tras registrarte, ingresarás el código de tu organización y propondrás tu horario semanal.'
                            : '🏢 Tras registrarte, crearás tu organización y obtendrás un código único para compartir con tu equipo.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary,
                          height: 1.4,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Obx(() => PrimaryButton(
                      text: controller.isLoading.value ? 'Creando...' : 'Crear cuenta',
                      onPressed: controller.isLoading.value ? null : controller.handleCreate,
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
