// lib/pages/admin_analytics/controller/summary_grid.dart

import 'package:flutter/material.dart';

import '../../../components/member_metric_card.dart';
import '../../../configs/theme.dart';
import '../admin_analytics_controller.dart';

class SummaryGrid extends StatelessWidget {
  final MonthSummary summary;

  const SummaryGrid({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.8,
      children: [
        MemberMetricCard(
          label: 'Asistencias confirmadas',
          value: '${summary.confirmedAttendances}',
          valueColor: AppColors.success,
          subtitle: '',
        ),
        MemberMetricCard(
          label: 'Puntualidad promedio',
          value: '${summary.punctualityPercent}%',
          valueColor: Theme.of(context).colorScheme.primary,
          subtitle: '',
        ),
        MemberMetricCard(
          label: 'Total tardanzas',
          value: '${summary.totalLates}',
          valueColor: AppColors.chart1,
          subtitle: '',
        ),
        MemberMetricCard(
          label: 'Total inasistencias',
          value: '${summary.totalAbsences}',
          valueColor: AppColors.error,
          subtitle: '',
        ),
      ],
    );
  }
}