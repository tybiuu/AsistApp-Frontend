import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../components/no_active_schedule_view.dart';
import '../../configs/generic_response.dart';
import '../../models/attendance_record.dart';
import '../../models/schedule.dart';
import '../../services/attendance_record_service.dart';
import '../../services/schedule_service.dart';
import '../../services/session_service.dart';
import '../../utils/date_utils.dart';
import '../../configs/theme.dart';
import 'components/attendance_action_widgets.dart';
import 'components/attendance_step.dart';
import 'components/day_progress_tracker.dart';
import 'components/live_clock.dart';
import 'components/schedule_info_card.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  bool _isLoading = true;
  String? _loadError;
  Schedule? _schedule;
  AttendanceRecord? _record;
  bool _isSubmitting = false;
  bool _showConfirmation = false;
  Timer? _confirmTimer;

  static const List<String> _dayLabels = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _confirmTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });

    try {
      final scheduleResponse = await Get.find<ScheduleService>().fetchCurrent();
      final schedule = scheduleResponse.data;
      AttendanceRecord? record;

      if (schedule != null && schedule.status == 'approved') {
        final attendanceService = Get.find<AttendanceRecordService>();
        final recordsResponse = await attendanceService.fetchAll();
        final records = recordsResponse.data ?? const <AttendanceRecord>[];
        record = attendanceService.findByDate(records, todayIso());
      }

      if (!mounted) return;
      setState(() {
        _schedule = schedule;
        _record = record;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = 'No se pudo cargar tu asistencia';
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() => _loadData();

  int _currentStepFor(AttendanceRecord? record) {
    if (record == null || record.checkIn == null) return 0;
    if (record.lunchStart == null) return 1;
    if (record.lunchEnd == null) return 2;
    return 3;
  }

  Map<int, String> _markedTimesFor(AttendanceRecord? record) {
    if (record == null) return const {};
    final map = <int, String>{};
    if (record.checkIn != null) {
      map[0] = formatTime12h(record.checkIn!.toIso8601String());
    }
    if (record.lunchStart != null) {
      map[1] = formatTime12h(record.lunchStart!.toIso8601String());
    }
    if (record.lunchEnd != null) {
      map[2] = formatTime12h(record.lunchEnd!.toIso8601String());
    }
    if (record.checkOut != null) {
      map[3] = formatTime12h(record.checkOut!.toIso8601String());
    }
    return map;
  }

  int _computeTotalMinutes(AttendanceRecord record, DateTime checkOutAt) {
    final checkIn = record.checkIn;
    if (checkIn == null) return 0;
    int total = checkOutAt.difference(checkIn).inMinutes;
    if (record.lunchStart != null && record.lunchEnd != null) {
      total -= record.lunchEnd!.difference(record.lunchStart!).inMinutes;
    }
    return total < 0 ? 0 : total;
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleMark(Schedule schedule, List<ScheduleBlock> workBlocks) async {
    if (_isSubmitting) return;

    final user = SessionService.to.currentUser.value;
    final organizationId = schedule.organizationId ?? user?.organizationId;
    if (user == null || organizationId == null) {
      _showSnack('No se pudo identificar tu organización');
      return;
    }

    setState(() => _isSubmitting = true);

    final now = DateTime.now();
    final nowUtc = wallClockAsUtc(now);
    final service = Get.find<AttendanceRecordService>();
    final GenericResponse<AttendanceRecord> response;

    if (_record == null) {
      final scheduledMinutes = workBlocks.isNotEmpty ? schedToMins(workBlocks.first.start) : null;
      final actualMinutes = now.hour * 60 + now.minute;
      final lateMinutes = (scheduledMinutes != null && actualMinutes > scheduledMinutes)
          ? actualMinutes - scheduledMinutes
          : 0;
      response = await service.markCheckIn(
        userId: user.id,
        organizationId: organizationId,
        date: todayIso(),
        checkIn: nowUtc,
        lateMinutes: lateMinutes,
      );
    } else if (_record!.lunchStart == null) {
      response = await service.markProgress(_record!.id, lunchStart: nowUtc);
    } else if (_record!.lunchEnd == null) {
      response = await service.markProgress(_record!.id, lunchEnd: nowUtc);
    } else {
      final totalMinutes = _computeTotalMinutes(_record!, nowUtc);
      response = await service.markProgress(
        _record!.id,
        checkOut: nowUtc,
        totalMinutes: totalMinutes,
      );
    }

    if (!mounted) return;

    if (!response.success || response.data == null) {
      setState(() => _isSubmitting = false);
      _showSnack(
        response.message.isNotEmpty ? response.message : 'No se pudo registrar la marca',
      );
      return;
    }

    setState(() {
      _record = response.data;
      _isSubmitting = false;
      _showConfirmation = true;
    });

    _confirmTimer?.cancel();
    _confirmTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _showConfirmation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final mutedColor = colors.onSurfaceVariant;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        top: false,
        child: Builder(builder: (context) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_loadError != null) {
            return Column(
              children: [
                const AppTopBar(title: 'Asistencia'),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _loadError!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: mutedColor),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final schedule = _schedule;
          if (schedule == null || schedule.status != 'approved') {
            return Column(
              children: [
                const AppTopBar(title: 'Asistencia'),
                Expanded(
                  child: NoActiveScheduleView(schedule: schedule, onReturn: _refresh),
                ),
              ],
            );
          }

          final todayLabel = _dayLabels[DateTime.now().weekday - 1];
          final today = schedule.days[todayLabel];
          final workBlocks = today?.blocks
                  .where((b) => b.type == BlockType.work)
                  .toList() ??
              const <ScheduleBlock>[];
          final breakBlocks = today?.blocks
                  .where((b) => b.type == BlockType.breakTime)
                  .toList() ??
              const <ScheduleBlock>[];

          final checkIn = workBlocks.isNotEmpty ? formatTime12h(workBlocks.first.start) : '--:--';
          final checkOut = workBlocks.isNotEmpty ? formatTime12h(workBlocks.last.end) : '--:--';
          final lunchStart = breakBlocks.isNotEmpty ? formatTime12h(breakBlocks.first.start) : '--:--';
          final lunchEnd = breakBlocks.isNotEmpty ? formatTime12h(breakBlocks.first.end) : '--:--';

          final steps = [
            AttendanceStep(label: 'Ingreso',         action: 'MARCAR INGRESO',              color: colors.primary,  icon: Icons.login_rounded,          scheduled: checkIn),
            AttendanceStep(label: 'Sal. refrigerio', action: 'MARCAR SALIDA A REFRIGERIO',  color: AppColors.warning, icon: Icons.free_breakfast_rounded, scheduled: lunchStart),
            AttendanceStep(label: 'Ret. refrigerio', action: 'MARCAR RETORNO A REFRIGERIO', color: AppColors.warning, icon: Icons.replay_rounded,         scheduled: lunchEnd),
            AttendanceStep(label: 'Salida',          action: 'MARCAR SALIDA',               color: AppColors.error, icon: Icons.logout_rounded,         scheduled: checkOut),
          ];

          final currentStep = _currentStepFor(_record);
          final markedTimes = _markedTimesFor(_record);
          final allDone = _record?.checkOut != null;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: AppTopBar(title: 'Asistencia')),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    ScheduleInfoCard(
                      organizationId: schedule.organizationId ?? '',
                      checkIn: checkIn,
                      checkOut: checkOut,
                      lunchStart: lunchStart,
                      lunchEnd: lunchEnd,
                    ),
                    const SizedBox(height: 16),
                    DayProgressTracker(
                      steps: steps,
                      currentStep: currentStep,
                      markedTimes: markedTimes,
                    ),
                    const SizedBox(height: 20),
                    const LiveClock(),
                    const SizedBox(height: 2),
                    Center(
                      child: Text(
                        'Hora actual del sistema',
                        style: TextStyle(color: mutedColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) => ScaleTransition(
                        scale: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: allDone
                          ? const AttendanceDoneCard(key: ValueKey('done'))
                          : _showConfirmation
                              ? const AttendanceConfirmCard(key: ValueKey('confirm'))
                              : AttendanceActionButton(
                                  key: ValueKey(currentStep),
                                  step: steps[currentStep],
                                  onTap: () => _handleMark(schedule, workBlocks),
                                ),
                    ),
                  ]),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
