// lib/pages/profile/components/schedule_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/theme.dart';
import '../../../components/status_badge.dart';
import '../profile_controller.dart';
import '../profile_schedule.dart';

/// Card that shows the practitioner's approved weekly schedule.
/// Each day row is tappable to expand block details.
class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final muted = isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);
    final onCard = isDark ? Colors.white : const Color(0xff1f2937);

    final days = c.schedule.keys.toList();

    return Obx(() => Container(
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
                const Icon(Icons.access_time_rounded, size: 16, color: AppColors.chart1),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        'Horario aprobado',
                        style: TextStyle(color: onCard, fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${fmtMins(c.totalWeekMins)} / sem',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const StatusBadge(status: BadgeStatus.confirmed),
              ],
            ),
          ),

          // ── Day rows ──────────────────────────────────────────────────────
          ...days.asMap().entries.map((e) {
            final idx    = e.key;
            final dayKey = e.value;
            final sched  = c.schedule[dayKey]!;
            return _DayRow(
              dayKey: dayKey,
              sched: sched,
              idx: idx,
              isExpanded: c.expandedDay.value == idx,
              isDark: isDark,
              showDivider: idx < days.length - 1,
              onTap: () => c.toggleDay(idx),
            );
          }),

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
    ));
  }
}

// ── Day row ───────────────────────────────────────────────────────────────────

class _DayRow extends StatelessWidget {
  final String dayKey;
  final DaySchedule sched;
  final int idx;
  final bool isExpanded;
  final bool isDark;
  final bool showDivider;
  final VoidCallback onTap;

  const _DayRow({
    required this.dayKey,
    required this.sched,
    required this.idx,
    required this.isExpanded,
    required this.isDark,
    required this.showDivider,
    required this.onTap,
  });

  Color get _border => isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
  Color get _muted => isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);
  Color get _value => isDark ? Colors.white : const Color(0xff1f2937);

  @override
  Widget build(BuildContext context) {
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
                // Day name
                SizedBox(
                  width: 80,
                  child: Text(
                    dayKey,
                    style: TextStyle(
                      color: sched.enabled ? _value : _muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Timeline bar
                Expanded(child: _ScheduleBar(sched: sched, isDark: isDark)),
                const SizedBox(width: 8),
                // Hours label
                SizedBox(
                  width: 44,
                  child: Text(
                    sched.enabled ? fmtMins(dayMins) : '—',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: sched.enabled ? _value : _muted,
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
                  color: sched.enabled ? _muted : _border,
                ),
              ],
            ),
          ),
        ),
        // Block detail
        if (isExpanded && sched.enabled) _BlockDetail(sched: sched, isDark: isDark),
        if (showDivider) Divider(height: 1, thickness: 1, color: _border),
      ],
    );
  }
}

// ── Schedule bar ──────────────────────────────────────────────────────────────

class _ScheduleBar extends StatelessWidget {
  final DaySchedule sched;
  final bool isDark;

  const _ScheduleBar({required this.sched, required this.isDark});

  // Timeline: 08:00–17:00
  static const _start = 480;   // 08:00
  static const _end = 1020;  // 17:00
  static const _span = _end - _start;

  @override
  Widget build(BuildContext context) {
    final trackColor = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);

    if (!sched.enabled || sched.blocks.isEmpty) {
      return Container(
        height: 8,
        decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(4)),
      );
    }

    return LayoutBuilder(builder: (_, constraints) {
      final totalWidth = constraints.maxWidth;
      return SizedBox(
        height: 8,
        child: Stack(
          children: [
            // Track
            Container(
              decoration: BoxDecoration(color: trackColor, borderRadius: BorderRadius.circular(4)),
            ),
            // Blocks
            ...sched.blocks.map((block) {
              final s = schedToMins(block.start).clamp(_start, _end);
              final e = schedToMins(block.end).clamp(_start, _end);
              final left = ((s - _start) / _span) * totalWidth;
              final width = ((e - s) / _span) * totalWidth;
              final color = block.type == BlockType.work
                  ? AppColors.chart1
                  : AppColors.chart1.withValues(alpha: 0.3);
              return Positioned(
                left: left,
                width: width,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
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
  final DaySchedule sched;
  final bool isDark;

  const _BlockDetail({required this.sched, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xff0f1117) : const Color(0xfff9fafb);
    final label = isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
    final value = isDark ? Colors.white : const Color(0xff1f2937);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: sched.blocks.map((b) {
          final isWork = b.type == BlockType.work;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: isWork ? AppColors.chart1 : AppColors.chart1.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  isWork ? 'Trabajo' : 'Descanso',
                  style: TextStyle(color: label, fontSize: 11, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '${b.start} – ${b.end}',
                  style: TextStyle(color: value, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
