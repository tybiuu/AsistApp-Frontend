// lib/pages/profile/components/solicitudes_section.dart

import 'package:flutter/material.dart';

import '../../../components/status_badge.dart';

/// Model for a single practitioner request.
class SolicitudItem {
  final String type;
  final String date;
  final BadgeStatus status;

  const SolicitudItem({
    required this.type,
    required this.date,
    required this.status,
  });
}

/// Section that lists request cards + the "request absence" action row.
///
/// [solicitudes]    — list of items to show.
/// [onRequestAbsence] — callback for the absence request button.
class SolicitudesSection extends StatelessWidget {
  final List<SolicitudItem> solicitudes;
  final VoidCallback? onRequestAbsence;

  const SolicitudesSection({
    super.key,
    required this.solicitudes,
    this.onRequestAbsence,
  });

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...solicitudes.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _SolicitudCard(item: s, isDark: isDark),
        )),
        _RequestAbsenceRow(isDark: isDark, onTap: onRequestAbsence),
      ],
    );
  }
}

// ── Solicitud card ────────────────────────────────────────────────────────────

class _SolicitudCard extends StatelessWidget {
  final SolicitudItem item;
  final bool isDark;

  const _SolicitudCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final value = isDark ? Colors.white : const Color(0xff1f2937);
    final muted = isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.type,
                  style: TextStyle(color: value, fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(item.date, style: TextStyle(color: muted, fontSize: 12)),
              ],
            ),
          ),
          StatusBadge(status: item.status),
        ],
      ),
    );
  }
}

// ── Request absence row ───────────────────────────────────────────────────────

class _RequestAbsenceRow extends StatelessWidget {
  final bool isDark;
  final VoidCallback? onTap;

  const _RequestAbsenceRow({required this.isDark, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final value = isDark ? Colors.white : const Color(0xff1f2937);
    final muted = isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xffe15d27), size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Solicitar asistencia faltante',
                style: TextStyle(color: value, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: muted, size: 18),
          ],
        ),
      ),
    );
  }
}
