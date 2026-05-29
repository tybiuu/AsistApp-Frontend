import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../components/info_card.dart';
import '../../components/primary_button.dart';
import '../../components/schedule_card.dart';
import '../../components/status_badge.dart';
import '../../models/schedule.dart';
import 'admin_schedule_validation_controller.dart';

class AdminScheduleValidationPage extends StatelessWidget {
  const AdminScheduleValidationPage({super.key});

  String cicloLabel(dynamic ciclo) {
    if (ciclo == null) return '-';

    final value = int.tryParse(ciclo.toString());

    if (value == null) return ciclo.toString();

    return '${value}mo ciclo';
  }

  @override

  Widget build(BuildContext context) {
    final c = Get.find<AdminScheduleValidationController>();
    final req = c.selectedRequest.value!;
    final expandedDay = RxnInt();
    final previewSchedule = RxMap<String, DaySchedule>.from(
      req.currentSchedule.map(
        (day, blocks) => MapEntry(
          day,
          DaySchedule(enabled: blocks.isNotEmpty, blocks: blocks),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(title: 'Cambio de horario — ${req.name}'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            req.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        StatusBadge(status: _badgeStatus(req.status)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    InfoCard(
                      title: 'Datos del practicante',
                      rows: [
                        InfoRowData(
                          icon: Icons.school,
                          label: 'Carrera',
                          value: req.career,
                        ),
                        InfoRowData(
                          icon: Icons.timeline,
                          label: 'Ciclo',
                          value: cicloLabel(req.ciclo),
                        ),
                        InfoRowData(
                          icon: Icons.schedule,
                          label: 'Horas semanales',
                          value: '${req.targetHours}h',
                        ),
                        InfoRowData(
                          icon: Icons.calendar_today,
                          label: 'Fecha de solicitud',
                          value: req.time,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    InfoCard(
                      title: 'Motivo del cambio',
                      rows: [
                        InfoRowData(
                          icon: Icons.edit_note,
                          label: 'Justificación',
                          value: req.reason,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Horario actual del practicante',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ScheduleCard(
                      schedule: previewSchedule,
                      expandedDay: expandedDay,
                      onToggleDay: (index) {
                        expandedDay.value = expandedDay.value == index ? null : index;
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Comparativa de bloques',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (req.currentSchedule.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Cargando mapa de comparación...',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    else
                      ...req.proposedSchedule.keys.map((day) => _buildCompareDayTile(context, day, req)),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      text: 'Aprobar horario',
                      onPressed: () => c.actionApprove(req.id),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      text: 'Rechazar solicitud',
                      variant: PrimaryButtonVariant.secondary,
                      onPressed: () => c.actionReject(req.id),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BadgeStatus _badgeStatus(String status) {
    switch (status) {
      case 'approved':
        return BadgeStatus.confirmed;
      case 'rejected':
        return BadgeStatus.rejected;
      default:
        return BadgeStatus.pending;
    }
  }

  Widget _buildCompareDayTile(BuildContext context, String dayName, ScheduleRequestModel req) {
    final theme = Theme.of(context);
    final actualBlocks = req.currentSchedule[dayName] ?? [];
    final proposedBlocks = req.proposedSchedule[dayName] ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dayName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: const Text('Modificado', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ACTUAL', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ...actualBlocks.map((b) => _buildSegmentLine(b.type == BlockType.work ? Colors.orange : theme.colorScheme.onSurfaceVariant.withOpacity(0.4), '${b.start} - ${b.end}')),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.arrow_forward_rounded, color: Colors.grey, size: 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PROPUESTO', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ...proposedBlocks.map((b) => _buildSegmentLine(b.type == BlockType.work ? Colors.orange : theme.colorScheme.onSurfaceVariant.withOpacity(0.4), '${b.start} - ${b.end}')),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSegmentLine(Color dotColor, String segment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          const SizedBox(width: 6),
          Text(segment, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}