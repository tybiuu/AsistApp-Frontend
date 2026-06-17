// lib/components/status_badge.dart

import 'package:asist_app/configs/theme.dart';
import 'package:flutter/material.dart';

enum BadgeStatus { confirmed, pending, rejected }

/// Small pill badge that communicates a request or schedule status.
///
/// Supply either a [BadgeStatus] value via [status], or a raw [label] +
/// [color] pair for custom use cases.
class StatusBadge extends StatelessWidget {
  final BadgeStatus? status;

  /// Override label and color when [status] is null.
  final String? customLabel;
  final Color? customColor;

  const StatusBadge({
    super.key,
    this.status,
    this.customLabel,
    this.customColor,
  }) : assert(status != null || (customLabel != null && customColor != null));

  @override
  Widget build(BuildContext context) {
    final (String label, Color fg) = _resolve();
    final Color bg = fg.withValues(alpha: 0.12);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  (String, Color) _resolve() {
    if (status == null) return (customLabel!, customColor!);
    switch (status!) {
      case BadgeStatus.confirmed:
        return ('Confirmado', AppColors.success);
      case BadgeStatus.pending:
        return ('Pendiente',  AppColors.info);
      case BadgeStatus.rejected:
        return ('Rechazado', AppColors.error);
    }
  }
}
