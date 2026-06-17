import 'package:flutter/material.dart';

import 'package:asist_app/configs/theme.dart';
import '../admin_analytics_controller.dart';

class AbsencesChart extends StatelessWidget {
  final List<MemberAnalytic> ranking;

  const AbsencesChart({super.key, required this.ranking});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final int maxValue = ranking.first.daysMissed;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top inasistencias',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            children: ranking.map((member) => _AbsenceRow(
                  member: member,
                  maxValue: maxValue,
                  colors: colors,
                )).toList(),
          ),
        ),
      ],
    );
  }
}

class _AbsenceRow extends StatelessWidget {
  final MemberAnalytic member;
  final int maxValue;
  final ColorScheme colors;

  const _AbsenceRow({
    required this.member,
    required this.maxValue,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final double percent =
        maxValue == 0 ? 0 : member.daysMissed / maxValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              member.shortName,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 13,
                backgroundColor: colors.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.error,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 28,
            child: Text(
              '${member.daysMissed}d',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
