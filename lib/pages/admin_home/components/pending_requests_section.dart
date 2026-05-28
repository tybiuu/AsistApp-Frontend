// lib/pages/admin_home/components/pending_requests_section.dart

import 'package:flutter/material.dart';

import '../../../components/admin_request_card.dart';
import '../admin_home_controller.dart';
import 'admin_home_summary.dart';

class PendingRequestsSection extends StatelessWidget {
  final AdminHomeController controller;
  final List<AdminRequestSummary> requests;

  const PendingRequestsSection({
    super.key,
    required this.controller,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Solicitudes pendientes',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...requests.map(
          (request) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AdminRequestCard(
              request: request,
              onTap: () => controller.openRequest(request),
            ),
          ),
        ),
      ],
    );
  }
}
