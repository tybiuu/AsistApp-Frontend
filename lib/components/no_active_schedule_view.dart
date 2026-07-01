import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/routes.dart';
import '../models/schedule.dart';
import 'primary_button.dart';

class NoActiveScheduleView extends StatelessWidget {
  final Schedule? schedule;
  final Future<void> Function()? onReturn;
  final bool isOwnSchedule;

  const NoActiveScheduleView({
    super.key,
    required this.schedule,
    this.onReturn,
    this.isOwnSchedule = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool isPending = schedule?.status == 'pending';
    final bool isRejected = schedule?.status == 'rejected';

    final IconData icon = isPending
        ? Icons.hourglass_top_rounded
        : (isRejected ? Icons.error_outline_rounded : Icons.calendar_month_rounded);

    final String title = isPending
        ? (isOwnSchedule ? 'Tu horario está en revisión' : 'Horario en revisión')
        : (isRejected
            ? (isOwnSchedule ? 'Tu horario fue rechazado' : 'Horario rechazado')
            : (isOwnSchedule ? 'Aún no tienes un horario' : 'Aún no tiene un horario'));

    final String subtitle = isPending
        ? (isOwnSchedule
            ? 'Tu jefe debe aprobar tu horario antes de que puedas usar esta sección.'
            : 'Está esperando la aprobación del jefe.')
        : (isRejected
            ? (isOwnSchedule
                ? 'Tu jefe rechazó tu propuesta. Configura uno nuevo.'
                : 'Su propuesta fue rechazada y todavía no configuró una nueva.')
            : (isOwnSchedule
                ? 'Configura tu horario semanal para empezar.'
                : 'Todavía no configuró su horario semanal.'));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: colors.primary.withValues(alpha: 0.6)),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          if (!isPending && isOwnSchedule) ...[
            const SizedBox(height: 24),
            PrimaryButton(
              text: isRejected ? 'Reconfigurar horario' : 'Configurar horario',
              onPressed: () async {
                await Get.toNamed(AppRoutes.scheduleChange);
                if (onReturn != null) await onReturn!();
              },
            ),
          ],
        ],
      ),
    );
  }
}
