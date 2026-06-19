import '../utils/date_utils.dart';

enum RequestStatus { pending, approved, rejected }

class AttendanceRequest {
  final String id;
  final String userId;
  final String organizationId;
  final String requestedDate;
  final String reason;
  final RequestStatus status;
  final String? reviewedById;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttendanceRequest({
    required this.id,
    required this.userId,
    required this.organizationId,
    required this.requestedDate,
    required this.reason,
    required this.status,
    this.reviewedById,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceRequest.fromJson(Map<String, dynamic> json) {
    return AttendanceRequest(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      requestedDate: json['requestedDate'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      status: _statusFromJson(json['status'] as String?),
      reviewedById: json['reviewedById'] as String?,
      createdAt: dateFromJson(json['createdAt'] as String?),
      updatedAt: dateFromJson(json['updatedAt'] as String?),
    );
  }

  static RequestStatus _statusFromJson(String? value) =>
      RequestStatus.values.firstWhere(
        (s) => s.name == value,
        orElse: () => RequestStatus.pending,
      );
}
