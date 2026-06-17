// Shared helpers for extracting display data from trainee JSON maps.

Map<String, dynamic>? findTrainee(
  List<Map<String, dynamic>> trainees,
  String userId,
) {
  for (final trainee in trainees) {
    if (trainee['id'] == userId) return trainee;
  }
  return null;
}

String traineeInitials(Map<String, dynamic>? trainee) {
  if (trainee == null) return '--';
  final first = trainee['first_name']?.toString() ?? '';
  final last = trainee['last_name']?.toString() ?? '';
  final f = first.isNotEmpty ? first[0] : '';
  final l = last.isNotEmpty ? last[0] : '';
  return '$f$l'.toUpperCase();
}

String traineeFullName(Map<String, dynamic>? trainee) {
  if (trainee == null) return 'Practicante no encontrado';
  final first = trainee['first_name']?.toString() ?? '';
  final last = trainee['last_name']?.toString() ?? '';
  return '$first $last'.trim();
}

String traineeCareerText(Map<String, dynamic>? trainee) {
  if (trainee == null) return 'Practicante';
  final career = trainee['career']?.toString() ?? 'Sin carrera';
  final cycle = trainee['cycle']?.toString() ?? '-';
  return '$career · ${cycle}mo ciclo';
}
