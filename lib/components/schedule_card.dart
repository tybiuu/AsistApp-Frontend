// lib/components/schedule_card.dart

import 'package:asist_app/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/schedule_change/schedule_change_controller.dart';

import '../configs/theme.dart';
import '../models/schedule.dart';

class ScheduleCard extends StatelessWidget {
  final RxMap<String, DaySchedule> schedule;
  final RxnInt expandedDay;
  final void Function(int) onToggleDay;

  const ScheduleCard({
    super.key,
    required this.schedule,
    required this.expandedDay,
    required this.onToggleDay,
  });

  int get _totalWeekMins =>
      schedule.values.fold(0, (sum, d) => sum + dayWorkMins(d));

  @override
  Widget build(BuildContext context) {
    final cardBg = Theme.of(context).colorScheme.surface;
    final border = Theme.of(context).colorScheme.outlineVariant;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final onCard = Theme.of(context).colorScheme.onSurface;
    final trackColor =
        Theme.of(context).colorScheme.outlineVariant;

    return Obx(() {
      final days = schedule.keys
          .where((k) => schedule[k]!.enabled)
          .toList();

      return Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: border)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Horario aprobado',
                          style: TextStyle(
                            color: onCard,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${fmtMins(_totalWeekMins)} / sem',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Time axis ────────────────────────────────────────────────────
            if (days.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  children: [
                    const SizedBox(width: 36),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: ['6a', '9a', '12p', '3p', '6p', '9p']
                            .map(
                              (l) => Text(
                                l,
                                style: TextStyle(color: muted, fontSize: 9),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 72),
                  ],
                ),
              ),

            // ── Day rows ──────────────────────────────────────────────────────
            ...days.asMap().entries.map((e) {
              final idx = e.key;
              final dayKey = e.value;
              final sched = schedule[dayKey]!;
              return _DayRow(
                dayKey: dayKey,
                sched: sched,
                idx: idx,
                isExpanded: expandedDay.value == idx,
                showDivider: idx < days.length - 1,
                onTap: () => onToggleDay(idx),
              );
            }),

            // ── Legend ────────────────────────────────────────────────────────
            if (days.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
                child: Row(
                  children: [
                    _LegendItem(
                      color: Theme.of(context).colorScheme.primary,
                      label: 'Trabajo',
                      muted: muted,
                    ),
                    const SizedBox(width: 14),
                    _LegendItem(
                      color: AppColors.chart1.withValues(alpha: 0.4),
                      label: 'Refrigerio',
                      muted: muted,
                    ),
                    const SizedBox(width: 14),
                    _LegendItem(
                      color: trackColor,
                      label: 'Fuera',
                      muted: muted,
                    ),
                  ],
                ),
              ),

            // ── Hint ──────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Toca un día para ver los bloques exactos',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 10),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ── Legend item ───────────────────────────────────────────────────────────────

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final Color muted;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.muted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(color: muted, fontSize: 10),
        ),
      ],
    );
  }
}

// ── Day row ───────────────────────────────────────────────────────────────────

class _DayRow extends StatelessWidget {
  final String dayKey;
  final DaySchedule sched;
  final int idx;
  final bool isExpanded;
  final bool showDivider;
  final VoidCallback onTap;

  const _DayRow({
    required this.dayKey,
    required this.sched,
    required this.idx,
    required this.isExpanded,
    required this.showDivider,
    required this.onTap,
  });

  String get _abbrev => dayKey.substring(0, 3).toUpperCase();

  @override
  Widget build(BuildContext context) {
    final border = Theme.of(context).colorScheme.outlineVariant;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final value = Theme.of(context).colorScheme.onSurface;
    final dayMins = dayWorkMins(sched);

    return Column(
      children: [
        GestureDetector(
          onTap: sched.enabled ? onTap : null,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text(
                    _abbrev,
                    style: TextStyle(
                      color: sched.enabled ? value : muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Expanded(child: _ScheduleBar(sched: sched)),
                const SizedBox(width: 8),
                SizedBox(
                  width: 44,
                  child: Text(
                    sched.enabled ? fmtMins(dayMins) : '—',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: sched.enabled ? value : muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: sched.enabled ? muted : border,
                ),
              ],
            ),
          ),
        ),
                if (isExpanded && sched.enabled) _BlockDetail(dayKey: dayKey, sched: sched),
        if (showDivider) Divider(height: 1, thickness: 1, color: border),
      ],
    );
  }
}

// ── Schedule bar ──────────────────────────────────────────────────────────────

class _ScheduleBar extends StatelessWidget {
  final DaySchedule sched;

  const _ScheduleBar({required this.sched});

  // 6:00 AM → 9:00 PM
  static const _start = 360;
  static const _end = 1260;
  static const _span = _end - _start;

  @override
  Widget build(BuildContext context) {
    final trackColor =
        Theme.of(context).colorScheme.outlineVariant;

    if (!sched.enabled || sched.blocks.isEmpty) {
      return Container(
        height: 8,
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    return LayoutBuilder(builder: (_, constraints) {
      final totalWidth = constraints.maxWidth;
      return SizedBox(
        height: 8,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: trackColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            ...sched.blocks.map((block) {
              final s = schedToMins(block.start).clamp(_start, _end);
              final e = schedToMins(block.end).clamp(_start, _end);
              final left = ((s - _start) / _span) * totalWidth;
              final width = ((e - s) / _span) * totalWidth;
              final color = block.type == BlockType.work
                  ? Theme.of(context).colorScheme.primary
                  : AppColors.chart1.withValues(alpha: 0.4);
              return Positioned(
                left: left,
                width: width,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    });
  }
}

// ── Block detail ──────────────────────────────────────────────────────────────

class _BlockDetail extends StatelessWidget {
  final String dayKey;
  final DaySchedule sched;

  const _BlockDetail({required this.dayKey, required this.sched});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surfaceContainerLow;
    final label = Theme.of(context).colorScheme.onSurfaceVariant;
    final value = Theme.of(context).colorScheme.onSurface;

  final controller = Get.isRegistered<ScheduleChangeController>() ? Get.find<ScheduleChangeController>() : null;

  return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ...sched.blocks.asMap().entries.map((entry) {
            final idx = entry.key;
            final b = entry.value;
            final isWork = b.type == BlockType.work;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isWork
                          ? Theme.of(context).colorScheme.primary
                          : AppColors.chart1.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isWork ? 'Trabajo' : 'Descanso',
                    style: TextStyle(
                      color: label,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: controller == null ? null : () => controller.editBlockTime(dayKey, idx),
                    child: Text(
                      '${b.start} – ${b.end}',
                      style: TextStyle(
                        color: value,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (controller != null)
                    InkWell(
                      onTap: () => controller.removeBlock(dayKey, idx),
                      child: Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          if (Get.isRegistered<ScheduleChangeController>())
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text('Agregar bloque'),
                onPressed: () {
                  final controller = Get.find<ScheduleChangeController>();
                  controller.addBlock(dayKey);
                },
              ),
            ),
        ],
      ),
    );
  }
}
