import 'package:flutter/material.dart';

import 'attendance_status_pill.dart';

class AttendanceRecordCard extends StatelessWidget {
  final String date;
  final String status;
  final Color statusColor;
  final String time;
  final String hours;

  const AttendanceRecordCard({
    super.key,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.time,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textColor = colors.onSurface;
    final mutedColor = colors.onSurfaceVariant;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      date,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AttendanceStatusPill(label: status, color: statusColor),
                  ],
                ),
                if (status != 'Inasistencia') ...[
                  const SizedBox(height: 6),
                  Text(
                    hours,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
