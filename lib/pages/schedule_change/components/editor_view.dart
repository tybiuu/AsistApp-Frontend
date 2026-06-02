import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/primary_button.dart';
import '../../../models/schedule.dart';
import '../schedule_change_controller.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ScheduleChangeController>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (c.isLoading.value) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              'Configura tu horario',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tu jefe deberá aprobar tu propuesta',
              style: TextStyle(
                fontSize: 13,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // PASO 1 - Modalidad de horas semanales
            Text(
              'PASO 1 — MODALIDAD DE HORAS SEMANALES',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: c.hourOptions.map((hours) {
                final isSelected = c.selectedTargetHours.value == hours;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => c.selectedTargetHours.value = hours,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected ? Colors.orange : theme.colorScheme.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected ? Colors.orange.withOpacity(0.08) : Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${hours}h',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.orange : theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'semanales',
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected ? Colors.orange : theme.colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Status box - Horario completo o pendiente
            if (c.isScheduleComplete)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xff10b981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xff10b981).withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xff10b981), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          '¡Horario completo!',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Color(0xff10b981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${c.selectedTargetHours.value}h',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Color(0xff10b981),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${c.selectedTargetHours.value}h',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Completa tu horario con los bloques necesarios',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.amber.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),

            // PASO 2 - Bloques horarios por día
            Text(
              'PASO 2 — BLOQUES HORARIOS POR DÍA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // Días de la semana
            ...c.weeklySchedule.entries.map((entry) {
              final dayKey = entry.key;
              final daySchedule = entry.value;
              final dayIndex = c.weeklySchedule.keys.toList().indexOf(dayKey);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Day header con toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dayKey,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Switch(
                          value: daySchedule.enabled,
                          onChanged: (value) => c.toggleDay(dayKey, value),
                          activeColor: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Bloques
                    if (daySchedule.enabled)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...List.generate(
                            daySchedule.blocks.length,
                            (blockIndex) {
                              final block = daySchedule.blocks[blockIndex];
                              final isWork = block.type == BlockType.work;
                              final bgColor = isWork ? Colors.orange.withOpacity(0.12) : Colors.grey.withOpacity(0.08);
                              final labelBgColor = isWork ? Colors.orange : Colors.grey.shade400;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: bgColor,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: isWork 
                                        ? Colors.orange.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            builder: (ctx) => Container(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  const Text(
                                                    'Tipo de bloque',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w800,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  GestureDetector(
                                                    onTap: () {
                                                      c.changeBlockType(dayKey, blockIndex, BlockType.work);
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                        color: isWork ? Colors.orange.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(
                                                          color: isWork ? Colors.orange : Colors.grey.withOpacity(0.2),
                                                          width: isWork ? 2 : 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.work_outline, color: Colors.orange, size: 24),
                                                          const SizedBox(width: 12),
                                                          const Expanded(
                                                            child: Text(
                                                              'Trabajo',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          if (isWork) const Icon(Icons.check, color: Colors.orange),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  GestureDetector(
                                                    onTap: () {
                                                      c.changeBlockType(dayKey, blockIndex, BlockType.breakTime);
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                        color: !isWork ? Colors.grey.withOpacity(0.1) : Colors.grey.withOpacity(0.05),
                                                        borderRadius: BorderRadius.circular(12),
                                                        border: Border.all(
                                                          color: !isWork ? Colors.grey.shade400 : Colors.grey.withOpacity(0.2),
                                                          width: !isWork ? 2 : 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.local_cafe_outlined, color: Colors.grey.shade400, size: 24),
                                                          const SizedBox(width: 12),
                                                          const Expanded(
                                                            child: Text(
                                                              'Refrigerio',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.w700,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                          if (!isWork) Icon(Icons.check, color: Colors.grey.shade400),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextButton(
                                                    onPressed: () => Get.back(),
                                                    child: const Text('Cancelar'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: labelBgColor,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isWork ? Icons.work_outline : Icons.local_cafe_outlined,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                isWork ? 'Trabajo' : 'Refrig.',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 11,
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
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.2),
                                              ),
                                            ),
                                            child: Text(
                                              block.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: theme.colorScheme.onSurface,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.grey.withOpacity(0.5),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => c.editBlockTime(dayKey, blockIndex),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.withOpacity(0.2),
                                              ),
                                            ),
                                            child: Text(
                                              block.end,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: theme.colorScheme.onSurface,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 20),
                                        color: Colors.red.withOpacity(0.6),
                                        onPressed: () => c.removeBlock(dayKey, blockIndex),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => c.addBlock(dayKey),
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar bloque'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Submit button
            PrimaryButton(
              text: 'Enviar para aprobación',
              onPressed: () => c.submitForApproval(),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }
}