import 'package:flutter/material.dart';

import '../../configs/theme.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color background =
        isDark ? const Color(0xff0f1117) : const Color(0xfff7f8fa);
    final Color cardColor = isDark ? const Color(0xff1A1D27) : Colors.white;
    final Color textColor = isDark ? Colors.white : AppColors.foreground;
    final Color mutedColor =
        isDark ? const Color(0xff9ca3af) : AppColors.mutedForeground;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.chevron_left_rounded, color: textColor),
                    Text(
                      'Mi historial',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 28),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MonthButton(icon: Icons.chevron_left_rounded),
                    Text(
                      'Abril 2025',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    _MonthButton(icon: Icons.chevron_right_rounded),
                  ],
                ),
                const SizedBox(height: 18),
                _HistoryItem(
                  date: 'Lun 28 abril',
                  status: 'Puntual',
                  statusColor: const Color(0xff22c55e),
                  time: 'Entrada: 08:12 AM  Salida: 05:00 PM',
                  hours: '8h 45min',
                  cardColor: cardColor,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                _HistoryItem(
                  date: 'Vie 25 abril',
                  status: 'Tardanza',
                  statusColor: AppColors.chart1,
                  time: 'Entrada: 08:23 AM  Salida: 05:00 PM',
                  hours: '8h 34min',
                  cardColor: cardColor,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                _HistoryItem(
                  date: 'Jue 24 abril',
                  status: 'Puntual',
                  statusColor: const Color(0xff22c55e),
                  time: 'Entrada: 08:05 AM  Salida: 05:00 PM',
                  hours: '8h 52min',
                  cardColor: cardColor,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                _HistoryItem(
                  date: 'Mié 23 abril',
                  status: 'Puntual',
                  statusColor: const Color(0xff22c55e),
                  time: 'Entrada: 08:09 AM  Salida: 05:00 PM',
                  hours: '8h 49min',
                  cardColor: cardColor,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                _HistoryItem(
                  date: 'Mar 22 abril',
                  status: 'Puntual',
                  statusColor: const Color(0xff22c55e),
                  time: 'Entrada: 08:00 AM  Salida: 05:00 PM',
                  hours: '9h 00m',
                  cardColor: cardColor,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
                _HistoryItem(
                  date: 'Lun 21 abril',
                  status: 'Puntual',
                  statusColor: const Color(0xff22c55e),
                  time: 'Entrada: 08:07 AM  Salida: 05:00 PM',
                  hours: '8h 51min',
                  cardColor: cardColor,
                  textColor: textColor,
                  mutedColor: mutedColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthButton extends StatelessWidget {
  final IconData icon;

  const _MonthButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 22),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String date;
  final String status;
  final Color statusColor;
  final String time;
  final String hours;
  final Color cardColor;
  final Color textColor;
  final Color mutedColor;

  const _HistoryItem({
    required this.date,
    required this.status,
    required this.statusColor,
    required this.time,
    required this.hours,
    required this.cardColor,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StatusPill(
                      text: status,
                      color: statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(
                    color: mutedColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xff9ca3af),
          ),
          const SizedBox(width: 6),
          Text(
            hours,
            style: const TextStyle(
              color: AppColors.chart1,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusPill({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '• $text',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}