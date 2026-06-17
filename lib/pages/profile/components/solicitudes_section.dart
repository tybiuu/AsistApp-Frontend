// lib/pages/profile/components/solicitudes_section.dart

import 'package:flutter/material.dart';

import '../../../components/status_badge.dart';
import '../../../configs/theme.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...solicitudes.map((s) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _SolicitudCard(item: s),
        )),
        _RequestAbsenceRow(onTap: onRequestAbsence),
      ],
    );
  }
}

// ── Solicitud card ────────────────────────────────────────────────────────────

class _SolicitudCard extends StatelessWidget {
  final SolicitudItem item;

  const _SolicitudCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surface;
    final border = Theme.of(context).colorScheme.outlineVariant;
    final value = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

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
  final VoidCallback? onTap;

  const _RequestAbsenceRow({this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surface;
    final border = Theme.of(context).colorScheme.outlineVariant;
    final value = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.chart1, size: 18),
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
        ),
      ),
    );
  }
}
