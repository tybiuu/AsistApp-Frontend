import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../analytics_controller.dart';

class DistributionChart extends StatelessWidget {
  final PractitionerAnalytics data;

  const DistributionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final sections = [
      _DonutSection(
        label: 'Confirmado',
        value: data.daysAttended.toDouble(),
        unit: 'd',
        color: const Color(0xff16a34a),
      ),
      _DonutSection(
        label: 'Tardanza',
        value: data.daysLate.toDouble(),
        unit: 'd',
        color: const Color(0xffe15d27),
      ),
      _DonutSection(
        label: 'Inasistencia',
        value: data.daysMissed.toDouble(),
        unit: 'd',
        color: const Color(0xffef4444),
      ),
      _DonutSection(
        label: 'Pendiente',
        value: data.pendingDays.toDouble(),
        unit: 'd',
        color: const Color(0xff1d4ed8),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribución del mes',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 60,
                    sections: sections
                        .where((s) => s.value > 0)
                        .map((s) => PieChartSectionData(
                              value: s.value,
                              color: s.color,
                              radius: 30,
                              showTitle: false,
                            ))
                        .toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: sections.map((s) => _LegendItem(section: s)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutSection {
  final String label;
  final double value;
  final String unit;
  final Color color;

  const _DonutSection({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });
}

class _LegendItem extends StatelessWidget {
  final _DonutSection section;

  const _LegendItem({required this.section});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: section.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${section.label}: ',
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${section.value.toInt()}${section.unit}',
          style: TextStyle(
            color: section.color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}