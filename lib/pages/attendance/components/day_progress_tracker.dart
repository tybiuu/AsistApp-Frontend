import 'package:flutter/material.dart';

import '../../../components/status_badge.dart';
import '../../../configs/theme.dart';
import 'attendance_step.dart';

class DayProgressTracker extends StatelessWidget {
  final List<AttendanceStep> steps;
  final int currentStep;
  final Map<int, String> markedTimes;

  const DayProgressTracker({
    super.key,
    required this.steps,
    required this.currentStep,
    required this.markedTimes,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.foreground;
    final mutedColor = colors.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROGRESO DEL DÍA',
            style: TextStyle(
              color: mutedColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),
          ...steps.asMap().entries.map((e) {
            final i = e.key;
            final s = e.value;
            final isDone   = markedTimes.containsKey(i);
            final isActive = i == currentStep && !isDone;

            return Padding(
              padding: EdgeInsets.only(bottom: i < steps.length - 1 ? 14 : 0),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (isDone || isActive) ? s.color : colors.surfaceContainerHigh,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDone ? Icons.check_rounded : s.icon,
                      color: (isDone || isActive) ? Colors.white : colors.onSurfaceVariant,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.label,
                          style: TextStyle(
                            color: (isDone || isActive) ? textColor : mutedColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.schedule_rounded, size: 10, color: mutedColor),
                            const SizedBox(width: 3),
                            Text(
                              'Programado ${s.scheduled}',
                              style: TextStyle(color: mutedColor, fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isDone) ...[
                    Text(
                      markedTimes[i]!,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    StatusBadge(status: BadgeStatus.confirmed),
                  ] else if (isActive)
                    StatusBadge(status: BadgeStatus.pending)
                  else
                    Text('–', style: TextStyle(color: mutedColor, fontSize: 14)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
