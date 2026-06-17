import 'package:flutter/material.dart';

class HoursSelectorRow extends StatelessWidget {
  final List<int> options;
  final int selectedHours;
  final ValueChanged<int> onSelect;
  final Color brandColor;

  const HoursSelectorRow({
    super.key,
    required this.options,
    required this.selectedHours,
    required this.onSelect,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: options.map((hours) {
        final isSelected = selectedHours == hours;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onSelect(hours),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? brandColor : cs.outlineVariant,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? brandColor.withValues(alpha: 0.05)
                      : cs.surfaceContainerLowest,
                ),
                child: Column(
                  children: [
                    Text(
                      '${hours}h',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: isSelected ? brandColor : cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'semanales',
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? brandColor : cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
