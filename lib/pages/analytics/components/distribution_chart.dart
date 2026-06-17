import 'package:fl_chart/fl_chart.dart';
import 'package:asist_app/components/donut_chart_legend.dart';
import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';

import '../analytics_controller.dart';

class DistributionChart extends StatelessWidget {
  final PractitionerAnalytics data;

  const DistributionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final sections = [
      DonutSection(
        label: 'Confirmado',
        value: data.daysAttended.toDouble(),
        unit: 'd',
        color: AppColors.success,
      ),
      DonutSection(
        label: 'Tardanza',
        value: data.daysLate.toDouble(),
        unit: 'd',
        color: AppColors.chart1,
      ),
      DonutSection(
        label: 'Inasistencia',
        value: data.daysMissed.toDouble(),
        unit: 'd',
        color: AppColors.error,
      ),
      DonutSection(
        label: 'Pendiente',
        value: data.pendingDays.toDouble(),
        unit: 'd',
        color: AppColors.info,
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
                children: sections.map((s) => DonutLegendItem(section: s)).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

