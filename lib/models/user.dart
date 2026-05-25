// lib/models/user.dart

enum UserRole {
  admin,
  trainee,
}

enum UserStatus {
  pending,
  active,
  rejected,
}

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String institutionalEmail;
  final String phoneNumber;
  final String? career;
  final int? cycle;
  final String? organizationId;
  final UserRole role;
  final UserStatus status;
  final String? deviceToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.institutionalEmail,
    required this.phoneNumber,
    this.career,
    this.cycle,
    this.organizationId,
    required this.role,
    required this.status,
    this.deviceToken,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final String firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final String lastInitial = lastName.isNotEmpty ? lastName[0] : '';
    return '$firstInitial$lastInitial'.toUpperCase();
  }

  String get academicDetail {
    final String careerText = career ?? 'Sin carrera';
    final String cycleText = cycle != null ? '${cycle}mo' : 'Sin ciclo';
    return '$careerText · $cycleText';
  }

  factory User.fromJson(dynamic json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return User(
      id: map['id'] as String? ?? '',
      firstName: map['first_name'] as String? ?? '',
      lastName: map['last_name'] as String? ?? '',
      institutionalEmail: map['institutional_email'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      career: map['career'] as String?,
      cycle: map['cycle'] as int?,
      organizationId: map['organization_id'] as String?,
      role: _roleFromJson(map['role'] as String?),
      status: _statusFromJson(map['status'] as String?),
      deviceToken: map['device_token'] as String?,
      createdAt: _dateFromJson(map['created_at'] as String?),
      updatedAt: _dateFromJson(map['updated_at'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'institutional_email': institutionalEmail,
      'phone_number': phoneNumber,
      'career': career,
      'cycle': cycle,
      'organization_id': organizationId,
      'role': role.name,
      'status': status.name,
      'device_token': deviceToken,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  static UserRole _roleFromJson(String? value) {
    return UserRole.values.firstWhere(
      (role) => role.name == value,
      orElse: () => UserRole.trainee,
    );
  }

  static UserStatus _statusFromJson(String? value) {
    return UserStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => UserStatus.pending,
    );
  }

  static DateTime _dateFromJson(String? value) {
    return DateTime.tryParse(value ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, institutionalEmail: $institutionalEmail, phoneNumber: $phoneNumber, career: $career, cycle: $cycle, organizationId: $organizationId, role: $role, status: $status, deviceToken: $deviceToken, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
