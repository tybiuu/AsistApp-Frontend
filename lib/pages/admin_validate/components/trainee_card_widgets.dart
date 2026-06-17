import 'package:flutter/material.dart';

class TraineeAvatar extends StatelessWidget {
  final String initials;

  const TraineeAvatar({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      radius: 22,
      child: Text(
        initials,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class TraineePersonInfo extends StatelessWidget {
  final String name;
  final String career;

  const TraineePersonInfo({super.key, required this.name, required this.career});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          career,
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
        ),
      ],
    );
  }
}

class TraineeStatusBadge extends StatelessWidget {
  final String text;
  final Color color;

  const TraineeStatusBadge({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}
