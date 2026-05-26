import 'package:flutter/material.dart';
import '../../../../../configs/theme.dart';
import '../../../setup/role_select/role_select_controller.dart';

class RoleBadge extends StatelessWidget {
  final RoleOption role;
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isPractitioner = role == RoleOption.practitioner;

    final Color roleColor = isPractitioner ? AppColors.chart1 : Theme.of(context).colorScheme.onSurface;
    final Color roleBg = isDark 
        ? roleColor.withValues(alpha: 0.2) 
        : Theme.of(context).colorScheme.primaryContainer;
    final IconData roleIcon = isPractitioner ? Icons.school_rounded : Icons.shield_rounded;
    final String roleTitle = isPractitioner ? 'Practicante' : 'Administrador';
    final String roleSubtitle = isPractitioner ? 'Estudiante universitario' : 'Profesional del laboratorio';

    return Align(
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
    );
  }
}
