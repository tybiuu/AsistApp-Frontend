// lib/components/admin_request_card.dart

import 'package:flutter/material.dart';

import '../configs/theme.dart';
import '../pages/admin_home/components/admin_home_summary.dart';

class AdminRequestCard extends StatelessWidget {
  final AdminRequestSummary request;
  final VoidCallback? onTap;

  const AdminRequestCard({super.key, required this.request, this.onTap});

  IconData get _icon {
    switch (request.type) {
      case 'schedule':
        return Icons.calendar_month_outlined;
      case 'attendance':
        return Icons.schedule_rounded;
      default:
        return Icons.group_add_outlined;
    }
  }

  Color _iconBackground(ColorScheme colors) {
    switch (request.type) {
      case 'schedule':
        return AppColors.chart3.withValues(alpha: 0.14);
      case 'attendance':
        return AppColors.chart2.withValues(alpha: 0.14);
      default:
        return AppColors.chart1.withValues(alpha: 0.14);
    }
  }

  Color _iconColor() {
    switch (request.type) {
      case 'schedule':
        return AppColors.chart3;
      case 'attendance':
        return AppColors.chart2;
      default:
        return AppColors.chart1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _iconBackground(colors),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, size: 18, color: _iconColor()),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  request.title,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.chart1,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${request.count}',
                  style: const TextStyle(
                    color: AppColors.primaryForeground,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right_rounded,
                color: colors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
