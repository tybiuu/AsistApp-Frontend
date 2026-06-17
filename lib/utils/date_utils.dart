// lib/utils/date_utils.dart

import 'package:flutter/material.dart';

import 'package:asist_app/configs/theme.dart';
import 'package:asist_app/models/schedule.dart';

// ─── Parsing ─────────────────────────────────────────────────────────────────

DateTime dateFromJson(String? value) =>
    DateTime.tryParse(value ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);

// ─── Formatting ───────────────────────────────────────────────────────────────

/// Converts a time value to 12-hour format ("08:30 AM").
/// Accepts ISO datetime strings ("2024-05-12T08:30:00") or "HH:MM" strings.
String formatTime12h(dynamic value) {
  if (value == null) return '--:--';
  final text = value.toString();

  int hour;
  String minute;

  if (text.contains('T') && text.length >= 16) {
    hour   = int.tryParse(text.substring(11, 13)) ?? 0;
    minute = text.substring(14, 16);
  } else {
    final parts = text.split(':');
    if (parts.length < 2) return text;
    hour   = int.tryParse(parts[0]) ?? 0;
    minute = parts[1].length >= 2 ? parts[1].substring(0, 2) : parts[1];
  }

  final suffix = hour >= 12 ? 'p.m.' : 'a.m.';
  final h12    = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
  return '${h12.toString().padLeft(2, '0')}:$minute $suffix';
}

/// Extracts HH:MM (24h) from an ISO datetime or "HH:MM" string.
String formatTimeShort(dynamic value) {
  if (value == null) return '-';
  final text = value.toString();
  if (text.contains('T')) return text.length >= 16 ? text.substring(11, 16) : '-';
  return text.length >= 5 ? text.substring(0, 5) : '-';
}

/// "YYYY-MM-DD" → "12 may"
String formatDateShort(String date) {
  final parts = date.split('-');
  if (parts.length != 3) return date;
  final month = int.tryParse(parts[1]);
  if (month == null || month < 1 || month > 12) return date;
  const months = ['ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'];
  return '${parts[2]} ${months[month - 1]}';
}

/// "YYYY-MM-DD" → "12 de mayo"
String formatDateLong(String date) {
  final parts = date.split('-');
  if (parts.length != 3) return date;
  const months = {
    '01': 'enero',  '02': 'febrero', '03': 'marzo',    '04': 'abril',
    '05': 'mayo',   '06': 'junio',   '07': 'julio',    '08': 'agosto',
    '09': 'septiembre', '10': 'octubre', '11': 'noviembre', '12': 'diciembre',
  };
  return '${parts[2]} de ${months[parts[1]] ?? parts[1]}';
}

/// Minutes → "2h 05min"
String hoursText(dynamic totalMinutes) {
  if (totalMinutes == null) return '--';
  final minutes = totalMinutes is int
      ? totalMinutes
      : int.tryParse(totalMinutes.toString()) ?? 0;
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return '${h}h ${m.toString().padLeft(2, '0')}min';
}

/// Minutes → "2h" / "2h 5m"  (compact, used in schedule summaries)
String fmtMins(int totalMins) {
  final h = totalMins ~/ 60;
  final m = totalMins % 60;
  if (m == 0) return '${h}h';
  return '${h}h ${m}m';
}

/// Month index (1–12) → abbreviated Spanish name ("ene", "feb", …).
String monthAbbrev(int month) {
  const months = ['ene','feb','mar','abr','may','jun','jul','ago','sep','oct','nov','dic'];
  if (month < 1 || month > 12) return '';
  return months[month - 1];
}

// ─── Day abbreviations ────────────────────────────────────────────────────────

const List<String> _dayAbbrevs = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];

/// "YYYY-MM-DD" → "Lun", "Mar", etc.
String dayAbbrevFromDate(String dateStr) {
  final dt = DateTime.tryParse(dateStr);
  if (dt == null) return '';
  return _dayAbbrevs[dt.weekday % 7];
}

// ─── Attendance status ────────────────────────────────────────────────────────

/// Returns display label for an attendance record status.
String attendanceStatusText(Map<String, dynamic> record) {
  if (record['status'] == 'absence') return 'Inasistencia';
  if (record['status'] == 'pending') return 'Pendiente';
  final lateMinutes = record['late_minutes'];
  if (lateMinutes != null && lateMinutes > 0) return 'Tardanza';
  return 'Puntual';
}

/// Returns the color for an attendance status label.
/// Uses [context] to resolve the theme's primary color for "Tardanza".
Color attendanceStatusColor(BuildContext context, String status) {
  if (status == 'Puntual')      return AppColors.success;
  if (status == 'Tardanza')     return Theme.of(context).colorScheme.primary;
  if (status == 'Inasistencia') return AppColors.error;
  return AppColors.info;
}

// ─── Schedule helpers ─────────────────────────────────────────────────────────

String formatRequestDate(DateTime date) {
  final DateTime now = DateTime.now();
  final int displayHour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final String minute = date.minute.toString().padLeft(2, '0');
  final String period = date.hour < 12 ? 'a.m.' : 'p.m.';

  final bool isToday =
      date.year == now.year && date.month == now.month && date.day == now.day;
  if (isToday) return 'Hoy, $displayHour:$minute $period';

  final DateTime yesterday = now.subtract(const Duration(days: 1));
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Ayer, $displayHour:$minute $period';
  }

  const List<String> months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];
  return '${date.day} ${months[date.month - 1]}, $displayHour:$minute $period';
}

int schedToMins(String t) {
  final parts = t.split(':');
  return int.parse(parts[0]) * 60 + int.parse(parts[1]);
}

int dayWorkMins(DaySchedule day) {
  if (!day.enabled) return 0;
  return day.blocks
      .where((b) => b.type == BlockType.work)
      .fold(0, (sum, b) => sum + schedToMins(b.end) - schedToMins(b.start));
}
