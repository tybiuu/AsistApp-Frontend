import 'package:flutter/material.dart';

import 'trainee_card_widgets.dart';

class MissingCard extends StatelessWidget {
  final String initials;
  final String name;
  final String career;
  final String inTime;
  final String outTime;

  const MissingCard({
    super.key,
    required this.initials,
    required this.name,
    required this.career,
    required this.inTime,
    required this.outTime,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2563EB)),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          TraineeAvatar(initials: initials),
          const SizedBox(width: 12),
          Expanded(child: TraineePersonInfo(name: name, career: career)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const TraineeStatusBadge(
                text: 'Sin marcar',
                color: Color(0xFF3B82F6),
              ),
              const SizedBox(height: 8),
              Text(
                '$inTime - $outTime',
                style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
