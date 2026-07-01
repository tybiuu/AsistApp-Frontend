import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../components/primary_button.dart';
import '../../configs/theme.dart';
import '../../models/schedule.dart';
import '../../utils/label_utils.dart';
import 'admin_schedule_requests_controller.dart';

class AdminScheduleRequestDetailPage extends StatelessWidget {
  const AdminScheduleRequestDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminScheduleRequestsController>();
    final item = c.selectedItem.value!;
    final colors = Theme.of(context).colorScheme;
    final bool isNew = item.kind == ScheduleRequestKind.newSchedule;
    final Color badgeColor = isNew ? AppColors.success : AppColors.chart6;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            AppTopBar(
              title: (isNew ? 'Primer horario — ' : 'Cambio de horario — ') + item.name,
              showBack: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              item.initials,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: [
                                    Text(
                                      item.name,
                                      style: TextStyle(color: colors.onSurface, fontSize: 15, fontWeight: FontWeight.w900),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: badgeColor.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        isNew ? 'Primer horario' : 'Cambio',
                                        style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.career} · ${cicloLabel(item.ciclo)}',
                                  style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_rounded, size: 13, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${item.targetHours}h / semana',
                                      style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.event_outlined, size: 13, color: colors.onSurfaceVariant),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.time,
                                      style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (!isNew && item.reason != null && item.reason!.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MOTIVO DEL CAMBIO',
                              style: TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w800, letterSpacing: 0.4),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '"${item.reason}"',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 13,
                                color: AppColors.warning,
                                height: 1.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isNew ? 'Horario propuesto' : 'Días con cambios (${item.proposedSchedule.length})',
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                        if (!isNew)
                          const Text(
                            'Modificado',
                            style: TextStyle(fontSize: 10, color: AppColors.warning, fontWeight: FontWeight.w700),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (item.proposedSchedule.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Sin días configurados',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                      )
                    else if (isNew)
                      ...item.proposedSchedule.entries.map(
                        (entry) => _NewScheduleDayCard(dayName: entry.key, blocks: entry.value),
                      )
                    else
                      ...item.proposedSchedule.keys.map(
                        (day) => _CompareDayCard(dayName: day, item: item),
                      ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        _LegendDot(color: AppColors.primary, label: 'Trabajo'),
                        const SizedBox(width: 16),
                        _LegendDot(color: colors.onSurfaceVariant.withValues(alpha: 0.4), label: 'Refrigerio / pausa'),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Obx(
                      () => PrimaryButton(
                        text: 'Aprobar horario',
                        variant: PrimaryButtonVariant.success,
                        onPressed: c.isProcessing.value
                            ? null
                            : () async {
                                try {
                                  await c.approve(item);
                                } catch (e) {
                                  debugPrint('[AdminScheduleRequestDetailPage] Error al aprobar: $e');
                                } finally {
                                  Get.back();
                                }
                              },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => PrimaryButton(
                        text: 'Rechazar solicitud',
                        variant: PrimaryButtonVariant.destructive,
                        onPressed: c.isProcessing.value
                            ? null
                            : () async {
                                try {
                                  await c.reject(item);
                                } catch (e) {
                                  debugPrint('[AdminScheduleRequestDetailPage] Error al rechazar: $e');
                                } finally {
                                  Get.back();
                                }
                              },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant)),
      ],
    );
  }
}

class _NewScheduleDayCard extends StatelessWidget {
  final String dayName;
  final List<ScheduleBlock> blocks;

  const _NewScheduleDayCard({required this.dayName, required this.blocks});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: colors.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(dayName, style: TextStyle(color: colors.onSurface, fontSize: 13, fontWeight: FontWeight.w800)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: blocks.map((b) => _BlockRow(block: b)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareDayCard extends StatelessWidget {
  final String dayName;
  final UnifiedScheduleRequest item;

  const _CompareDayCard({required this.dayName, required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final actualBlocks = item.currentSchedule[dayName] ?? [];
    final proposedBlocks = item.proposedSchedule[dayName] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: AppColors.warning.withValues(alpha: 0.08),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(dayName, style: TextStyle(color: colors.onSurface, fontSize: 13, fontWeight: FontWeight.w800)),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ACTUAL', style: TextStyle(fontSize: 9, color: colors.onSurfaceVariant, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                      const SizedBox(height: 8),
                      ...actualBlocks.map((b) => _BlockRow(block: b)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(Icons.arrow_forward_rounded, size: 16, color: colors.onSurfaceVariant),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PROPUESTO', style: TextStyle(fontSize: 9, color: AppColors.warning, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                      const SizedBox(height: 8),
                      ...proposedBlocks.map((b) => _BlockRow(block: b)),
                    ],
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

class _BlockRow extends StatelessWidget {
  final ScheduleBlock block;

  const _BlockRow({required this.block});

  @override
  Widget build(BuildContext context) {
    final bool isWork = block.type == BlockType.work;
    final Color color = isWork ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(
            '${block.start} – ${block.end}',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(width: 6),
          Icon(isWork ? Icons.work_outline_rounded : Icons.free_breakfast_outlined, size: 11, color: color.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}
