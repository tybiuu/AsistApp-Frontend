// lib/pages/admin_home/components/admin_home_summary.dart

class AdminSummaryStat {
  final String label;
  final int value;
  final String type;

  const AdminSummaryStat({
    required this.label,
    required this.value,
    required this.type,
  });
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
}
