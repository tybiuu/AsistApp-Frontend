import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/info_card.dart';
import '../../../components/primary_button.dart';
import '../../../components/status_badge.dart';
import '../schedule_change_controller.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ScheduleChangeController>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Cambio de horario enviado',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              StatusBadge(status: BadgeStatus.pending),
            ],
          ),
          const SizedBox(height: 12),
          InfoCard(
            title: 'Estado de la solicitud',
            rows: [
              InfoRowData(
                icon: Icons.send,
                label: 'Envío',
                value: 'Solicitud registrada',
              ),
              InfoRowData(
                icon: Icons.assignment_turned_in,
                label: 'Revisión',
                value: 'Pendiente de aprobación del equipo',
              ),
              InfoRowData(
                icon: Icons.event_available,
                label: 'Horario objetivo',
                value: '${c.selectedTargetHours.value} horas semanales',
              ),
            ],
          ),
          const SizedBox(height: 16),
          InfoCard(
            title: 'Seguimiento',
            rows: [
              InfoRowData(
                icon: Icons.notifications,
                label: 'Notificación',
                value: 'Se enviará confirmación al correo institucional',
              ),
              InfoRowData(
                icon: Icons.calendar_month,
                label: 'Próximo paso',
                value: 'El área validará el horario y actualizará el estado',
              ),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            text: 'Volver al editor',
            variant: PrimaryButtonVariant.secondary,
            onPressed: () => c.isSubmitted.value = false,
          ),
        ],
      ),
    );
  }
}