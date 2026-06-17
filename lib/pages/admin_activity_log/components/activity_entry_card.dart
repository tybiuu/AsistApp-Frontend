import 'package:flutter/material.dart';

import 'package:asist_app/configs/theme.dart';
import '../admin_activity_log_controller.dart';

class ActivityEntryCard extends StatelessWidget {
  final ActivityEntry entry;

  const ActivityEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final _EntryStyle style = _styleFor(entry.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: style.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(style.icon, color: style.color, size: 20),
          ),
          const SizedBox(width: 12),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  style.label,
                  style: TextStyle(
                    color: style.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  entry.subject,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.datetime,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      entry.byRole.isNotEmpty
                          ? 'Por: ${entry.by} (${entry.byRole})'
                          : 'Por: ${entry.by}',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _EntryStyle _styleFor(String type) {
    switch (type) {
      case 'asistencia_confirmada':
        return _EntryStyle(
          label: 'Asistencia confirmada',
          icon: Icons.check_box_rounded,
          color: AppColors.success,
        );
      case 'asistencia_faltante_procesada':
        return _EntryStyle(
          label: 'Asistencia faltante procesada',
          icon: Icons.edit_note_rounded,
          color: AppColors.info,
        );
      case 'tardanza_registrada':
        return _EntryStyle(
          label: 'Tardanza registrada',
          icon: Icons.alarm_rounded,
          color: AppColors.chart1,
        );
      case 'inasistencia_marcada':
        return _EntryStyle(
          label: 'Inasistencia marcada',
          icon: Icons.close_rounded,
          color: AppColors.error,
        );
      case 'horario_aprobado':
        return _EntryStyle(
          label: 'Horario aprobado',
          icon: Icons.calendar_month_rounded,
          color: AppColors.success,
        );
      case 'cambio_de_horario_aprobado':
        return _EntryStyle(
          label: 'Cambio de horario aprobado',
          icon: Icons.edit_calendar_rounded,
          color: AppColors.info,
        );
      case 'miembro_aceptado':
        return _EntryStyle(
          label: 'Miembro aceptado',
          icon: Icons.person_add_rounded,
          color: AppColors.success,
        );
      case 'miembro_rechazado':
        return _EntryStyle(
          label: 'Miembro rechazado',
          icon: Icons.person_off_rounded,
          color: AppColors.error,
        );
      default:
        return _EntryStyle(
          label: type,
          icon: Icons.info_outline_rounded,
          color: AppColors.mutedForeground,
        );
    }
  }
}

class _EntryStyle {
  final String label;
  final IconData icon;
  final Color color;

  const _EntryStyle({
    required this.label,
    required this.icon,
    required this.color,
  });
}
