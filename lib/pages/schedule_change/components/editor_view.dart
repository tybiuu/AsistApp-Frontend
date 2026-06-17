import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/primary_button.dart';
import '../schedule_change_controller.dart';
import 'day_schedule_section.dart';
import 'hours_selector_row.dart';
import 'weekly_progress_card.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ScheduleChangeController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
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
            HoursSelectorRow(
              options: c.hourOptions,
              selectedHours: c.selectedTargetHours.value,
              onSelect: (h) => c.selectedTargetHours.value = h,
              brandColor: brandColor,
            ),
            const SizedBox(height: 24),
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
            WeeklyProgressCard(c: c, brandColor: brandColor),
            const SizedBox(height: 24),
            ...c.weeklySchedule.entries.map(
              (entry) => DayScheduleSection(
                dayKey: entry.key,
                daySchedule: entry.value,
                c: c,
                brandColor: brandColor,
              ),
            ),
            const SizedBox(height: 24),
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
}
