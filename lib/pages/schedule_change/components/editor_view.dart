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
    final cs = theme.colorScheme;

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
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tu jefe deberá aprobar tu propuesta',
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurfaceVariant,
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
                color: cs.onSurfaceVariant,
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
                            color: isSelected ? cs.primary : cs.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? cs.primary.withOpacity(0.08)
                              : Colors.transparent,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${hours}h',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? cs.primary : cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'semanales',
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? cs.primary
                                    : cs.onSurfaceVariant,
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

            // Status box
            if (c.isScheduleComplete)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xff10b981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xff10b981).withOpacity(0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Color(0xff10b981), size: 20),
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
                              color: cs.onSurfaceVariant,
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
                  color: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: cs.onSurfaceVariant, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Completa tu horario con los bloques necesarios',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: cs.onSurfaceVariant,
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
                color: cs.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),

            // Días de la semana
            ...c.weeklySchedule.entries.map((entry) {
              final dayKey = entry.key;
              final daySchedule = entry.value;

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
                            color: cs.onSurface,
                          ),
                        ),
                        Switch(
                          value: daySchedule.enabled,
                          onChanged: (value) => c.toggleDay(dayKey, value),
                          activeColor: cs.primary,
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

                              // Colores semánticos adaptados al tema
                              final blockBg = isWork
                                  ? cs.primaryContainer
                                  : cs.surfaceContainerHigh;
                              final blockBorder = isWork
                                  ? cs.primary.withOpacity(0.25)
                                  : cs.outlineVariant;
                              final labelBg = isWork
                                  ? cs.primary
                                  : cs.onSurfaceVariant;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: blockBg,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: blockBorder),
                                  ),
                                  child: Row(
                                    children: [
                                      // Label tipo de bloque
                                      GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor:
                                                cs.surfaceContainerLow,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(20)),
                                            ),
                                            builder: (ctx) => Container(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    'Tipo de bloque',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 16,
                                                      color: cs.onSurface,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  // Opción Trabajo
                                                  GestureDetector(
                                                    onTap: () {
                                                      c.changeBlockType(dayKey,
                                                          blockIndex,
                                                          BlockType.work);
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      decoration: BoxDecoration(
                                                        color: isWork
                                                            ? cs.primaryContainer
                                                            : cs.surfaceContainerHigh,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color: isWork
                                                              ? cs.primary
                                                              : cs.outlineVariant,
                                                          width:
                                                              isWork ? 2 : 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons.work_outline,
                                                              color: cs.primary,
                                                              size: 24),
                                                          const SizedBox(
                                                              width: 12),
                                                          Expanded(
                                                            child: Text(
                                                              'Trabajo',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: cs
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          if (isWork)
                                                            Icon(Icons.check,
                                                                color:
                                                                    cs.primary),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  // Opción Refrigerio
                                                  GestureDetector(
                                                    onTap: () {
                                                      c.changeBlockType(
                                                          dayKey,
                                                          blockIndex,
                                                          BlockType.breakTime);
                                                      Get.back();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              14),
                                                      decoration: BoxDecoration(
                                                        color: !isWork
                                                            ? cs.surfaceContainerHighest
                                                            : cs.surfaceContainerHigh,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                          color: !isWork
                                                              ? cs.onSurfaceVariant
                                                              : cs.outlineVariant,
                                                          width:
                                                              !isWork ? 2 : 1,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .local_cafe_outlined,
                                                              color: cs
                                                                  .onSurfaceVariant,
                                                              size: 24),
                                                          const SizedBox(
                                                              width: 12),
                                                          Expanded(
                                                            child: Text(
                                                              'Refrigerio',
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14,
                                                                color: cs
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                          ),
                                                          if (!isWork)
                                                            Icon(Icons.check,
                                                                color: cs
                                                                    .onSurfaceVariant),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Get.back(),
                                                    child: Text(
                                                      'Cancelar',
                                                      style: TextStyle(
                                                          color: cs
                                                              .onSurfaceVariant),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: labelBg,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isWork
                                                    ? Icons.work_outline
                                                    : Icons.local_cafe_outlined,
                                                color: isWork
                                                    ? cs.onPrimary
                                                    : cs.surface,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                isWork ? 'Trabajo' : 'Refrig.',
                                                style: TextStyle(
                                                  color: isWork
                                                      ? cs.onPrimary
                                                      : cs.surface,
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      // Input hora inicio
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => c.editBlockTime(
                                              dayKey, blockIndex),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: cs.surfaceContainerLowest,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: cs.outlineVariant),
                                            ),
                                            child: Text(
                                              block.start,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: cs.onSurface,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: cs.onSurfaceVariant
                                            .withOpacity(0.5),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      // Input hora fin
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () => c.editBlockTime(
                                              dayKey, blockIndex),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: cs.surfaceContainerLowest,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: cs.outlineVariant),
                                            ),
                                            child: Text(
                                              block.end,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                                color: cs.onSurface,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(
                                            Icons.delete_outline,
                                            size: 20),
                                        color: cs.error.withOpacity(0.7),
                                        onPressed: () =>
                                            c.removeBlock(dayKey, blockIndex),
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
                              icon: Icon(Icons.add, color: cs.onSurfaceVariant),
                              label: Text(
                                'Agregar bloque',
                                style:
                                    TextStyle(color: cs.onSurfaceVariant),
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