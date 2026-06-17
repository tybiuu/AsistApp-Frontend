import 'package:flutter/material.dart';

class ScheduleInfoCard extends StatelessWidget {
  final String organizationId;
  final String checkIn;
  final String checkOut;
  final String lunchStart;
  final String lunchEnd;

  const ScheduleInfoCard({
    super.key,
    required this.organizationId,
    required this.checkIn,
    required this.checkOut,
    required this.lunchStart,
    required this.lunchEnd,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final breakBg = colors.surfaceContainer;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _InfoBlock(
                  title: 'Organización',
                  value: organizationId,
                  align: CrossAxisAlignment.start,
                ),
              ),
              Expanded(
                flex: 3,
                child: _InfoBlock(
                  title: 'Tu horario hoy',
                  value: '$checkIn - $checkOut',
                  align: CrossAxisAlignment.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _ScheduleTag(
                '$checkIn - $lunchStart · Trabajo',
                colors.primary.withValues(alpha: 0.15),
                colors.primary,
              ),
              _ScheduleTag(
                '$lunchStart - $lunchEnd · Refrigerio',
                breakBg,
                colors.onSurfaceVariant,
              ),
              _ScheduleTag(
                '$lunchEnd - $checkOut · Trabajo',
                colors.primary.withValues(alpha: 0.15),
                colors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String value;
  final CrossAxisAlignment align;

  const _InfoBlock({
    required this.title,
    required this.value,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: colors.onSurface, fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _ScheduleTag extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _ScheduleTag(this.text, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}
