import 'package:flutter/material.dart';

import '../../configs/theme.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color background =
        isDark ? const Color(0xff0f1117) : const Color(0xfff7f8fa);

    final Color cardColor =
        isDark ? const Color(0xff1A1D27) : Colors.white;

    final Color textColor =
        isDark ? Colors.white : AppColors.foreground;

    final Color mutedColor =
        isDark ? const Color(0xff9ca3af) : AppColors.mutedForeground;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asistencia',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Lunes 28 de abril',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _InfoBlock(
                                title: 'Organización',
                                value: 'ITLAB',
                                valueColor: textColor,
                              ),
                            ),
                            Expanded(
                              child: _InfoBlock(
                                title: 'Tu horario hoy',
                                value: '8:00 AM - 5:00 PM',
                                valueColor: textColor,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: const [
                              _ScheduleTag(
                                '8:00 AM - 1:00 PM · Trabajo',
                                Color(0xffffedd5),
                                AppColors.chart1,
                              ),
                              _ScheduleTag(
                                '1:00 PM - 2:00 PM · Refrigerio',
                                Color(0xffe5e7eb),
                                Color(0xff6b7280),
                              ),
                              _ScheduleTag(
                                '2:00 PM - 5:00 PM · Trabajo',
                                Color(0xffffedd5),
                                AppColors.chart1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'PROGRESO DEL DÍA',
                    style: TextStyle(
                      color: mutedColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        _ProgressItem(
                          icon: Icons.check,
                          color: AppColors.chart1,
                          title: 'Ingreso',
                          status: 'Confirmado',
                        ),
                        SizedBox(height: 18),
                        _ProgressItem(
                          icon: Icons.free_breakfast,
                          color: Color(0xfff59e0b),
                          title: 'Sal. refrigerio',
                          status: 'Pendiente',
                        ),
                        SizedBox(height: 18),
                        _ProgressItem(
                          icon: Icons.replay,
                          color: Color(0xff9ca3af),
                          title: 'Ret. refrigerio',
                          status: '-',
                        ),
                        SizedBox(height: 18),
                        _ProgressItem(
                          icon: Icons.logout,
                          color: Color(0xff9ca3af),
                          title: 'Salida',
                          status: '-',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      '09:34:36',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Hora actual del sistema',
                      style: TextStyle(
                        color: mutedColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.free_breakfast),
                      label: const Text(
                        'MARCAR SALIDA A REFRIGERIO',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffff9f1c),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;

  const _InfoBlock({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ScheduleTag extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _ScheduleTag(this.text, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String status;

  const _ProgressItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(.15),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(status),
      ],
    );
  }
}