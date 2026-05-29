import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/theme.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  Future<List<dynamic>> _loadRecords() async {
    final jsonString =
        await rootBundle.loadString('assets/jsons/mock_attendance_records.json');
    return jsonDecode(jsonString) as List<dynamic>;
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;

    final day = parts[2];
    final month = parts[1];

    const months = {
      '01': 'ene',
      '02': 'feb',
      '03': 'mar',
      '04': 'abr',
      '05': 'may',
      '06': 'jun',
      '07': 'jul',
      '08': 'ago',
      '09': 'sep',
      '10': 'oct',
      '11': 'nov',
      '12': 'dic',
    };

    return '$day ${months[month] ?? month}';
  }

  String _formatTime(dynamic value) {
    if (value == null) return '--:--';
    final text = value.toString();
    if (text.length < 16) return '--:--';

    final hour = int.tryParse(text.substring(11, 13)) ?? 0;
    final minute = text.substring(14, 16);
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

    return '${hour12.toString().padLeft(2, '0')}:$minute $suffix';
  }

  String _statusText(Map<String, dynamic> record) {
    if (record['status'] == 'absence') return 'Inasistencia';
    if (record['status'] == 'pending') return 'Pendiente';

    final lateMinutes = record['late_minutes'];
    if (lateMinutes != null && lateMinutes > 0) return 'Tardanza';

    return 'Puntual';
  }

  Color _statusColor(String status) {
    if (status == 'Puntual') return const Color(0xff22c55e);
    if (status == 'Tardanza') return AppColors.chart1;
    if (status == 'Inasistencia') return const Color(0xffef4444);
    return const Color(0xff3b82f6);
  }

  String _hoursText(dynamic totalMinutes) {
    if (totalMinutes == null) return '--';
    final minutes = totalMinutes as int;
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m.toString().padLeft(2, '0')}min';
  }

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
            child: FutureBuilder<List<dynamic>>(
              future: _loadRecords(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar registros',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                final records = snapshot.data ?? [];

                return ListView(
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
                          'Mayo 2026',
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

                    ...records.map((item) {
                      final record = item as Map<String, dynamic>;
                      final status = _statusText(record);
                      final color = _statusColor(status);

                      return _HistoryItem(
                        date: _formatDate(record['date'].toString()),
                        status: status,
                        statusColor: color,
                        time:
                            'Entrada: ${_formatTime(record['check_in'])}  Salida: ${_formatTime(record['check_out'])}',
                        hours: _hoursText(record['total_minutes']),
                        cardColor: cardColor,
                        textColor: textColor,
                        mutedColor: mutedColor,
                      );
                    }),
                  ],
                );
              },
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
                _StatusPill(text: status, color: statusColor),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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