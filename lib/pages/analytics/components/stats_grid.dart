import 'package:flutter/material.dart';

import '../analytics_controller.dart';

class StatsGrid extends StatelessWidget {
  final PractitionerAnalytics data;

  const StatsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.4,
      children: [
        _StatCell(
          label: '% Asistencia',
          value: '${data.attendancePercent.toStringAsFixed(0)}%',
          valueColor: AnalyticsController.percentColor(data.attendancePercent),
          subtitle: '',
        ),
        _StatCell(
          label: 'Días asistidos',
          value: '${data.daysAttended}',
          valueColor: colors.onSurface,
          subtitle: 'de ${data.totalWorkDays} días hábiles',
        ),
        _StatCell(
          label: 'Tardanzas',
          value: '${data.daysLate}',
          valueColor: const Color(0xffe15d27),
          subtitle: 'este mes',
        ),
        _StatCell(
          label: 'Inasistencias',
          value: '${data.daysMissed}',
          valueColor: const Color(0xffef4444),
          subtitle: 'este mes',
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final String subtitle;

  const _StatCell({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}