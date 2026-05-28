import 'package:flutter/material.dart';

class StatusView extends StatelessWidget {
  const StatusView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const orangeColor = Color(0xffe15d27);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: orangeColor.withOpacity(0.1),
              ),
              child: const Icon(Icons.calendar_month_rounded, size: 48, color: orangeColor),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Horario en revisión',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu propuesta de horario fue enviada correctamente. Estamos esperando la aprobación del área.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 32),

          _buildStatusItem(
            context,
            title: 'Horario enviado',
            subtitle: 'Recibido por el sistema',
            badgeText: 'Listo',
            badgeColor: const Color(0xff10b981),
          ),
          _buildStatusItem(
            context,
            title: 'Revisión del área',
            subtitle: 'Pendiente de aprobación',
            badgeText: 'En curso',
            badgeColor: orangeColor,
          ),
          _buildStatusItem(
            context,
            title: 'Horario activo',
            subtitle: 'Disponible tras aprobación',
            badgeText: 'Pendiente',
            badgeColor: Colors.grey,
          ),

          const Spacer(),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: orangeColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: orangeColor.withOpacity(0.15)),
            ),
            child: Row(
              children: [
                const Icon(Icons.mail_outline_rounded, color: orangeColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13, height: 1.3),
                      children: const [
                        TextSpan(text: 'Te notificaremos al '),
                        TextSpan(text: 'correo institucional', style: TextStyle(fontWeight: FontWeight.bold, color: orangeColor)),
                        TextSpan(text: ' cuando sea aprobado.'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          )
        ],
      ),
    );
  }
}