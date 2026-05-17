// lib/pages/auth/role_select_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/primary_button.dart';
import '../../configs/theme.dart';
import 'role_select_controller.dart';

class RoleDef {
  final RoleOption id;
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final String tag;
  final Color iconColor;
  final Color iconBgLight;
  final Color iconBgDark;
  final Color selectedBorder;
  final Color selectedBgLight;
  final Color selectedBgDark;
  final Color tagColorLight;
  final Color tagColorDark;
  final String hint;

  const RoleDef({
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tag,
    required this.iconColor,
    required this.iconBgLight,
    required this.iconBgDark,
    required this.selectedBorder,
    required this.selectedBgLight,
    required this.selectedBgDark,
    required this.tagColorLight,
    required this.tagColorDark,
    required this.hint,
  });
}

class RoleSelectPage extends StatelessWidget {
  const RoleSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoleSelectController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final List<RoleDef> roles = [
      RoleDef(
        id: RoleOption.practitioner,
        icon: Icons.school_rounded,
        title: 'Soy practicante',
        subtitle: 'Estudiante universitario',
        description:
            'Marca tu asistencia, propón tu horario semanal y genera reportes de tus prácticas.',
        tag: 'Practicante',
        iconColor: const Color(0xfff97316),
        iconBgLight: const Color(0xfffff7ed),
        iconBgDark: const Color(0xff431407).withOpacity(0.3),
        selectedBorder: const Color(0xfff97316),
        selectedBgLight: const Color(0xfffff7ed),
        selectedBgDark: const Color(0xff431407).withOpacity(0.2),
        tagColorLight: const Color(0xffea580c),
        tagColorDark: const Color(0xfffb923c),
        hint: '📍 Tras registrarte, ingresarás el código de tu organización y propondrás tu horario semanal.',
      ),
      RoleDef(
        id: RoleOption.validator,
        icon: Icons.science_rounded,
        title: 'Soy jefe de área / validador',
        subtitle: 'Profesional del laboratorio',
        description:
            'Valida asistencias, aprueba horarios y supervisa al equipo. Te unes con un código de organización.',
        tag: 'Validador',
        iconColor: const Color(0xff3b82f6),
        iconBgLight: const Color(0xffeff6ff),
        iconBgDark: const Color(0xff1e3a8a).withOpacity(0.3),
        selectedBorder: const Color(0xff3b82f6),
        selectedBgLight: const Color(0xffeff6ff),
        selectedBgDark: const Color(0xff1e3a8a).withOpacity(0.2),
        tagColorLight: const Color(0xff2563eb),
        tagColorDark: const Color(0xff60a5fa),
        hint: '🔑 Tras registrarte, ingresarás el código de tu organización. El administrador te asignará como validador.',
      ),
      RoleDef(
        id: RoleOption.admin,
        icon: Icons.shield_rounded,
        title: 'Soy administrador',
        subtitle: 'Profesional del laboratorio',
        description:
            'Crea y administra la organización, gestiona miembros y accede a todas las funciones.',
        tag: 'Administrador',
        iconColor: const Color(0xff475569),
        iconBgLight: const Color(0xfff1f5f9),
        iconBgDark: const Color(0xff1e293b).withOpacity(0.5),
        selectedBorder: const Color(0xff475569),
        selectedBgLight: const Color(0xfff8fafc),
        selectedBgDark: const Color(0xff1e293b).withOpacity(0.3),
        tagColorLight: const Color(0xff334155),
        tagColorDark: const Color(0xffe2e8f0),
        hint: '🏢 Tras registrarte, crearás tu organización y obtendrás un código único para compartir con tu equipo.',
      ),
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff0f1117) : const Color(0xffF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: controller.goBack,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 18, color: Color(0xfff97316)),
                        SizedBox(width: 6),
                        Text(
                          'Volver',
                          style: TextStyle(
                            color: Color(0xfff97316),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : const Color(0xff111827),
                        height: 1.2,
                      ),
                      children: const [
                        TextSpan(text: '¿Cómo vas a usar '),
                        TextSpan(
                          text: 'AsistApp?',
                          style: TextStyle(color: Color(0xfff97316)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Elige tu rol para ver el formulario de registro correcto',
                    style: TextStyle(
                      color: isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Cards Scrollable
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: roles.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return Obx(() {
                    final bool isSelected = controller.selectedRole.value == role.id;
                    return GestureDetector(
                      onTap: () => controller.selectRole(role.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? role.selectedBgDark : role.selectedBgLight)
                              : (isDark ? const Color(0xff1A1D27) : Colors.white),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected
                                ? role.selectedBorder
                                : (isDark ? const Color(0xff2D3042) : const Color(0xffe5e7eb)),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Icon Bubble
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xfff97316)
                                    : (isDark ? role.iconBgDark : role.iconBgLight),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                role.icon,
                                size: 26,
                                color: isSelected ? Colors.white : role.iconColor,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Text Content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    role.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isSelected
                                          ? (isDark ? Colors.white : const Color(0xff111827))
                                          : (isDark ? const Color(0xfff3f4f6) : const Color(0xff374151)),
                                    ),
                                  ),
                                  Text(
                                    role.subtitle,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? (isDark ? role.tagColorDark : role.tagColorLight)
                                          : (isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af)),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    role.description,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af),
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Radio indicator
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? const Color(0xfff97316) : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xfff97316)
                                      : (isDark ? const Color(0xff3D4052) : const Color(0xffd1d5db)),
                                  width: 2,
                                ),
                              ),
                              child: isSelected
                                  ? Center(
                                      child: Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            // Hint and Button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Column(
                children: [
                  Obx(() {
                    if (controller.selectedRole.value == null) return const SizedBox.shrink();
                    final selectedRoleDef = roles.firstWhere((r) => r.id == controller.selectedRole.value);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xff431407).withOpacity(0.1) : const Color(0xfffff7ed),
                        border: Border.all(
                          color: isDark ? const Color(0xff431407).withOpacity(0.3) : const Color(0xffffedd5),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        selectedRoleDef.hint,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? const Color(0xfffb923c) : const Color(0xffea580c),
                          height: 1.4,
                        ),
                      ),
                    );
                  }),
                  Obx(() => PrimaryButton(
                        onPressed: controller.selectedRole.value != null ? controller.handleContinue : null,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Continuar'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
