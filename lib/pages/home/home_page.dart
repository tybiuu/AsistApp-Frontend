// lib/pages/home/home_page.dart
import '../historial/historial_page.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/no_active_schedule_view.dart';
import '../../configs/theme.dart';
import '../../models/attendance_record.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';
import '../../services/session_service.dart';
import '../../utils/date_utils.dart';
import '../root/root_controller.dart';
import 'components/home_attendance_record.dart';
import 'components/hours_progress_card.dart';
import 'components/stat_card.dart';
import 'components/today_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<_HomeData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadHomeData();
  }

  Future<_HomeData> _loadHomeData() async {
    final recordsString = await rootBundle.loadString(
      'assets/jsons/mock_attendance_records.json',
    );
    final rawRecords = jsonDecode(recordsString) as List<dynamic>;
    final records = rawRecords
        .map((j) => AttendanceRecord.fromJson(j as Map<String, dynamic>))
        .toList();

    final scheduleResponse = await Get.find<ScheduleService>().fetchCurrent();

    return _HomeData(records: records, schedule: scheduleResponse.data);
  }

  static const List<String> _dayLabels = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
  ];

  static const List<String> _monthNames = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  String _todayDayLabel() => _dayLabels[DateTime.now().weekday - 1];

  int _completedMinutes(List<AttendanceRecord> records) =>
      records.fold<int>(0, (total, record) {
        final value = record.totalMinutes;
        return value != null ? total + value : total;
      });

  Future<void> _refresh() async {
    final future = _loadHomeData();
    if (!mounted) return;
    setState(() {
      _dataFuture = future;
    });
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textColor = colors.onSurface;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FutureBuilder<_HomeData>(
              future: _dataFuture,
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
                final schedule = data.schedule;

                if (schedule == null || schedule.status != 'approved') {
                  return NoActiveScheduleView(schedule: schedule, onReturn: _refresh);
                }

                final records = data.records;
                final todayLabel = _todayDayLabel();
                final todaySchedule = schedule.days[todayLabel];
                final workBlocks = todaySchedule?.blocks
                        .where((b) => b.type == BlockType.work)
                        .toList() ??
                    const <ScheduleBlock>[];

                final completedMinutes = _completedMinutes(records);
                final completedHours = completedMinutes ~/ 60;
                final requiredHours = schedule.weeklyHours * 4;
                final progress = requiredHours == 0
                    ? 0.0
                    : (completedHours / requiredHours).clamp(0.0, 1.0);

                final confirmedCount = records.where((r) => r.status == AttendanceStatus.confirmed).length;
                final absenceCount = records.where((r) => r.status == AttendanceStatus.absence).length;
                final lateCount = records.where((r) {
                  return r.lateMinutes != null && r.lateMinutes! > 0;
                }).length;
                final attendancePercent = records.isEmpty
                    ? 0
                    : ((confirmedCount / records.length) * 100).round();

                final checkIn = workBlocks.isNotEmpty ? formatTime12h(workBlocks.first.start) : '--:--';
                final checkOut = workBlocks.isNotEmpty ? formatTime12h(workBlocks.last.end) : '--:--';
                final now = DateTime.now();
                final todayDateLabel = '$todayLabel ${now.day} de ${_monthNames[now.month - 1]}';
                final latestRecords = records.where((r) => r.status != AttendanceStatus.pending).take(2).toList();

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
                      dateLabel: todayDateLabel,
                      checkIn: checkIn,
                      checkOut: checkOut,
                      onMark: () => Get.find<RootController>().changeTab(1),
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
                            date: '${dayAbbrevFromDate(record.date)} ${formatDateLong(record.date)}',
                            status: status,
                            statusColor: color,
                            time: '${formatTime12h(record.checkIn?.toIso8601String())}  -  ${formatTime12h(record.checkOut?.toIso8601String())}',
                            hours: hoursText(record.totalMinutes),
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

class _HomeData {
  final List<AttendanceRecord> records;
  final Schedule? schedule;

  const _HomeData({required this.records, required this.schedule});
}
