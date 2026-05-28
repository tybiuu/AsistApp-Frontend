// lib/pages/admin_config/components/organization_code_card.dart

import 'package:flutter/material.dart';

import '../../../configs/theme.dart';
import '../../../models/organization.dart';
import '../admin_config_controller.dart';

class OrganizationCodeCard extends StatelessWidget {
  final AdminConfigController controller;
  final Organization organization;

  const OrganizationCodeCard({
    super.key,
    required this.controller,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.chart1.withValues(alpha: 0.45),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'CÓDIGO DE ORGANIZACIÓN',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            organization.code,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.chart1,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: controller.copyOrganizationCode,
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text('Copiar'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.chart1,
              side: const BorderSide(color: AppColors.chart1, width: 1.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
