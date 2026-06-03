import 'package:flutter/material.dart';

import '../../../configs/theme.dart';
import '../admin_activity_log_controller.dart';

class FilterTabs extends StatelessWidget {
  final ActivityFilter selected;
  final ValueChanged<ActivityFilter> onChanged;

  const FilterTabs({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final tabs = [
      (ActivityFilter.todos,       'Todos'),
      (ActivityFilter.asistencias, 'Asistencias'),
      (ActivityFilter.horarios,    'Horarios'),
      (ActivityFilter.miembros,    'Miembros'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) {
          final bool isActive = selected == tab.$1;
          return GestureDetector(
            onTap: () => onChanged(tab.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.chart1
                    : colors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tab.$2,
                style: TextStyle(
                  color: isActive ? Colors.white : colors.onSurfaceVariant,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}