// lib/pages/admin_setup_success/admin_setup_success_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/primary_button.dart';
import '../../configs/theme.dart';
import 'admin_setup_success_controller.dart';

class AdminSetupSuccessPage extends StatelessWidget {
  const AdminSetupSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminSetupSuccessController());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final AdminSetupSuccessController control = Get.find();
    final ColorScheme colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 84, 24, 28),
              child: Column(
                children: [
                  const _SuccessIcon(),
                  const SizedBox(height: 24),
                  Text(
                    '¡Tu organización está\nlista!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    control.organizationName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.chart1,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _CodeCard(),
                  const SizedBox(height: 18),
                  Text(
                    'Comparte este código con tus practicantes y validadores para que puedan unirse.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    text: 'Ir al inicio',
                    onPressed: control.goHome,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 18,
            color: colors.surfaceContainerLow,
            alignment: Alignment.center,
            child: Container(
              width: 98,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: AppColors.chart2.withValues(alpha: 0.18),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_circle_outline_rounded,
        color: AppColors.chart2,
        size: 42,
      ),
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard();

  @override
  Widget build(BuildContext context) {
    final AdminSetupSuccessController control = Get.find();
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.chart1.withValues(alpha: 0.55),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.14),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'CÓDIGO DE ORGANIZACIÓN',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            control.organizationCode,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.chart1,
              fontSize: 27,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton.icon(
              onPressed: control.copyCode,
              icon: const Icon(Icons.copy_rounded, size: 15),
              label: const Text('Copiar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.chart1,
                side: const BorderSide(color: AppColors.chart1, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
