import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/primary_button.dart';
import '../schedule_change_controller.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ScheduleChangeController>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Saludo
          Text(
            'Buenos días, Juan',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),

          // Icono de estado
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 50,
                color: Colors.orange,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Estado
          Center(
            child: Column(
              children: [
                Text(
                  'Horario en revisión',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu propuesta de horario fue enviada correctamente. Estamos esperando la aprobación del área.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Pasos del proceso
          _buildStatusStep(
            context,
            icon: Icons.check_circle,
            title: 'Horario enviado',
            subtitle: 'Lunes',
            isCompleted: true,
          ),
          const SizedBox(height: 12),
          _buildStatusStep(
            context,
            icon: Icons.assignment_ind,
            title: 'Revisión del área',
            subtitle: 'Pendiente de sincronización',
            isCompleted: false,
          ),
          const SizedBox(height: 12),
          _buildStatusStep(
            context,
            icon: Icons.event_available,
            title: 'Horario activo',
            subtitle: 'Pendiente',
            isCompleted: false,
          ),
          const SizedBox(height: 20),

          // Notificación
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.mail_outline, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Te notificaremos al correo institucional cuando sea aprobado.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botones de acción
          PrimaryButton(
            text: 'Volver al inicio',
            onPressed: () => Get.offAllNamed('/home'),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: 'Editar solicitud',
            variant: PrimaryButtonVariant.secondary,
            onPressed: () => c.isSubmitted.value = false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
  }) {
    final theme = Theme.of(context);
    final statusColor = isCompleted ? const Color(0xff10b981) : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: statusColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isCompleted)
            const Icon(Icons.check, color: Color(0xff10b981), size: 20),
        ],
      ),
    );
  }
}