// lib/utils/date_utils.dart

DateTime dateFromJson(String? value) =>
    DateTime.tryParse(value ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);

String formatRequestDate(DateTime date) {
  final DateTime now = DateTime.now();
  final int displayHour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final String minute = date.minute.toString().padLeft(2, '0');
  final String period = date.hour < 12 ? 'AM' : 'PM';

  final bool isToday =
      date.year == now.year && date.month == now.month && date.day == now.day;
  if (isToday) return 'Hoy, $displayHour:$minute $period';

  final DateTime yesterday = now.subtract(const Duration(days: 1));
  if (date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day) {
    return 'Ayer, $displayHour:$minute $period';
  }

  const List<String> months = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
  ];
  return '${date.day} ${months[date.month - 1]}, $displayHour:$minute $period';
}
