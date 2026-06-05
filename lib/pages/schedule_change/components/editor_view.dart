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

<<<<<<< Updated upstream
=======
    // Uso del color institucional extraído de tus tokens de diseño
    const brandColor = AppColors.chart1; 

>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
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
=======
            // PASO 2 - Título Informativo
            Text(
              'PASO 2 — BLOQUES HORARIOS POR DÍA',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Agrega los bloques que necesites. Toca Trabajo o Refrigerio para cambiar el tipo. Solo un refrigerio por día.',
              style: TextStyle(
                fontSize: 11,
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta de estado reactiva y dinámica (Muestra completado o faltante)
            Obx(() {
              final targetHours = c.selectedTargetHours.value;
              final currentHours = c.currentWeeklyWorkHours;
              final isComplete = c.isScheduleComplete;
              final missingHours = c.missingHours;

              final successColor = const Color(0xff10b981); 
              
              final containerBg = isComplete 
                  ? successColor.withOpacity(0.06) 
                  : cs.surfaceContainerHigh;
                  
              final containerBorder = isComplete 
                  ? successColor.withOpacity(0.3) 
                  : cs.outlineVariant;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: containerBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: containerBorder, width: 1.5),
>>>>>>> Stashed changes
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
<<<<<<< Updated upstream
                        const Icon(Icons.check_circle,
                            color: Color(0xff10b981), size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          '¡Horario completo!',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Color(0xff10b981),
=======
                        Row(
                          children: [
                            Icon(
                              isComplete ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                              color: isComplete ? successColor : cs.onSurfaceVariant,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isComplete 
                                  ? '¡Horario completo!' 
                                  : 'Te faltan ${missingHours % 1 == 0 ? missingHours.toInt() : missingHours.toStringAsFixed(1)}h',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: isComplete ? successColor : cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurfaceVariant.withOpacity(0.4),
                            ),
                            children: [
                              TextSpan(
                                text: '${currentHours % 1 == 0 ? currentHours.toInt() : currentHours.toStringAsFixed(1)}h',
                                style: TextStyle(color: isComplete ? successColor : cs.onSurface),
                              ),
                              const TextSpan(text: '  /  '),
                              TextSpan(text: '${targetHours}h'),
                            ],
>>>>>>> Stashed changes
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
<<<<<<< Updated upstream
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
=======

                    // Barra de progreso adaptada
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (currentHours / targetHours).clamp(0.0, 1.0),
                        backgroundColor: isComplete ? successColor.withOpacity(0.1) : cs.outlineVariant.withOpacity(0.5),
                        color: isComplete ? successColor : brandColor,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Grilla resumen de días de la semana
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB'].map((dayName) {
                        final String fullDayKey = _mapAbbreviationToKey(dayName);
                        final dayData = c.weeklySchedule[fullDayKey];
                        
                        String hoursText = '—';
                        bool hasHours = false;

                        if (dayData != null && dayData.enabled && dayData.blocks.isNotEmpty) {
                          final double dayHours = c.dayWorkMins(dayData) / 60;
                          if (dayHours > 0) {
                            hoursText = '${dayHours % 1 == 0 ? dayHours.toInt() : dayHours.toStringAsFixed(1)}h';
                            hasHours = true;
                          }
                        }

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: cs.outlineVariant.withOpacity(0.8)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    dayName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: cs.onSurfaceVariant.withOpacity(0.5),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    hoursText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: hasHours ? (isComplete ? successColor : brandColor) : cs.outline,
                                    ),
                                  ),
                                ],
                              ),
>>>>>>> Stashed changes
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
<<<<<<< Updated upstream
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
=======
              );
            }),
            const SizedBox(height: 24),
>>>>>>> Stashed changes

            // Bloques de Horarios por Día
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

<<<<<<< Updated upstream
            // Submit button
            PrimaryButton(
              text: 'Enviar para aprobación',
              onPressed: () => c.submitForApproval(),
=======
            // Botón con el color institucional
            Theme(
              data: theme.copyWith(
                colorScheme: cs.copyWith(primary: brandColor),
              ),
              child: PrimaryButton(
                text: 'Enviar para aprobación',
                onPressed: () => c.submitForApproval(),
              ),
>>>>>>> Stashed changes
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }
<<<<<<< Updated upstream
=======

  void _showBlockTypeModal(BuildContext context, ScheduleChangeController c, String dayKey, int blockIndex, bool isWork, Color brandColor) {
    final cs = Theme.of(context).colorScheme;
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
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: cs.onSurface),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.work_outline, color: isWork ? brandColor : cs.onSurfaceVariant),
              title: Text('Trabajo', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
              trailing: isWork ? Icon(Icons.check_circle, color: brandColor) : null,
              onTap: () {
                c.changeBlockType(dayKey, blockIndex, BlockType.work);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.local_cafe_outlined, color: !isWork ? brandColor : cs.onSurfaceVariant),
              title: Text('Refrigerio', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
              trailing: !isWork ? Icon(Icons.check_circle, color: brandColor) : null,
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

  String _mapAbbreviationToKey(String crypto) {
    switch (crypto) {
      case 'LUN': return 'Lunes';
      case 'MAR': return 'Martes';
      case 'MIÉ': return 'Miércoles';
      case 'JUE': return 'Jueves';
      case 'VIE': return 'Viernes';
      case 'SÁB': return 'Sábado';
      default: return 'Lunes';
    }
  }
>>>>>>> Stashed changes
}