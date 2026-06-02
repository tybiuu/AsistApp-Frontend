import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/theme.dart';

class MonthPicker extends StatelessWidget {
  final List<String> months;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const MonthPicker({
    super.key,
    required this.months,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Período',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await showModalBottomSheet<int>(
                context: context,
                builder: (_) => _MonthPickerSheet(
                  months: months,
                  selectedIndex: selectedIndex,
                ),
              );
              if (result != null) onChanged(result);
            },
            child: Row(
              children: [
                Text(
                  months[selectedIndex],
                  style: const TextStyle(
                    color: AppColors.chart1,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.chart1,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthPickerSheet extends StatelessWidget {
  final List<String> months;
  final int selectedIndex;

  const _MonthPickerSheet({
    required this.months,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Seleccionar período',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ...months.asMap().entries.map((entry) {
            final bool isSelected = entry.key == selectedIndex;
            return ListTile(
              title: Text(
                entry.value,
                style: TextStyle(
                  color: isSelected ? AppColors.chart1 : colors.onSurface,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check_rounded, color: AppColors.chart1)
                  : null,
              onTap: () => Get.back(result: entry.key),
            );
          }),
        ],
      ),
    );
  }
}