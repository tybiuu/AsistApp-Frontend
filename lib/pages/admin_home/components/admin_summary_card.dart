// lib/pages/admin_home/components/admin_summary_card.dart

import 'package:flutter/material.dart';

import '../../../components/primary_button.dart';
import '../../../configs/theme.dart';
import '../admin_home_controller.dart';
import '../admin_home_models.dart';

class AdminSummaryCard extends StatelessWidget {
  final AdminHomeController controller;

  const AdminSummaryCard({super.key, required this.controller});

  Color _statColor(AdminSummaryStat stat) {
    switch (stat.type) {
      case 'confirmed':
        return AppColors.chart2;
      case 'absences':
        return AppColors.destructive;
      default:
        return AppColors.chart1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOY',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            controller.currentDateLabel,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: controller.stats
                .map(
                  (stat) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _StatBox(stat: stat, color: _statColor(stat)),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            onPressed: controller.goToPendingRequests,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ver pendientes'),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final AdminSummaryStat stat;
  final Color color;

  const _StatBox({required this.stat, required this.color});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${stat.value}',
            style: TextStyle(
              color: color,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.label,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
