import 'package:flutter/material.dart';

import 'package:asist_app/configs/theme.dart';
import '../../../models/activity_log.dart';
import '../admin_activity_log_controller.dart';

class ActivityEntryCard extends StatelessWidget {
  final ActivityEntry entry;

  const ActivityEntryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final _EntryStyle style = _styleFor(entry.category);

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
                  entry.title.isNotEmpty ? entry.title : style.label,
                  style: TextStyle(
                    color: style.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (entry.subject.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    entry.subject,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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

  _EntryStyle _styleFor(LogCategory category) {
    switch (category) {
      case LogCategory.attendance:
        return _EntryStyle(
          label: 'Asistencia',
          icon: Icons.check_box_rounded,
          color: AppColors.success,
        );
      case LogCategory.schedule:
        return _EntryStyle(
          label: 'Horario',
          icon: Icons.calendar_month_rounded,
          color: AppColors.info,
        );
      case LogCategory.members:
        return _EntryStyle(
          label: 'Miembros',
          icon: Icons.person_add_rounded,
          color: AppColors.chart1,
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
