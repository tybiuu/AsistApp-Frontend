import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/app_top_bar.dart';
import '../../models/schedule.dart';
import 'admin_schedule_validation_controller.dart';

class AdminScheduleValidationDetailPage extends StatelessWidget {
  const AdminScheduleValidationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminScheduleValidationController>();
    final theme = Theme.of(context);
    final req = c.selectedRequest.value!;
    const orangeColor = Color(0xffe15d27);

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
                    // Ficha Perfil Simplificada
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: orangeColor,
                            child: Text(req.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(req.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                                Text('${req.career} - ${cicloLabel(req.ciclo)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                const SizedBox(height: 4),
                                Text('🕒 ${req.targetHours}h / semana  •  📅 ${req.time}', style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Motivo del Cambio Card
                    const Text('MOTIVO DEL CAMBIO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: orangeColor)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: orangeColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: orangeColor.withOpacity(0.15)),
                      ),
                      child: Text(
                        '"${req.reason}"', 
                        style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Color(0xffa13b12), height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Encabezado de la comparativa
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('DÍAS CON CAMBIOS (${req.changedDaysCount})', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                        Row(
                          children: [
                            _buildBadgeDot(Colors.orange, 'Mod.'),
                            _buildBadgeDot(const Color(0xff10b981), 'Nuevo'),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Renderización de los bloques comparativos dinámicos
                    if (req.currentSchedule.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('Cargando mapa de comparación...', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                      )
                    else
                      ...req.proposedSchedule.keys.map((day) => _buildCompareDayTile(context, day, req)),

                    const SizedBox(height: 24),

                    // Botones de acción final del Admin
                    ElevatedButton.icon(
                      onPressed: () => c.actionApprove(req.id),
                      icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                      label: const Text('Aprobar horario', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff10b981),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => c.actionReject(req.id),
                      icon: const Icon(Icons.cancel_outlined, color: Color(0xffef4444), size: 20),
                      label: const Text('Rechazar solicitud', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xffef4444), fontSize: 15)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffef4444), width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadgeDot(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Container(width: 7, height: 7, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
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
              // Columna Izquierda: Actual
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
              // Columna Derecha: Propuesto
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