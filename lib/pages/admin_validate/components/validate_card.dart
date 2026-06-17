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
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

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
              children: [
                Expanded(
                  child: _TimeBox(
                    label: 'IN',
                    time: inTime,
                    color: status == 'Tardanza' ? const Color(0xFFF97316) : AppColors.success,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: _TimeBox(label: 'REF. IN',  time: snackStart ?? '-', color: const Color(0xFF64748B))),
                const SizedBox(width: 8),
                Expanded(child: _TimeBox(label: 'REF. OUT', time: snackEnd  ?? '-', color: const Color(0xFF64748B))),
                const SizedBox(width: 8),
                Expanded(child: _TimeBox(label: 'OUT',      time: outTime,           color: const Color(0xFF64748B))),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Validar →', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String label;
  final String time;
  final Color color;

  const _TimeBox({required this.label, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 9,  fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(time,  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
