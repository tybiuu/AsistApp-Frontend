import '../models/user.dart';

User? findTrainee(List<User> trainees, String userId) {
  for (final trainee in trainees) {
    if (trainee.id == userId) return trainee;
  }
  return null;
}

String traineeInitials(User? trainee) {
  if (trainee == null) return '--';
  return trainee.initials;
}

String traineeFullName(User? trainee) {
  if (trainee == null) return 'Practicante no encontrado';
  return trainee.fullName;
}

String traineeCareerText(User? trainee) {
  if (trainee == null) return 'Practicante';
  final career = trainee.career ?? 'Sin carrera';
  final cycle = trainee.cycle?.toString() ?? '-';
  return '$career · ${cycle}mo ciclo';
}
