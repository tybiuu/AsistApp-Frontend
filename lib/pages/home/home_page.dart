// lib/pages/home/home_page.dart
import '../report/report_page.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../configs/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<_HomeMockData> _loadHomeData() async {
    final recordsString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_records.json',
    );

    final schedulesString = await rootBundle.loadString(
      'assets/jsons/mock_schedules.json',
    );

    final records = jsonDecode(recordsString) as List<dynamic>;
    final schedules = jsonDecode(schedulesString) as List<dynamic>;

    final schedule = schedules.first as Map<String, dynamic>;
    final days = schedule['days'] as List<dynamic>;
    final monday = days.first as Map<String, dynamic>;

    return _HomeMockData(
      records: records.cast<Map<String, dynamic>>(),
      schedule: schedule,
      todaySchedule: monday,
    );
  }

  String _formatTime(dynamic value) {
    if (value == null) return '--:--';

    final text = value.toString();

    if (text.contains('T') && text.length >= 16) {
      final hour = int.tryParse(text.substring(11, 13)) ?? 0;
      final minute = text.substring(14, 16);
      return _to12Hour(hour, minute);
    }

    final parts = text.split(':');
    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = parts[1];
      return _to12Hour(hour, minute);
    }

    return text;
  }

  String _to12Hour(int hour, String minute) {
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${hour12.toString().padLeft(2, '0')}:$minute $suffix';
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;

    const months = {
      '01': 'enero',
      '02': 'febrero',
      '03': 'marzo',
      '04': 'abril',
      '05': 'mayo',
      '06': 'junio',
      '07': 'julio',
      '08': 'agosto',
      '09': 'septiembre',
      '10': 'octubre',
      '11': 'noviembre',
      '12': 'diciembre',
    };

    return '${parts[2]} de ${months[parts[1]] ?? parts[1]}';
  }

  String _dayName(String day) {
    switch (day) {
      case 'monday':
        return 'Lunes';
      case 'tuesday':
        return 'Martes';
      case 'wednesday':
        return 'Miércoles';
      case 'thursday':
        return 'Jueves';
      case 'friday':
        return 'Viernes';
      case 'saturday':
        return 'Sábado';
      case 'sunday':
        return 'Domingo';
      default:
        return 'Lunes';
    }
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

  int _completedMinutes(List<Map<String, dynamic>> records) {
    return records.fold<int>(0, (total, record) {
      final value = record['total_minutes'];
      if (value is int) return total + value;
      return total;
    });
  }

  int _requiredMonthlyHours(Map<String, dynamic> schedule) {
    final weeklyHours = schedule['weekly_hours'];
    if (weeklyHours is int) {
      return weeklyHours * 4;
    }
    return 120;
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
            child: FutureBuilder<_HomeMockData>(
              future: _loadHomeData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error al cargar datos',
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                final data = snapshot.data!;
                final records = data.records;
                final todaySchedule = data.todaySchedule;
                final schedule = data.schedule;

                final completedMinutes = _completedMinutes(records);
                final completedHours = completedMinutes ~/ 60;
                final requiredHours = _requiredMonthlyHours(schedule);
                final progress = requiredHours == 0
                    ? 0.0
                    : (completedHours / requiredHours).clamp(0.0, 1.0);

                final confirmedCount = records
                    .where((record) => record['status'] == 'confirmed')
                    .length;
                final absenceCount = records
                    .where((record) => record['status'] == 'absence')
                    .length;
                final lateCount = records.where((record) {
                  final lateMinutes = record['late_minutes'];
                  return lateMinutes != null && lateMinutes > 0;
                }).length;

                final attendancePercent = records.isEmpty
                    ? 0
                    : ((confirmedCount / records.length) * 100).round();

                final checkIn = _formatTime(todaySchedule['check_in_time']);
                final checkOut = _formatTime(todaySchedule['check_out_time']);
                final todayLabel =
                    '${_dayName(todaySchedule['day'].toString())} 28 de abril';

                final latestRecords = records.take(2).toList();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: [
                    Text(
                      'Buenos días, Juan 👋',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Resumen de tu asistencia',
                      style: TextStyle(
                        color: mutedColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.chart1,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.chart1.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'HOY',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            todayLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Tu horario:\n$checkIn - $checkOut',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      height: 1.35,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.chart1,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Ir a marcar  →',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Este mes — Mayo',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'Ver reporte',
                          style: TextStyle(
                            color: AppColors.chart1,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Horas completadas',
                            style: TextStyle(
                              color: mutedColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${completedHours}h',
                                  style: const TextStyle(
                                    color: AppColors.chart1,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                TextSpan(
                                  text: '  de ${requiredHours}h requeridas',
                                  style: TextStyle(
                                    color: mutedColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 8,
                              backgroundColor: const Color(0xffffedd5),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.chart1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: '% Asistencia',
                            value: '$attendancePercent%',
                            subtitle: 'este mes',
                            valueColor: const Color(0xff16a34a),
                            cardColor: cardColor,
                            mutedColor: mutedColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Tardanzas',
                            value: lateCount.toString(),
                            subtitle: 'este mes',
                            valueColor: AppColors.chart1,
                            cardColor: cardColor,
                            mutedColor: mutedColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Días asistidos',
                            value: confirmedCount.toString(),
                            subtitle: 'confirmados',
                            valueColor: textColor,
                            cardColor: cardColor,
                            mutedColor: mutedColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _StatCard(
                            title: 'Inasistencias',
                            value: absenceCount.toString(),
                            subtitle: 'este mes',
                            valueColor: const Color(0xff16a34a),
                            cardColor: cardColor,
                            mutedColor: mutedColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Últimos registros',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ReportPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Ver todos',
                            style: TextStyle(
                              color: AppColors.chart1,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...latestRecords.map((record) {
                      final status = _statusText(record);
                      final color = _statusColor(status);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ReportPage(),
                              ),
                            );
                          },
                          child: _AttendanceRecord(
                          date: _formatDate(record['date'].toString()),
                          status: status,
                          statusColor: color,
                          time:
                              '${_formatTime(record['check_in'])}  -  ${_formatTime(record['check_out'])}',
                          hours: _hoursText(record['total_minutes']),
                          cardColor: cardColor,
                          textColor: textColor,
                          mutedColor: mutedColor,
                          ),
                        ),
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

class _HomeMockData {
  final List<Map<String, dynamic>> records;
  final Map<String, dynamic> schedule;
  final Map<String, dynamic> todaySchedule;

  const _HomeMockData({
    required this.records,
    required this.schedule,
    required this.todaySchedule,
  });
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;
  final Color cardColor;
  final Color mutedColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.valueColor,
    required this.cardColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: mutedColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: mutedColor,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceRecord extends StatelessWidget {
  final String date;
  final String status;
  final Color statusColor;
  final String time;
  final String hours;
  final Color cardColor;
  final Color textColor;
  final Color mutedColor;

  const _AttendanceRecord({
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(
            color: statusColor,
            width: 4,
          ),
        ),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
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
        ],
      ),
    );
  }
}
