import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../schedule_change_controller.dart';
import '../../../models/schedule.dart';
import '../../../components/primary_button.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ScheduleChangeController>();
    final theme = Theme.of(context);
    const orangeColor = Color(0xffe15d27); // Mapeado de AppColors.chart1

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'PASO 1 — MODALIDAD DE HORAS SEMANALES',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                
                // Selector de Modalidad (20h, 25h, 30h)
                Obx(() => Row(
                  children: c.hourOptions.map((hours) {
                    final isSelected = c.selectedTargetHours.value == hours;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => c.selectedTargetHours.value = hours,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: isSelected ? orangeColor.withOpacity(0.08) : theme.colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? orangeColor : theme.colorScheme.outlineVariant, 
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text('${hours}h', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? orangeColor : theme.colorScheme.onSurface)),
                              const Text('semanales', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
                const SizedBox(height: 24),

                const Text(
                  'PASO 2 — BLOQUES HORARIOS POR DÍA',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Alerta de Progreso / Horario Completo utilizando tus helpers nativos
                Obx(() {
                  final isComplete = c.isScheduleComplete;
                  final currentStr = fmtMins(c.totalWeeklyWorkMins);
                  final targetStr = '${c.selectedTargetHours.value}h';

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isComplete ? const Color(0xffecfdf5) : theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isComplete ? const Color(0xff10b981) : Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: isComplete ? const Color(0xff10b981) : Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              isComplete ? '¡Horario completo!' : 'Configura tus horas',
                              style: TextStyle(fontWeight: FontWeight.bold, color: isComplete ? const Color(0xff065f46) : theme.colorScheme.onSurface),
                            ),
                          ],
                        ),
                        Text('$currentStr / $targetStr', style: TextStyle(fontWeight: FontWeight.bold, color: isComplete ? const Color(0xff065f46) : theme.colorScheme.onSurface)),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Lista de días de la semana y sus bloques asignados
                Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: c.weeklySchedule.keys.length,
                  itemBuilder: (context, index) {
                    final dayKey = c.weeklySchedule.keys.elementAt(index);
                    final dayData = c.weeklySchedule[dayKey]!;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(dayKey, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                              Switch(
                                value: dayData.enabled,
                                activeColor: orangeColor,
                                onChanged: (val) => c.toggleDay(dayKey, val),
                              )
                            ],
                          ),
                          if (dayData.enabled) ...[
                            ...dayData.blocks.asMap().entries.map((entry) {
                              final blockIdx = entry.key;
                              final block = entry.value;
                              final isWork = block.type == BlockType.work;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isWork ? orangeColor.withOpacity(0.12) : theme.colorScheme.outlineVariant,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isWork ? 'Trabajo' : 'Refrig.',
                                        style: TextStyle(
                                          color: isWork ? orangeColor : theme.colorScheme.onSurfaceVariant, 
                                          fontWeight: FontWeight.bold, 
                                          fontSize: 12
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${block.start}   →   ${block.end}',
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                      ),
                                    ),
                                    IconButton(
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: const Icon(Icons.delete_outline, color: Color(0xffef4444), size: 20),
                                      onPressed: () => c.removeBlock(dayKey, blockIdx),
                                    )
                                  ],
                                ),
                              );
                            }),
                            TextButton.icon(
                              onPressed: () => c.addBlock(dayKey),
                              icon: const Icon(Icons.add, size: 16, color: orangeColor),
                              label: const Text('Agregar bloque', style: TextStyle(color: orangeColor, fontWeight: FontWeight.w600)),
                            )
                          ] else
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 4, bottom: 8),
                                child: Text('Día libre', style: TextStyle(color: Colors.grey, fontSize: 13)),
                              ),
                            )
                        ],
                      ),
                    );
                  },
                )),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            text: 'Enviar para aprobación',
            onPressed: () => c.submitForApproval(),
          ),
        ),
      ],
    );
  }
}