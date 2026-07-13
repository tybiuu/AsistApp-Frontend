import 'package:flutter/material.dart';

import '../../../configs/theme.dart';
import 'trainee_card_widgets.dart';

class ValidateCard extends StatelessWidget {
  final String initials;
  final String name;
  final String career;
  final String status;
  final Color statusColor;
  final String inTime;
  final String? snackStart;
  final String? snackEnd;
  final String outTime;
  final bool isLate;
  final VoidCallback? onValidate;

  const ValidateCard({
    super.key,
    required this.initials,
    required this.name,
    required this.career,
    required this.status,
    required this.statusColor,
    required this.inTime,
    required this.snackStart,
    required this.snackEnd,
    required this.outTime,
    required this.isLate,
    this.onValidate,
  });

  int get _activeIndex {
    if (outTime != '-') return 3;
    if ((snackEnd ?? '-') != '-') return 2;
    if ((snackStart ?? '-') != '-') return 1;
    if (inTime != '-') return 0;
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final active = _activeIndex;

    final labels = ['ING.', 'S.REF', 'R.REF', 'SAL.'];
    final times  = [inTime, snackStart ?? '-', snackEnd ?? '-', outTime];

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                TraineeAvatar(initials: initials),
                const SizedBox(width: 12),
                Expanded(child: TraineePersonInfo(name: name, career: career)),
                TraineeStatusBadge(text: status, color: statusColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: List.generate(4, (i) {
                final _ChipType type;
                if (i == active) {
                  type = isLate ? _ChipType.activeLate : _ChipType.activeOk;
                } else if (i < active) {
                  type = _ChipType.done;
                } else {
                  type = _ChipType.pending;
                }
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: i < 3 ? 6 : 0),
                    child: _CheckpointChip(
                      label: labels[i],
                      time: times[i],
                      type: type,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onValidate,
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: colors.surfaceContainerHighest,
                disabledForegroundColor: colors.onSurfaceVariant,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                onValidate != null ? 'Validar →' : 'Ya validado',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip ──────────────────────────────────────────────────────────────────────

enum _ChipType { activeLate, activeOk, done, pending }

class _CheckpointChip extends StatelessWidget {
  final String label;
  final String time;
  final _ChipType type;

  const _CheckpointChip({
    required this.label,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final Color bg;
    final Color textColor;
    final Color labelColor;

    switch (type) {
      case _ChipType.activeLate:
        bg         = AppColors.warning.withValues(alpha: 0.12);
        textColor  = AppColors.warning;
        labelColor = AppColors.warning.withValues(alpha: 0.8);
      case _ChipType.activeOk:
        bg         = colors.primary;
        textColor  = Colors.white;
        labelColor = Colors.white70;
      case _ChipType.done:
        bg         = AppColors.success.withValues(alpha: 0.12);
        textColor  = AppColors.success;
        labelColor = AppColors.success.withValues(alpha: 0.8);
      case _ChipType.pending:
        bg         = colors.surfaceContainerHighest;
        textColor  = colors.onSurfaceVariant;
        labelColor = colors.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
