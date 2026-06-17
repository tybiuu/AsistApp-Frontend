import 'package:flutter/material.dart';

class AttendanceStep {
  final String label;
  final String action;
  final Color color;
  final IconData icon;
  final String scheduled;

  AttendanceStep({
    required this.label,
    required this.action,
    required this.color,
    required this.icon,
    required this.scheduled,
  });
}
