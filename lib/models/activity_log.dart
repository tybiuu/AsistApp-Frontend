// lib/models/activity_log.dart

import '../utils/date_utils.dart';

enum LogCategory { attendance, schedule, members }

class ActivityLog {
  final String id;
  final String organizationId;
  final String performedById;
  final String affectedUserId;
  final String title;
  final LogCategory category;
  final DateTime createdAt;

  const ActivityLog({
    required this.id,
    required this.organizationId,
    required this.performedById,
    required this.affectedUserId,
    required this.title,
    required this.category,
    required this.createdAt,
  });

  factory ActivityLog.fromJson(Map<String, dynamic> json) {
    return ActivityLog(
      id: json['id'] as String? ?? '',
      organizationId: json['organizationId'] as String? ?? '',
      performedById: json['performedById'] as String? ?? '',
      affectedUserId: json['affectedUserId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      category: _categoryFromJson(json['category'] as String?),
      createdAt: dateFromJson(json['createdAt'] as String?),
    );
  }

  static LogCategory _categoryFromJson(String? value) =>
      LogCategory.values.firstWhere(
        (c) => c.name == value,
        orElse: () => LogCategory.attendance,
      );
}
