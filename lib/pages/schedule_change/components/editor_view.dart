import 'package:asist_app/configs/theme.dart';
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

    // Uso del color institucional extraído de tus tokens de diseño
    const brandColor = AppColors.chart1; 

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
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: cs.onSurfaceVariant,
                letterSpacing: 0.5,
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
                            color: isSelected ? brandColor : cs.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? brandColor.withOpacity(0.05)
                              : cs.surfaceContainerLowest,
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${hours}h',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? brandColor : cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'semanales',
                              style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? brandColor
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

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
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Bloques de Horarios por Día
            ...c.weeklySchedule.entries.map((entry) {
              final dayKey = entry.key;
              final daySchedule = entry.value;

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
                          activeColor: brandColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (daySchedule.enabled)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...List.generate(
                            daySchedule.blocks.length,
                            (blockIndex) {
                              final block = daySchedule.blocks[blockIndex];
                              final isWork = block.type == BlockType.work;

                              final blockBg = cs.surfaceContainerLowest;
                              final blockBorder = cs.outlineVariant;
                              final labelBg = isWork
                                  ? brandColor
                                  : cs.surfaceContainerHighest;
                              final labelTextColor = isWork 
                                  ? cs.onPrimary 
                                  : cs.onSurfaceVariant;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: blockBg,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: blockBorder),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () => _showBlockTypeModal(context, c, dayKey, blockIndex, isWork, brandColor),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: labelBg,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isWork
                                                    ? Icons.work_rounded
                                                    : Icons.local_cafe_rounded,
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
                                        color: cs.onSurfaceVariant.withOpacity(0.4),
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
                                        color: cs.error.withOpacity(0.8),
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
                          OutlinedButton.icon(
                            onPressed: () => c.addBlock(dayKey),
                            icon: Icon(Icons.add, color: cs.onSurfaceVariant, size: 18),
                            label: Text(
                              'Agregar bloque',
                              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: cs.outlineVariant),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                          color: cs.onSurfaceVariant.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Botón con el color institucional
            Theme(
              data: theme.copyWith(
                colorScheme: cs.copyWith(primary: brandColor),
              ),
              child: PrimaryButton(
                text: 'Enviar para aprobación',
                onPressed: () => c.submitForApproval(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }

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
}
