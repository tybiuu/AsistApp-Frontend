import 'package:flutter/material.dart';

import '../../../configs/theme.dart';
import '../analytics_controller.dart';

class HoursCard extends StatelessWidget {
  final PractitionerAnalytics data;

  const HoursCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horas completadas',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${data.hoursCompleted}h',
                style: const TextStyle(
                  color: AppColors.chart1,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ ${data.hoursRequired}h',
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.hoursProgress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: colors.surfaceContainerHigh,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.chart1),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${data.hoursProgress.clamp(0.0, 1.0) * 100 ~/ 1}% del total requerido',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              Text(
                '${data.hoursRemaining}h restantes',
                style: const TextStyle(
                  color: AppColors.chart1,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}