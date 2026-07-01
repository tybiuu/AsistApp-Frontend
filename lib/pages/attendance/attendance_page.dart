import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../components/no_active_schedule_view.dart';
import '../../models/schedule.dart';
import '../../services/schedule_service.dart';
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
  late Future<Schedule?> _scheduleFuture;
  int _currentStep = 0;
  final Map<int, String> _markedTimes = {};
  bool _showConfirmation = false;
  Timer? _confirmTimer;
  int _stepsLength = 4;

  static const List<String> _dayLabels = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
  ];

  @override
  void initState() {
    super.initState();
    _scheduleFuture = _loadSchedule();
  }

  @override
  void dispose() {
    _confirmTimer?.cancel();
    super.dispose();
  }

  Future<Schedule?> _loadSchedule() async {
    final response = await Get.find<ScheduleService>().fetchCurrent();
    return response.data;
  }

  Future<void> _refresh() async {
    final future = _loadSchedule();
    if (!mounted) return;
    setState(() {
      _scheduleFuture = future;
    });
    await future;
  }

  void _handleMark() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final suffix = now.hour < 12 ? 'a.m.' : 'p.m.';
    final timeStr = '${h.toString().padLeft(2, '0')}:$m $suffix';

    setState(() {
      _markedTimes[_currentStep] = timeStr;
      _showConfirmation = true;
    });

    _confirmTimer?.cancel();
    _confirmTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _showConfirmation = false;
        if (_currentStep < _stepsLength - 1) _currentStep++;
      });
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
        child: FutureBuilder<Schedule?>(
          future: _scheduleFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final schedule = snapshot.data;
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
            _stepsLength = steps.length;

            final allDone = _currentStep >= steps.length - 1
                && _markedTimes.containsKey(steps.length - 1);

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
                        currentStep: _currentStep,
                        markedTimes: _markedTimes,
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
                                    key: ValueKey(_currentStep),
                                    step: steps[_currentStep],
                                    onTap: _handleMark,
                                  ),
                      ),
                    ]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
