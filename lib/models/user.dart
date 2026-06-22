// lib/models/user.dart

import '../utils/date_utils.dart';
import '../utils/label_utils.dart';

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

  factory User.fromJson(dynamic json) {
    final Map<String, dynamic> map = json as Map<String, dynamic>;
    return User(
      id: map['id'] as String? ?? '',
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      institutionalEmail: map['institutionalEmail'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      career: map['career'] as String?,
      cycle: map['cycle'] as int?,
      organizationId: map['organizationId'] as String?,
      role: _roleFromJson(map['role'] as String?),
      status: _statusFromJson(map['status'] as String?),
      deviceToken: map['deviceToken'] as String?,
      createdAt: dateFromJson(map['createdAt'] as String?),
      updatedAt: dateFromJson(map['updatedAt'] as String?),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'institutionalEmail': institutionalEmail,
    'phoneNumber': phoneNumber,
    'career': career,
    'cycle': cycle,
    'organizationId': organizationId,
    'role': role.name,
    'status': status.name,
    'deviceToken': deviceToken,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? institutionalEmail,
    String? phoneNumber,
    String? career,
    int? cycle,
    String? organizationId,
    UserRole? role,
    UserStatus? status,
    String? deviceToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      institutionalEmail: institutionalEmail ?? this.institutionalEmail,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      career: career ?? this.career,
      cycle: cycle ?? this.cycle,
      organizationId: organizationId ?? this.organizationId,
      role: role ?? this.role,
      status: status ?? this.status,
      deviceToken: deviceToken ?? this.deviceToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName'.trim();

  String get initials {
    final String firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final String lastInitial = lastName.isNotEmpty ? lastName[0] : '';
    return '$firstInitial$lastInitial'.toUpperCase();
  }

  String get academicDetail {
    final String careerText = career ?? 'Sin carrera';
    final String cycleText = cycle != null ? cicloLabel(cycle!) : 'Sin ciclo';
    return '$careerText · $cycleText';
  }

  static UserRole _roleFromJson(String? value) => UserRole.values.firstWhere(
    (role) => role.name == value,
    orElse: () => UserRole.trainee,
  );

  static UserStatus _statusFromJson(String? value) => UserStatus.values.firstWhere(
    (status) => status.name == value,
    orElse: () => UserStatus.pending,
  );

  @override
  String toString() =>
      'User{id: $id, firstName: $firstName, lastName: $lastName, '
      'institutionalEmail: $institutionalEmail, phoneNumber: $phoneNumber, '
      'career: $career, cycle: $cycle, organizationId: $organizationId, '
      'role: $role, status: $status, deviceToken: $deviceToken, '
      'createdAt: $createdAt, updatedAt: $updatedAt}';
}

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
