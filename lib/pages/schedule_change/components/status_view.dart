import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/primary_button.dart';
import '../../../configs/routes.dart';
import '../schedule_change_controller.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ScheduleChangeController>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Inyección limpia del color naranja corporativo
    const brandColor = AppColors.chart1;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Buenos días, Juan 👋',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 32),

          // Círculo de estado en tono institucional
          Center(
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: brandColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_rounded,
                size: 44,
                color: brandColor,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Estado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'Horario en revisión',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu propuesta de horario fue enviada correctamente. Estamos esperando la aprobación del área.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: cs.onSurfaceVariant,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          _buildStatusStep(
            context,
            icon: Icons.check_circle_rounded,
            title: 'Horario enviado',
            subtitle: 'Recibido por el sistema',
            statusText: 'Listo',
            isCompleted: true,
            isActive: false,
            brandColor: brandColor,
          ),
          const SizedBox(height: 12),
          _buildStatusStep(
            context,
            icon: Icons.hourglass_empty_rounded,
            title: 'Revisión del área',
            subtitle: 'Pendiente de aprobación',
            statusText: 'En curso',
            isCompleted: false,
            isActive: true,
            brandColor: brandColor,
          ),
          const SizedBox(height: 12),
          _buildStatusStep(
            context,
            icon: Icons.event_available_rounded,
            title: 'Horario activo',
            subtitle: 'Disponible tras aprobación',
            statusText: 'Pendiente',
            isCompleted: false,
            isActive: false,
            brandColor: brandColor,
          ),
          const SizedBox(height: 24),

          // Alerta Informativa Institucional
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: brandColor.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: brandColor.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.mail_outline_rounded,
                  color: brandColor,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                        height: 1.3,
                      ),
                      children: [
                        const TextSpan(text: 'Te notificaremos al '),
                        TextSpan(
                          text: 'correo institucional',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: brandColor,
                          ),
                        ),
                        const TextSpan(text: ' cuando sea aprobado.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Envoltura del tema para obligar a los botones a heredar el color institucional
          Theme(
            data: theme.copyWith(colorScheme: cs.copyWith(primary: brandColor)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PrimaryButton(
                  text: 'Volver al inicio',
                  onPressed: () => Get.offAllNamed(AppRoutes.root),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  text: 'Editar solicitud',
                  variant: PrimaryButtonVariant.secondary,
                  onPressed: () => c.isSubmitted.value = false,
                ),
              ],
            ),
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
    required String statusText,
    required bool isCompleted,
    required bool isActive,
    required Color brandColor,
  }) {
    final cs = Theme.of(context).colorScheme;

    final Color stepColor = isCompleted
        ? const Color(0xff10b981)
        : (isActive ? brandColor : cs.onSurfaceVariant.withOpacity(0.4));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? brandColor.withOpacity(0.3) : cs.outlineVariant,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: stepColor, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: isActive
                        ? cs.onSurface
                        : cs.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: stepColor,
            ),
          ),
        ],
      ),
    );
  }
}
