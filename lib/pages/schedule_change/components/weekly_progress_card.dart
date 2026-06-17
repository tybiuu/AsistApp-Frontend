import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../schedule_change_controller.dart';

class WeeklyProgressCard extends StatelessWidget {
  final ScheduleChangeController c;
  final Color brandColor;

  const WeeklyProgressCard({
    super.key,
    required this.c,
    required this.brandColor,
  });

  static const _abbrevs = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB'];
  static const _dayKeys = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Obx(() {
      final targetHours = c.selectedTargetHours.value;
      final currentHours = c.currentWeeklyWorkHours;
      final isComplete = c.isScheduleComplete;
      final missingHours = c.missingHours;
      final successColor = AppColors.success;

      final containerBg = isComplete
          ? successColor.withValues(alpha: 0.06)
          : cs.surfaceContainerHigh;
      final containerBorder = isComplete
          ? successColor.withValues(alpha: 0.3)
          : cs.outlineVariant;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: containerBorder, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isComplete
                          ? Icons.check_circle_rounded
                          : Icons.info_outline_rounded,
                      color: isComplete ? successColor : cs.onSurfaceVariant,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isComplete
                          ? '¡Horario completo!'
                          : 'Te faltan ${missingHours % 1 == 0 ? missingHours.toInt() : missingHours.toStringAsFixed(1)}h',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: isComplete ? successColor : cs.onSurface,
                      ),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.4),
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${currentHours % 1 == 0 ? currentHours.toInt() : currentHours.toStringAsFixed(1)}h',
                        style: TextStyle(
                            color: isComplete ? successColor : cs.onSurface),
                      ),
                      const TextSpan(text: '  /  '),
                      TextSpan(text: '${targetHours}h'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (currentHours / targetHours).clamp(0.0, 1.0),
                backgroundColor: isComplete
                    ? successColor.withValues(alpha: 0.1)
                    : cs.outlineVariant.withValues(alpha: 0.5),
                color: isComplete ? successColor : brandColor,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_abbrevs.length, (i) {
                final dayData = c.weeklySchedule[_dayKeys[i]];
                String hoursText = '—';
                bool hasHours = false;

                if (dayData != null &&
                    dayData.enabled &&
                    dayData.blocks.isNotEmpty) {
                  final double dayH = c.dayWorkMins(dayData) / 60;
                  if (dayH > 0) {
                    hoursText =
                        '${dayH % 1 == 0 ? dayH.toInt() : dayH.toStringAsFixed(1)}h';
                    hasHours = true;
                  }
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: _DayMiniCard(
                      label: _abbrevs[i],
                      hoursText: hoursText,
                      hasHours: hasHours,
                      isComplete: isComplete,
                      brandColor: brandColor,
                      successColor: successColor,
                      cs: cs,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}

class _DayMiniCard extends StatelessWidget {
  final String label;
  final String hoursText;
  final bool hasHours;
  final bool isComplete;
  final Color brandColor;
  final Color successColor;
  final ColorScheme cs;

  const _DayMiniCard({
    required this.label,
    required this.hoursText,
    required this.hasHours,
    required this.isComplete,
    required this.brandColor,
    required this.successColor,
    required this.cs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.8)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: cs.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hoursText,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: hasHours
                  ? (isComplete ? successColor : brandColor)
                  : cs.outline,
            ),
          ),
        ],
      ),
    );
  }
}
