// lib/components/info_card.dart

import 'package:flutter/material.dart';

import '../configs/theme.dart';

class InfoRowData {
  final IconData icon;
  final String label;
  final String value;
  final Widget? leading;

  const InfoRowData({
    required this.icon,
    required this.label,
    required this.value,
    this.leading,
  });
}

class InfoCard extends StatelessWidget {
  final String title;
  final List<InfoRowData> rows;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  const InfoCard({
    super.key,
    required this.title,
    required this.rows,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _InfoCardHeader(
            title: title,
            actionLabel: actionLabel,
            actionIcon: actionIcon,
            onAction: onAction,
          ),
          ...rows.asMap().entries.map(
            (entry) => _InfoRow(
              data: entry.value,
              showBorder: entry.key < rows.length - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCardHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  const _InfoCardHeader({
    required this.title,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (actionLabel != null && actionIcon != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Icon(actionIcon, size: 14, color: AppColors.chart1),
                  const SizedBox(width: 5),
                  Text(
                    actionLabel!,
                    style: const TextStyle(
                      color: AppColors.chart1,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final InfoRowData data;
  final bool showBorder;

  const _InfoRow({required this.data, required this.showBorder});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: showBorder
            ? Border(bottom: BorderSide(color: colors.outlineVariant))
            : null,
      ),
      child: Row(
        children: [
          data.leading ?? Icon(data.icon, size: 16, color: AppColors.chart1),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.value,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
