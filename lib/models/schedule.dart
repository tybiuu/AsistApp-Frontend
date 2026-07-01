// lib/models/schedule.dart

import '../utils/date_utils.dart';

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

  Map<String, dynamic> toJson() => {
    'type': type == BlockType.work ? 'work' : 'break',
    'start': start,
    'end': end,
  };
}

class DaySchedule {
  final bool enabled;
  final List<ScheduleBlock> blocks;

  final String? id;

  const DaySchedule({
    required this.enabled,
    required this.blocks,
    this.id,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    String? checkIn = _trim(json['checkInTime'] as String?);
    String? lunchStart = _trim(json['lunchStartTime'] as String?);
    String? lunchEnd = _trim(json['lunchEndTime'] as String?);
    String? checkOut = _trim(json['checkOutTime'] as String?);

    if (checkIn == null || checkOut == null) {
      return const DaySchedule(enabled: false, blocks: []);
    }

    final blocks = <ScheduleBlock>[];
    if (lunchStart != null && lunchEnd != null) {
      blocks.addAll([
        ScheduleBlock(type: BlockType.work, start: checkIn,    end: lunchStart),
        ScheduleBlock(type: BlockType.breakTime, start: lunchStart, end: lunchEnd),
        ScheduleBlock(type: BlockType.work, start: lunchEnd,   end: checkOut),
      ]);
    } else {
      blocks.add(ScheduleBlock(type: BlockType.work, start: checkIn, end: checkOut));
    }
    return DaySchedule(enabled: true, blocks: blocks, id: json['id'] as String?);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'enabled': enabled,
    'blocks': blocks.map((b) => b.toJson()).toList(),
  };

  static String? _trim(String? t) =>
      (t != null && t.length > 5) ? t.substring(0, 5) : t;
}

// ---------------------------------------------------------------------------

class Schedule {
  final String id;
  final String userId;
  final String? organizationId;
  final int weeklyHours;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, DaySchedule> days;

  const Schedule({
    required this.id,
    required this.userId,
    this.organizationId,
    required this.weeklyHours,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.days,
  });

  static const _dayMap = {
    'monday': 'Lunes',
    'tuesday': 'Martes',
    'wednesday': 'Miércoles',
    'thursday': 'Jueves',
    'friday': 'Viernes',
    'saturday': 'Sábado',
    'sunday': 'Domingo',
  };

  static Map<String, DaySchedule> emptyDays() => {
    'Lunes': const DaySchedule(enabled: false, blocks: []),
    'Martes': const DaySchedule(enabled: false, blocks: []),
    'Miércoles': const DaySchedule(enabled: false, blocks: []),
    'Jueves': const DaySchedule(enabled: false, blocks: []),
    'Viernes': const DaySchedule(enabled: false, blocks: []),
    'Sábado': const DaySchedule(enabled: false, blocks: []),
  };

  factory Schedule.fromJson(Map<String, dynamic> json) {
    final days = emptyDays();
    for (final d in (json['days'] as List<dynamic>? ?? [])) {
      final dayJson    = d as Map<String, dynamic>;
      final spanishDay = _dayMap[dayJson['day'] as String? ?? ''];
      if (spanishDay != null) {
        days[spanishDay] = DaySchedule.fromJson(dayJson);
      }
    }
    return Schedule(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      organizationId: json['organizationId'] as String?,
      weeklyHours: json['weeklyHours'] as int? ?? 0,
      status: json['status'] as String? ?? 'pending',
      createdAt: dateFromJson(json['createdAt'] as String?),
      updatedAt: dateFromJson(json['updatedAt'] as String?),
      days: days,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'organizationId': organizationId,
    'weeklyHours': weeklyHours,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'days': days.map((k, v) => MapEntry(k, v.toJson())),
  };
}

