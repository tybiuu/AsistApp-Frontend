import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../components/donut_chart_legend.dart';
import '../../../configs/theme.dart';
import '../admin_analytics_controller.dart';

class DistributionChart extends StatelessWidget {
  final MonthSummary summary;

  const DistributionChart({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    final sections = [
      DonutSection(
        label: 'Confirmado',
        value: summary.confirmedAttendances.toDouble(),
        color: AppColors.success,
      ),
      DonutSection(
        label: 'Tardanza',
        value: summary.totalLates.toDouble(),
        color: AppColors.chart1,
      ),
      DonutSection(
        label: 'Inasistencia',
        value: summary.totalAbsences.toDouble(),
        color: AppColors.error,
      ),
      DonutSection(
        label: 'Pendiente',
        value: summary.totalPending.toDouble(),
        color: AppColors.info,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distribución general del mes',
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

