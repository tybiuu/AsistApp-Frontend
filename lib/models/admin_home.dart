// lib/models/admin_home.dart

import 'organization.dart';
import 'user.dart';

class AdminHomeData {
  final Organization organization;
  final List<AdminSummaryStat> stats;
  final List<AdminRequestSummary> requests;
  final List<User> activeMembers;

  const AdminHomeData({
    required this.organization,
    required this.stats,
    required this.requests,
    required this.activeMembers,
  });

  factory AdminHomeData.fromJson(Map<String, dynamic> json) {
    return AdminHomeData(
      organization: Organization.fromJson(
        json['organization'] ?? <String, dynamic>{},
      ),
      stats: (json['stats'] as List<dynamic>? ?? [])
          .map((item) => AdminSummaryStat.fromJson(item))
          .toList(),
      requests: (json['requests'] as List<dynamic>? ?? [])
          .map((item) => AdminRequestSummary.fromJson(item))
          .toList(),
      activeMembers: (json['active_members'] as List<dynamic>? ?? [])
          .map((item) => User.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'organization': organization.toJson(),
      'stats': stats.map((item) => item.toJson()).toList(),
      'requests': requests.map((item) => item.toJson()).toList(),
      'active_members': activeMembers.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'AdminHomeData{organization: $organization, stats: $stats, requests: $requests, activeMembers: $activeMembers}';
  }
}

class AdminSummaryStat {
  final String label;
  final int value;
  final String type;

  const AdminSummaryStat({
    required this.label,
    required this.value,
    required this.type,
  });

  factory AdminSummaryStat.fromJson(dynamic json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return AdminSummaryStat(
      label: map['label'] as String? ?? '',
      value: map['value'] as int? ?? 0,
      type: map['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'AdminSummaryStat{label: $label, value: $value, type: $type}';
  }
}

class AdminRequestSummary {
  final String title;
  final int count;
  final String type;

  const AdminRequestSummary({
    required this.title,
    required this.count,
    required this.type,
  });

  factory AdminRequestSummary.fromJson(dynamic json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return AdminRequestSummary(
      title: map['title'] as String? ?? '',
      count: map['count'] as int? ?? 0,
      type: map['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'count': count,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'AdminRequestSummary{title: $title, count: $count, type: $type}';
  }
}
