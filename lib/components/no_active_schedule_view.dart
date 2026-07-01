import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/routes.dart';
import '../models/schedule.dart';
import 'primary_button.dart';

class NoActiveScheduleView extends StatelessWidget {
  final Schedule? schedule;
  final Future<void> Function()? onReturn;

  const NoActiveScheduleView({super.key, required this.schedule, this.onReturn});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bool isPending = schedule?.status == 'pending';
    final bool isRejected = schedule?.status == 'rejected';

    final IconData icon = isPending
        ? Icons.hourglass_top_rounded
        : (isRejected ? Icons.error_outline_rounded : Icons.calendar_month_rounded);

    final String title = isPending
        ? 'Tu horario está en revisión'
        : (isRejected ? 'Tu horario fue rechazado' : 'Aún no tienes un horario');

    final String subtitle = isPending
        ? 'Tu jefe debe aprobar tu horario antes de que puedas usar esta sección.'
        : (isRejected
            ? 'Tu jefe rechazó tu propuesta. Configura uno nuevo.'
            : 'Configura tu horario semanal para empezar.');

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
          if (!isPending) ...[
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
