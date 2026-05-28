// lib/models/organization.dart

import '../utils/date_utils.dart';

class Organization {
  final String id;
  final String name;
  final String code;
  final String? photoUrl;
  final String? description;
  final int lateTimeLimit;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Organization({
    required this.id,
    required this.name,
    required this.code,
    this.photoUrl,
    this.description,
    required this.lateTimeLimit,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Organization.fromJson(dynamic json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return Organization(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      code: map['code'] as String? ?? '',
      photoUrl: map['photo_url'] as String?,
      description: map['description'] as String?,
      lateTimeLimit: map['late_time_limit'] as int? ?? 0,
      createdAt: dateFromJson(map['created_at'] as String?),
      updatedAt: dateFromJson(map['updated_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'photo_url': photoUrl,
      'description': description,
      'late_time_limit': lateTimeLimit,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Organization{id: $id, name: $name, code: $code, photoUrl: $photoUrl, description: $description, lateTimeLimit: $lateTimeLimit, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
