import 'dart:async';
import 'dart:convert';

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// ── Model ─────────────────────────────────────────────────────────────────────

class _WorkBlock {
  final String id;
  final String start;
  final String end;
  final String hours;
  const _WorkBlock({
    required this.id,
    required this.start,
    required this.end,
    required this.hours,
  });
}

class _PageData {
  final List<_WorkBlock> blocks;
  final String todayLabel;
  const _PageData({required this.blocks, required this.todayLabel});
}

// ── Page ──────────────────────────────────────────────────────────────────────

class MissingAttendanceRequestPage extends StatefulWidget {
  const MissingAttendanceRequestPage({super.key});

  @override
  State<MissingAttendanceRequestPage> createState() =>
      _MissingAttendanceRequestPageState();
}

class _MissingAttendanceRequestPageState
    extends State<MissingAttendanceRequestPage> {
  late Future<_PageData> _dataFuture;

  String? _selectedBlockId;
  bool _blockOpen = false;

  TimeOfDay? _arrivalTime;

  final TextEditingController _reasonController = TextEditingController();
  bool _submitted = false;
  Timer? _navTimer;

  bool get _canSubmit =>
      _selectedBlockId != null &&
      _arrivalTime != null &&
      _reasonController.text.length >= 10;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
    _reasonController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _navTimer?.cancel();
    super.dispose();
  }

  Future<_PageData> _loadData() async {
    final jsonString =
        await rootBundle.loadString('assets/jsons/mock_schedules.json');
    final List<dynamic> schedules = jsonDecode(jsonString);
    final days = (schedules.first['days'] as List<dynamic>);

    final now = DateTime.now();
    final dayKeys = [
      'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'
    ];
    final todayKey = dayKeys[now.weekday - 1];
    final day = days.firstWhere(
      (d) => d['day'] == todayKey,
      orElse: () => days.first,
    ) as Map<String, dynamic>;

    final checkIn = day['check_in_time'] as String;
    final checkOut = day['check_out_time'] as String;
    final lunchStart = day['lunch_start_time'] as String?;
    final lunchEnd = day['lunch_end_time'] as String?;

    final blocks = <_WorkBlock>[];
    if (lunchStart != null && lunchEnd != null) {
      blocks.add(_WorkBlock(
        id: 'b1',
        start: checkIn,
        end: lunchStart,
        hours: _diffHours(checkIn, lunchStart),
      ));
      blocks.add(_WorkBlock(
        id: 'b2',
        start: lunchEnd,
        end: checkOut,
        hours: _diffHours(lunchEnd, checkOut),
      ));
    } else {
      blocks.add(_WorkBlock(
        id: 'b1',
        start: checkIn,
        end: checkOut,
        hours: _diffHours(checkIn, checkOut),
      ));
    }

    return _PageData(blocks: blocks, todayLabel: _todayLabel(now));
  }

  String _diffHours(String start, String end) {
    final sp = start.split(':');
    final ep = end.split(':');
    final mins = (int.parse(ep[0]) * 60 + int.parse(ep[1])) -
        (int.parse(sp[0]) * 60 + int.parse(sp[1]));
    final h = mins ~/ 60;
    final m = mins % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  String _todayLabel(DateTime now) {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    const months = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${days[now.weekday - 1]} ${now.day} ${months[now.month]}';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _arrivalTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked != null) setState(() => _arrivalTime = picked);
  }

  void _handleSubmit() {
    setState(() => _submitted = true);
    _navTimer = Timer(
      const Duration(milliseconds: 2500),
      () { if (mounted) Navigator.pop(context); },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (_submitted) {
      return Scaffold(
        backgroundColor: colors.surfaceContainerLow,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 40,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '¡Solicitud enviada!',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu validador revisará la solicitud y confirmará si tu asistencia puede registrarse sin tardanza.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: FutureBuilder<_PageData>(
              future: _dataFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Text(
                      'Error al cargar datos',
                      style: TextStyle(color: colors.onSurface),
                    ),
                  );
                }
                final data = snapshot.data!;
                return _FormBody(
                  data: data,
                  colors: colors,
                  selectedBlockId: _selectedBlockId,
                  blockOpen: _blockOpen,
                  arrivalTime: _arrivalTime,
                  reasonController: _reasonController,
                  canSubmit: _canSubmit,
                  onBlockToggle: () =>
                      setState(() => _blockOpen = !_blockOpen),
                  onBlockSelect: (id) =>
                      setState(() { _selectedBlockId = id; _blockOpen = false; }),
                  onPickTime: _pickTime,
                  onBack: () => Navigator.pop(context),
                  onSubmit: _handleSubmit,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// ── Form body ─────────────────────────────────────────────────────────────────

class _FormBody extends StatelessWidget {
  final _PageData data;
  final ColorScheme colors;
  final String? selectedBlockId;
  final bool blockOpen;
  final TimeOfDay? arrivalTime;
  final TextEditingController reasonController;
  final bool canSubmit;
  final VoidCallback onBlockToggle;
  final ValueChanged<String> onBlockSelect;
  final VoidCallback onPickTime;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  const _FormBody({
    required this.data,
    required this.colors,
    required this.selectedBlockId,
    required this.blockOpen,
    required this.arrivalTime,
    required this.reasonController,
    required this.canSubmit,
    required this.onBlockToggle,
    required this.onBlockSelect,
    required this.onPickTime,
    required this.onBack,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final chosen = data.blocks.where((b) => b.id == selectedBlockId).firstOrNull;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      children: [
        // ── Header ──
        Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(Icons.arrow_back_rounded, color: colors.onSurface),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Solicitar asistencia faltante',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ── Block selector ──
        Text(
          '¿A cuál entrada de trabajo corresponde?',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
            children: [
              const TextSpan(text: 'Entradas de trabajo de hoy · '),
              TextSpan(
                text: data.todayLabel,
                style: TextStyle(
                    color: colors.onSurface, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Trigger
        GestureDetector(
          onTap: onBlockToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: blockOpen
                  ? const BorderRadius.vertical(top: Radius.circular(16))
                  : BorderRadius.circular(16),
              border: Border.all(
                color: blockOpen || selectedBlockId != null
                    ? AppColors.chart1
                    : colors.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.work_outline_rounded,
                    color: AppColors.chart1, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: chosen != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Entrada ${data.blocks.indexOf(chosen) + 1}',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${chosen.start} – ${chosen.end} · ${chosen.hours}',
                              style: TextStyle(
                                  color: colors.onSurfaceVariant, fontSize: 11),
                            ),
                          ],
                        )
                      : Text(
                          'Selecciona una entrada',
                          style: TextStyle(
                              color: colors.onSurfaceVariant, fontSize: 14),
                        ),
                ),
                Icon(
                  blockOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: colors.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Dropdown list
        if (blockOpen)
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border(
                left: BorderSide(color: AppColors.chart1),
                right: BorderSide(color: AppColors.chart1),
                bottom: BorderSide(color: AppColors.chart1),
              ),
            ),
            child: Column(
              children: data.blocks.asMap().entries.map((entry) {
                final idx = entry.key;
                final b = entry.value;
                final isActive = b.id == selectedBlockId;
                final isLast = idx == data.blocks.length - 1;
                return GestureDetector(
                  onTap: () => onBlockSelect(b.id),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.chart1.withValues(alpha: 0.08)
                          : Colors.transparent,
                      border: isLast
                          ? null
                          : Border(
                              bottom:
                                  BorderSide(color: colors.outlineVariant)),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.chart1
                                : colors.outlineVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Entrada ${idx + 1}',
                                style: TextStyle(
                                  color: isActive
                                      ? AppColors.chart1
                                      : colors.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${b.start} – ${b.end} · ${b.hours}',
                                style: TextStyle(
                                    color: colors.onSurfaceVariant,
                                    fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 6),
        Text(
          'Elige el bloque específico que olvidaste marcar hoy.',
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
        ),

        const SizedBox(height: 24),

        // ── Arrival time ──
        Text(
          '¿A qué hora llegaste?',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),

        GestureDetector(
          onTap: onPickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: arrivalTime != null
                    ? AppColors.chart1
                    : colors.outlineVariant,
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    color: AppColors.chart1, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    arrivalTime != null
                        ? '${arrivalTime!.hour.toString().padLeft(2, '0')}:${arrivalTime!.minute.toString().padLeft(2, '0')}'
                        : 'Toca para elegir la hora',
                    style: TextStyle(
                      color: arrivalTime != null
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                      fontSize: 15,
                      fontWeight: arrivalTime != null
                          ? FontWeight.w700
                          : FontWeight.w400,
                    ),
                  ),
                ),
                Icon(Icons.edit_outlined,
                    color: colors.onSurfaceVariant, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Indica la hora aproximada en que ingresaste a tu área de trabajo.',
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
        ),

        const SizedBox(height: 24),

        // ── Reason ──
        Text(
          '¿Por qué no marcaste?',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: TextField(
            controller: reasonController,
            maxLines: 4,
            minLines: 3,
            maxLength: 200,
            style: TextStyle(
                color: colors.onSurface, fontSize: 14, height: 1.5),
            decoration: InputDecoration(
              hintText:
                  'Ej: No tenía el celular a la mano al llegar, luego se me olvidó...',
              hintStyle: TextStyle(
                  color: colors.onSurfaceVariant, fontSize: 13),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterStyle:
                  TextStyle(color: colors.onSurfaceVariant, fontSize: 11),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // ── Submit ──
        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton(
            onPressed: canSubmit ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.chart1,
              disabledBackgroundColor:
                  AppColors.chart1.withValues(alpha: 0.4),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white70,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'Enviar solicitud',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}
