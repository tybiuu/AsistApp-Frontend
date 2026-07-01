// lib/pages/admin_home/components/admin_request_card.dart

import 'package:flutter/material.dart';

import '../../../configs/theme.dart';
import '../admin_home_models.dart';

class AdminRequestCard extends StatelessWidget {
  final AdminRequestSummary request;
  final VoidCallback? onTap;

  const AdminRequestCard({super.key, required this.request, this.onTap});

  IconData get _icon {
    switch (request.type) {
      case 'scheduleRequests':
        return Icons.calendar_month_outlined;
      case 'attendance':
        return Icons.schedule_rounded;
      default:
        return Icons.group_add_outlined;
    }
  }

  Color get _iconColor {
    switch (request.type) {
      case 'scheduleRequests':
        return AppColors.chart6;
      case 'attendance':
        return AppColors.chart7;
      default:
        return AppColors.chart1;
    }
  }

  Color get _iconBackground => _iconColor.withValues(alpha: 0.12);

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
          height: 66,
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
                  color: _iconBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, size: 18, color: _iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  request.title,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (request.count > 0) ...[
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${request.count}',
                    style: TextStyle(
                      color: colors.onPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
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
