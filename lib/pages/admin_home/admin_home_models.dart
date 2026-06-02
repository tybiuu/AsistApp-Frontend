// lib/pages/admin_home/admin_home_models.dart

import 'package:flutter/material.dart';

class MemberMetric {
  final String label;
  final String value;
  final String subtitle;
  final Color valueColor;
  final double? progress;

  const MemberMetric({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.valueColor,
    this.progress,
  });
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
