import '../utils/date_utils.dart';
import 'attendance_request.dart';

class ScheduleChangeRequestDay {
  final String id;
  final String day;
  final String? checkInTime;
  final String? lunchStartTime;
  final String? lunchEndTime;
  final String? checkOutTime;

  const ScheduleChangeRequestDay({
    required this.id,
    required this.day,
    this.checkInTime,
    this.lunchStartTime,
    this.lunchEndTime,
    this.checkOutTime,
  });

  factory ScheduleChangeRequestDay.fromJson(Map<String, dynamic> json) {
    return ScheduleChangeRequestDay(
      id: json['id'] as String? ?? '',
      day: json['day'] as String? ?? '',
      checkInTime: json['checkInTime'] as String?,
      lunchStartTime: json['lunchStartTime'] as String?,
      lunchEndTime: json['lunchEndTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
    );
  }
}

class ScheduleChangeRequest {
  final String id;
  final String userId;
  final String scheduleDayId;
  final String? newCheckInTime;
  final String? newLunchStartTime;
  final String? newLunchEndTime;
  final String? newCheckOutTime;
  final String reason;
  final RequestStatus status;
  final String? reviewedById;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ScheduleChangeRequestDay? scheduleDay;

  const ScheduleChangeRequest({
    required this.id,
    required this.userId,
    required this.scheduleDayId,
    this.newCheckInTime,
    this.newLunchStartTime,
    this.newLunchEndTime,
    this.newCheckOutTime,
    required this.reason,
    required this.status,
    this.reviewedById,
    required this.createdAt,
    required this.updatedAt,
    this.scheduleDay,
  });

  factory ScheduleChangeRequest.fromJson(Map<String, dynamic> json) {
    return ScheduleChangeRequest(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      scheduleDayId: json['scheduleDayId'] as String? ?? '',
      newCheckInTime: json['newCheckInTime'] as String?,
      newLunchStartTime: json['newLunchStartTime'] as String?,
      newLunchEndTime: json['newLunchEndTime'] as String?,
      newCheckOutTime: json['newCheckOutTime'] as String?,
      reason: json['reason'] as String? ?? '',
      status: RequestStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String?),
        orElse: () => RequestStatus.pending,
      ),
      reviewedById: json['reviewedById'] as String?,
      createdAt: dateFromJson(json['createdAt'] as String?),
      updatedAt: dateFromJson(json['updatedAt'] as String?),
      scheduleDay: json['scheduleDay'] != null
          ? ScheduleChangeRequestDay.fromJson(json['scheduleDay'] as Map<String, dynamic>)
          : null,
    );
  }
}
