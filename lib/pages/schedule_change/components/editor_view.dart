import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/info_card.dart';
import '../../../components/number_stepper.dart';
import '../../../components/primary_button.dart';
import '../../../components/schedule_card.dart';
import '../../../components/status_badge.dart';
import '../../../models/schedule.dart';
import '../schedule_change_controller.dart';

class EditorView extends StatelessWidget {
  const EditorView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ScheduleChangeController>();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Solicitud de cambio de horario',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                StatusBadge(status: BadgeStatus.pending),
              ],
            ),
            const SizedBox(height: 12),
            InfoCard(
              title: 'Resumen del cambio',
              rows: [
                InfoRowData(
                  icon: Icons.schedule,
                  label: 'Horas semanales objetivo',
                  value: '${c.selectedTargetHours.value} h',
                ),
                InfoRowData(
                  icon: Icons.access_time,
                  label: 'Total semanal estimado',
                  value: fmtMins(c.totalWeeklyWorkMins),
                ),
                InfoRowData(
                  icon: Icons.check_circle,
                  label: 'Estado del horario',
                  value: c.isScheduleComplete ? 'Horario completo' : 'Pendiente de ajustar',
                ),
              ],
            ),
            const SizedBox(height: 16),
            NumberStepper(
              icon: Icons.hourglass_bottom,
              title: 'Horas semanales',
              value: c.selectedTargetHours.value,
              valueLabel: 'objetivo',
              canDecrease: c.selectedTargetHours.value > c.hourOptions.first,
              canIncrease: c.selectedTargetHours.value < c.hourOptions.last,
              onDecrease: () {
                final currentIndex = c.hourOptions.indexOf(c.selectedTargetHours.value);
                if (currentIndex > 0) {
                  c.selectedTargetHours.value = c.hourOptions[currentIndex - 1];
                }
              },
              onIncrease: () {
                final currentIndex = c.hourOptions.indexOf(c.selectedTargetHours.value);
                if (currentIndex < c.hourOptions.length - 1) {
                  c.selectedTargetHours.value = c.hourOptions[currentIndex + 1];
                }
              },
            ),
            const SizedBox(height: 16),
            ScheduleCard(
              schedule: c.weeklySchedule,
              expandedDay: c.expandedDay,
              onToggleDay: (index) {
                c.expandedDay.value = c.expandedDay.value == index ? null : index;
              },
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              text: 'Enviar para aprobación',
              onPressed: () => c.submitForApproval(),
            ),
          ],
        );
      }),
    );
  }
}