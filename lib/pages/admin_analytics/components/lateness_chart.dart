import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../configs/theme.dart';
import '../admin_analytics_controller.dart';

class LatenessChart extends StatelessWidget {
  final List<MemberAnalytic> ranking;

  const LatenessChart({super.key, required this.ranking});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final maxValue = ranking.first.minutesLateSum.toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top tardanzas acumuladas',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: (maxValue * 1.2).ceilToDouble(),
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 15,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: isDark
                        ? const Color(0xff2D3042)
                        : const Color(0xfff3f4f6),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= ranking.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          '${ranking[index].minutesLateSum}',
                          style: TextStyle(
                            color: AppColors.chart1,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      interval: 15,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= ranking.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            ranking[index].shortName,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: ranking.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value.minutesLateSum.toDouble(),
                        color: AppColors.chart1,
                        width: 28,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}