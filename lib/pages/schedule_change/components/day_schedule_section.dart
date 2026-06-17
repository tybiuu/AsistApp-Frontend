import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/schedule.dart';
import '../schedule_change_controller.dart';

class DayScheduleSection extends StatelessWidget {
  final String dayKey;
  final DaySchedule daySchedule;
  final ScheduleChangeController c;
  final Color brandColor;

  const DayScheduleSection({
    super.key,
    required this.dayKey,
    required this.daySchedule,
    required this.c,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayKey,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
              ),
              Switch(
                value: daySchedule.enabled,
                onChanged: (value) => c.toggleDay(dayKey, value),
                activeThumbColor: brandColor,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (daySchedule.enabled)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...List.generate(daySchedule.blocks.length, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _BlockRow(
                    block: daySchedule.blocks[i],
                    blockIndex: i,
                    dayKey: dayKey,
                    c: c,
                    brandColor: brandColor,
                  ),
                )),
                const SizedBox(height: 4),
                OutlinedButton.icon(
                  onPressed: () => c.addBlock(dayKey),
                  icon: Icon(Icons.add, color: cs.onSurfaceVariant, size: 18),
                  label: Text(
                    'Agregar bloque',
                    style: TextStyle(
                      color: cs.onSurfaceVariant,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: cs.outlineVariant),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            )
          else
            Text(
              'Día libre',
              style: TextStyle(
                fontSize: 12,
                color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}

class _BlockRow extends StatelessWidget {
  final ScheduleBlock block;
  final int blockIndex;
  final String dayKey;
  final ScheduleChangeController c;
  final Color brandColor;

  const _BlockRow({
    required this.block,
    required this.blockIndex,
    required this.dayKey,
    required this.c,
    required this.brandColor,
  });

  void _showTypeModal(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isWork = block.type == BlockType.work;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tipo de bloque',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                Icons.work_outline,
                color: isWork ? brandColor : cs.onSurfaceVariant,
              ),
              title: Text(
                'Trabajo',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: cs.onSurface),
              ),
              trailing:
                  isWork ? Icon(Icons.check_circle, color: brandColor) : null,
              onTap: () {
                c.changeBlockType(dayKey, blockIndex, BlockType.work);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.local_cafe_outlined,
                color: !isWork ? brandColor : cs.onSurfaceVariant,
              ),
              title: Text(
                'Refrigerio',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: cs.onSurface),
              ),
              trailing:
                  !isWork ? Icon(Icons.check_circle, color: brandColor) : null,
              onTap: () {
                c.changeBlockType(dayKey, blockIndex, BlockType.breakTime);
                Get.back();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isWork = block.type == BlockType.work;
    final labelBg = isWork ? brandColor : cs.surfaceContainerHighest;
    final labelTextColor = isWork ? cs.onPrimary : cs.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showTypeModal(context),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: labelBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isWork ? Icons.work_rounded : Icons.local_cafe_rounded,
                    color: labelTextColor,
                    size: 13,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isWork ? 'Trabajo' : 'Refrig.',
                    style: TextStyle(
                      color: labelTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => c.editBlockTime(dayKey, blockIndex),
              child: Text(
                block.start,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_rounded,
            color: cs.onSurfaceVariant.withValues(alpha: 0.4),
            size: 16,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => c.editBlockTime(dayKey, blockIndex),
              child: Text(
                block.end,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: cs.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            color: cs.error.withValues(alpha: 0.8),
            onPressed: () => c.removeBlock(dayKey, blockIndex),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
