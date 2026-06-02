// lib/components/status_badge.dart

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final (String label, Color fg) = _resolve(isDark);
    final Color bg = fg.withValues(alpha: isDark ? 0.18 : 0.10);

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

  (String, Color) _resolve(bool isDark) {
    if (status == null) return (customLabel!, customColor!);
    switch (status!) {
      case BadgeStatus.confirmed:
        return ('Confirmado', const Color(0xff16a34a));
      case BadgeStatus.pending:
        return ('Pendiente',  const Color(0xff1d4ed8));
      case BadgeStatus.rejected:
        return ('Rechazado', const Color(0xffef4444));
    }
  }
}
