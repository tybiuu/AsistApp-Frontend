// lib/pages/profile/profile_schedule.dart

// ---------------------------------------------------------------------------
// Models
// ---------------------------------------------------------------------------

enum BlockType { work, breakTime }

class ScheduleBlock {
  final BlockType type;
  final String start;
  final String end;

  const ScheduleBlock({
    required this.type,
    required this.start,
    required this.end,
  });
}

class DaySchedule {
  final bool enabled;
  final List<ScheduleBlock> blocks;

  const DaySchedule({
    required this.enabled,
    required this.blocks,
  });
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Parses "HH:mm" → minutes from midnight.
int schedToMins(String t) {
  final parts = t.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

/// Total work minutes in a day.
int dayWorkMins(DaySchedule day) {
  if (!day.enabled) return 0;
  return day.blocks
      .where((b) => b.type == BlockType.work)
      .fold(0, (sum, b) => sum + schedToMins(b.end) - schedToMins(b.start));
}

/// Formats minutes → "Xh" or "Xh Ym".
String fmtMins(int totalMins) {
  final h = totalMins ~/ 60;
  final m = totalMins % 60;
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

final kMySchedule = <String, DaySchedule>{
  'Lunes': DaySchedule(enabled: true, blocks: [
    const ScheduleBlock(type: BlockType.work,      start: '08:00', end: '13:00'),
    const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
    const ScheduleBlock(type: BlockType.work,      start: '14:00', end: '17:00'),
  ]),
  'Martes': DaySchedule(enabled: true, blocks: [
    const ScheduleBlock(type: BlockType.work,      start: '08:00', end: '13:00'),
    const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
    const ScheduleBlock(type: BlockType.work,      start: '14:00', end: '17:00'),
  ]),
  'Miércoles': DaySchedule(enabled: true, blocks: [
    const ScheduleBlock(type: BlockType.work,      start: '08:00', end: '13:00'),
    const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
    const ScheduleBlock(type: BlockType.work,      start: '14:00', end: '17:00'),
  ]),
  'Jueves': DaySchedule(enabled: true, blocks: [
    const ScheduleBlock(type: BlockType.work,      start: '08:00', end: '13:00'),
    const ScheduleBlock(type: BlockType.breakTime, start: '13:00', end: '14:00'),
    const ScheduleBlock(type: BlockType.work,      start: '14:00', end: '17:00'),
  ]),
  'Viernes': DaySchedule(enabled: true, blocks: [
    const ScheduleBlock(type: BlockType.work, start: '08:00', end: '11:00'),
  ]),
  'Sábado': const DaySchedule(enabled: false, blocks: []),
};

// ---------------------------------------------------------------------------
// Constants
// ---------------------------------------------------------------------------

const kCarreras = [
  'Administración',
  'Comunicación',
  'Derecho',
  'Ingeniería Ambiental',
  'Ingeniería Industrial',
  'Ingeniería de Sistemas',
  'Negocios Internacionales',
  'Arquitectura',
  'Contabilidad y Finanzas',
  'Economía',
  'Ingeniería Civil',
  'Ingeniería Mecatrónica',
  'Marketing',
  'Psicología',
];

String cicloLabel(int n) {
  const suffixes = {5: 'to', 6: 'to', 7: 'mo', 8: 'vo', 9: 'no', 10: 'mo'};
  return '$n${suffixes[n] ?? 'mo'} ciclo';
}
