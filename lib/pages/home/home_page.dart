// lib/pages/home/home_page.dart
import '../historial/historial_page.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../configs/theme.dart';
import '../../services/session_service.dart';
import '../../utils/date_utils.dart';
import '../root/root_controller.dart';

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
    final ColorScheme colors = Theme.of(context).colorScheme;

    final Color cardColor = colors.surface;
    final Color textColor = isDark ? Colors.white : AppColors.foreground;
    final Color mutedColor = colors.onSurfaceVariant;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
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

                final checkIn = formatTime12h(todaySchedule['check_in_time']);
                final checkOut = formatTime12h(todaySchedule['check_out_time']);
                final todayLabel =
                    '${_dayName(todaySchedule['day'].toString())} 28 de abril';

                final latestRecords = records
                    .where((r) => r['status'] != 'pending')
                    .take(2)
                    .toList();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                  children: [
                    Text(
                      'Buenos días, ${SessionService.to.currentUser.value?.firstName ?? 'Usuario'} 👋',
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
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.25),
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
                                  fontSize: 13,
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
                          const SizedBox(height: 2),
                          Text(
                            todayLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
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
                                      fontSize: 15,
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
                                foregroundColor: colors.primary,
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
                                  fontSize: 16,
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
                        GestureDetector(
                          onTap: () => Get.find<RootController>().changeTab(2),
                          child: Text(
                            'Ver reporte',
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
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
                                  style: TextStyle(
                                    color: colors.primary,
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
                              backgroundColor: colors.primaryContainer,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colors.primary,
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
                            valueColor: AppColors.success,
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
                            valueColor: colors.primary,
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
                            valueColor: AppColors.success,
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
                                builder: (_) => const HistorialPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Ver todos',
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...latestRecords.map((record) {
                      final status = attendanceStatusText(record);
                      final color = attendanceStatusColor(context, status);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HistorialPage(),
                              ),
                            );
                          },
                          child: _AttendanceRecord(
                          date: '${dayAbbrevFromDate(record['date'].toString())} ${formatDateLong(record['date'].toString())}',
                          status: status,
                          statusColor: color,
                          time:
                              '${formatTime12h(record['check_in'])}  -  ${formatTime12h(record['check_out'])}',
                          hours: hoursText(record['total_minutes']),
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
    final ColorScheme colors = Theme.of(context).colorScheme;

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
                    fontSize: 15,
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
                        fontSize: 13,
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'RobotoMono',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                hours,
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 13,
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
