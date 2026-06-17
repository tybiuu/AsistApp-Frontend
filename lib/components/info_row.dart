import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final double labelWidth;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.labelWidth = 72,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (icon != null) ...[
          Icon(icon, size: 14, color: colors.onSurface),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
