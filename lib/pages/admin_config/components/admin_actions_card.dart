// lib/pages/admin_config/components/admin_actions_card.dart

import 'package:flutter/material.dart';

import '../admin_config_controller.dart';

class AdminActionsCard extends StatelessWidget {
  final AdminConfigController controller;

  const AdminActionsCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _ActionTile(
            icon: Icons.monitor_heart_outlined,
            label: 'Registro de actividad',
            color: colors.primary,
            showChevron: true,
            onTap: controller.openActivityLog,
          ),
          Divider(height: 1, color: colors.outlineVariant),
          _ActionTile(
            icon: Icons.logout_rounded,
            label: 'Cerrar sesión',
            color: colors.error,
            onTap: controller.logout,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool showChevron;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.showChevron = false,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: showChevron ? colors.onSurface : color,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (showChevron)
                Icon(
                  Icons.chevron_right_rounded,
                  color: colors.onSurfaceVariant,
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
