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
import 'components/home_attendance_record.dart';
import 'components/hours_progress_card.dart';
import 'components/stat_card.dart';
import 'components/today_card.dart';

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
    const names = {
      'monday': 'Lunes', 'tuesday': 'Martes', 'wednesday': 'Miércoles',
      'thursday': 'Jueves', 'friday': 'Viernes', 'saturday': 'Sábado',
      'sunday': 'Domingo',
    };
    return names[day] ?? 'Lunes';
  }

  int _completedMinutes(List<Map<String, dynamic>> records) =>
      records.fold<int>(0, (total, record) {
        final value = record['total_minutes'];
        return value is int ? total + value : total;
      });

  int _requiredMonthlyHours(Map<String, dynamic> schedule) {
    final weeklyHours = schedule['weekly_hours'];
    return weeklyHours is int ? weeklyHours * 4 : 120;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.foreground;
    final colors = Theme.of(context).colorScheme;

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

                final confirmedCount = records.where((r) => r['status'] == 'confirmed').length;
                final absenceCount = records.where((r) => r['status'] == 'absence').length;
                final lateCount = records.where((r) {
                  final lateMinutes = r['late_minutes'];
                  return lateMinutes != null && lateMinutes > 0;
                }).length;
                final attendancePercent = records.isEmpty
                    ? 0
                    : ((confirmedCount / records.length) * 100).round();

                final checkIn = formatTime12h(todaySchedule['check_in_time']);
                final checkOut = formatTime12h(todaySchedule['check_out_time']);
                final todayLabel = '${_dayName(todaySchedule['day'].toString())} 28 de abril';
                final latestRecords = records.where((r) => r['status'] != 'pending').take(2).toList();

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
                        color: colors.onSurfaceVariant,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TodayCard(
                      dateLabel: todayLabel,
                      checkIn: checkIn,
                      checkOut: checkOut,
                      onMark: () {},
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
                    HoursProgressCard(
                      completedHours: completedHours,
                      requiredHours: requiredHours,
                      progress: progress,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: '% Asistencia',
                            value: '$attendancePercent%',
                            subtitle: 'este mes',
                            valueColor: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Tardanzas',
                            value: lateCount.toString(),
                            subtitle: 'este mes',
                            valueColor: colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Días asistidos',
                            value: confirmedCount.toString(),
                            subtitle: 'confirmados',
                            valueColor: textColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Inasistencias',
                            value: absenceCount.toString(),
                            subtitle: 'este mes',
                            valueColor: AppColors.success,
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HistorialPage()),
                          ),
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HistorialPage()),
                          ),
                          child: HomeAttendanceRecord(
                            date: '${dayAbbrevFromDate(record['date'].toString())} ${formatDateLong(record['date'].toString())}',
                            status: status,
                            statusColor: color,
                            time: '${formatTime12h(record['check_in'])}  -  ${formatTime12h(record['check_out'])}',
                            hours: hoursText(record['total_minutes']),
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
