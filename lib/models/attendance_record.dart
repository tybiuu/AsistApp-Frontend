import '../utils/date_utils.dart';

enum AttendanceStatus { pending, confirmed, absence }

class AttendanceRecord {
  final String id;
  final String userId;
  final String organizationId;
  final String date;
  final DateTime? checkIn;
  final DateTime? lunchStart;
  final DateTime? lunchEnd;
  final DateTime? checkOut;
  final bool autoCheckout;
  final int? lateMinutes;
  final int? totalMinutes;
  final AttendanceStatus status;
  final String? validatedById;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceRecord({
    required this.id,
    required this.userId,
    required this.organizationId,
    required this.date,
    this.checkIn,
    this.lunchStart,
    this.lunchEnd,
    this.checkOut,
    required this.autoCheckout,
    this.lateMinutes,
    this.totalMinutes,
    required this.status,
    this.validatedById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      checkIn: _parseTimestamp(json['checkIn']),
      lunchStart: _parseTimestamp(json['lunchStart']),
      lunchEnd: _parseTimestamp(json['lunchEnd']),
      checkOut: _parseTimestamp(json['checkOut']),
      autoCheckout: json['autoCheckout'] as bool? ?? false,
      lateMinutes: json['lateMinutes'] as int?,
      totalMinutes: json['totalMinutes'] as int?,
      status: _statusFromJson(json['status'] as String?),
      validatedById: json['validatedById'] as String?,
      createdAt: dateFromJson(json['createdAt'] as String?),
      updatedAt: dateFromJson(json['updatedAt'] as String?),
    );
  }

  static DateTime? _parseTimestamp(dynamic value) =>
      value != null ? DateTime.tryParse(value as String) : null;

  static AttendanceStatus _statusFromJson(String? value) =>
      AttendanceStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => AttendanceStatus.pending,
      );
}
