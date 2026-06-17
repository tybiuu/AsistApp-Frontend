import 'package:flutter/material.dart';

class DonutSection {
  final String label;
  final double value;
  final Color color;
  final String unit;

  const DonutSection({
    required this.label,
    required this.value,
    required this.color,
    this.unit = '',
  });
}

class DonutLegendItem extends StatelessWidget {
  final DonutSection section;

  const DonutLegendItem({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: section.color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '${section.label}: ',
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${section.value.toInt()}${section.unit}',
          style: TextStyle(
            color: section.color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
