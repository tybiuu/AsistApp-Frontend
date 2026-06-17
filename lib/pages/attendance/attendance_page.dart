import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../components/app_top_bar.dart';
import '../../components/status_badge.dart';
import '../../configs/theme.dart';
import '../../utils/date_utils.dart';

class _Step {
  final String label;
  final String action;
  final Color color;
  final IconData icon;
  final String scheduled;

  _Step({
    required this.label,
    required this.action,
    required this.color,
    required this.icon,
    required this.scheduled,
  });
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late Future<Map<String, dynamic>> _scheduleFuture;
  int _currentStep = 0;
  final Map<int, String> _markedTimes = {};
  bool _showConfirmation = false;
  Timer? _confirmTimer;
  int _stepsLength = 4;

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

  Future<Map<String, dynamic>> _loadSchedule() async {
    final jsonString =
        await rootBundle.loadString('assets/jsons/mock_schedules.json');
    final schedules = jsonDecode(jsonString) as List<dynamic>;
    return schedules.first as Map<String, dynamic>;
  }

  void _handleMark() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final suffix = now.hour < 12 ? 'AM' : 'PM';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.foreground;
    final mutedColor = colors.onSurfaceVariant;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        top: false,
        child: FutureBuilder<Map<String, dynamic>>(
          future: _scheduleFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final schedule = snapshot.data!;
            final days = schedule['days'] as List<dynamic>;
            final today = days.first as Map<String, dynamic>;

            final checkIn    = formatTime12h(today['check_in_time']);
            final lunchStart = formatTime12h(today['lunch_start_time']);
            final lunchEnd   = formatTime12h(today['lunch_end_time']);
            final checkOut   = formatTime12h(today['check_out_time']);

            final steps = [
              _Step(label: 'Ingreso',         action: 'MARCAR INGRESO',               color: colors.primary,          icon: Icons.login_rounded,          scheduled: checkIn),
              _Step(label: 'Sal. refrigerio', action: 'MARCAR SALIDA A REFRIGERIO',   color: AppColors.warning, icon: Icons.free_breakfast_rounded, scheduled: lunchStart),
              _Step(label: 'Ret. refrigerio', action: 'MARCAR RETORNO A REFRIGERIO',  color: AppColors.warning, icon: Icons.replay_rounded,         scheduled: lunchEnd),
              _Step(label: 'Salida',          action: 'MARCAR SALIDA',                color: AppColors.error,         icon: Icons.logout_rounded,         scheduled: checkOut),
            ];
            _stepsLength = steps.length;

            final allDone = _currentStep >= steps.length - 1
                && _markedTimes.containsKey(steps.length - 1);

            final breakBg = colors.surfaceContainer;
            final breakFg = colors.onSurfaceVariant;

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AppTopBar(title: 'Asistencia'),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([

                      // ── Info card ────────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _InfoBlock(
                                    title: 'Organización',
                                    value: schedule['organization_id'].toString(),
                                    valueColor: textColor,
                                    mutedColor: mutedColor,
                                    align: CrossAxisAlignment.start,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: _InfoBlock(
                                    title: 'Tu horario hoy',
                                    value: '$checkIn - $checkOut',
                                    valueColor: textColor,
                                    mutedColor: mutedColor,
                                    align: CrossAxisAlignment.end,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _ScheduleTag('$checkIn - $lunchStart · Trabajo',     colors.primary.withValues(alpha: 0.15), colors.primary),
                                _ScheduleTag('$lunchStart - $lunchEnd · Refrigerio', breakBg,                                breakFg),
                                _ScheduleTag('$lunchEnd - $checkOut · Trabajo',      colors.primary.withValues(alpha: 0.15), colors.primary),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Progress tracker ─────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PROGRESO DEL DÍA',
                              style: TextStyle(
                                color: mutedColor,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ...steps.asMap().entries.map((e) {
                              final i = e.key;
                              final s = e.value;
                              final isDone   = _markedTimes.containsKey(i);
                              final isActive = i == _currentStep && !isDone;

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: i < steps.length - 1 ? 14 : 0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: (isDone || isActive)
                                            ? s.color
                                            : colors.surfaceContainerHigh,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        isDone ? Icons.check_rounded : s.icon,
                                        color: (isDone || isActive)
                                            ? Colors.white
                                            : colors.onSurfaceVariant,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            s.label,
                                            style: TextStyle(
                                              color: (isDone || isActive)
                                                  ? textColor
                                                  : mutedColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.schedule_rounded, size: 10, color: mutedColor),
                                              const SizedBox(width: 3),
                                              Text(
                                                'Programado ${s.scheduled}',
                                                style: TextStyle(color: mutedColor, fontSize: 11),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isDone) ...[
                                      Text(
                                        _markedTimes[i]!,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 11,
                                          fontFamily: 'RobotoMono',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      StatusBadge(status: BadgeStatus.confirmed),
                                    ] else if (isActive)
                                      StatusBadge(status: BadgeStatus.pending)
                                    else
                                      Text('–', style: TextStyle(color: mutedColor, fontSize: 14)),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Clock ────────────────────────────────────────────
                      const _LiveClock(),
                      const SizedBox(height: 2),
                      Center(
                        child: Text(
                          'Hora actual del sistema',
                          style: TextStyle(color: mutedColor),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Action button ────────────────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) => ScaleTransition(
                          scale: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                          child: FadeTransition(opacity: anim, child: child),
                        ),
                        child: allDone
                            ? const _DoneCard(key: ValueKey('done'))
                            : _showConfirmation
                                ? const _ConfirmCard(key: ValueKey('confirm'))
                                : _ActionButton(
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

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _InfoBlock extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final Color mutedColor;
  final CrossAxisAlignment align;

  const _InfoBlock({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.mutedColor,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: TextStyle(
            color: mutedColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 18,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final _Step step;
  final VoidCallback onTap;

  const _ActionButton({super.key, required this.step, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: step.color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(step.icon, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Text(
              step.action,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: 'RobotoMono',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfirmCard extends StatelessWidget {
  const _ConfirmCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Text(
            '¡Registrado!',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _DoneCard extends StatelessWidget {
  const _DoneCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 32),
          SizedBox(height: 8),
          Text(
            'Jornada completada',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Todos los registros marcados',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── Live clock ───────────────────────────────────────────────────────────────

class _LiveClock extends StatefulWidget {
  const _LiveClock();

  @override
  State<_LiveClock> createState() => _LiveClockState();
}

class _LiveClockState extends State<_LiveClock> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timeString {
    final h = _now.hour % 12 == 0 ? 12 : _now.hour % 12;
    final m = _now.minute.toString().padLeft(2, '0');
    final s = _now.second.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$m:$s';
  }

  String get _amPm => _now.hour < 12 ? 'AM' : 'PM';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.foreground;
    final mutedColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _timeString,
            style: TextStyle(
              color: textColor,
              fontSize: 48,
              fontWeight: FontWeight.w900,
              height: 1,
              fontFamily: 'RobotoMono',
            ),
          ),
          const SizedBox(width: 6),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              _amPm,
              style: TextStyle(
                color: mutedColor,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
