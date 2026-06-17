// lib/pages/auth/pending_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_top_bar.dart';
import '../../../components/role_badge.dart';
import '../../../configs/routes.dart';
import '../../../configs/theme.dart';
import '../../../services/session_service.dart';
import '../role_select/role_select_controller.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  static const _steps = [
    {'step': '1', 'text': 'El jefe de área revisa tu solicitud', 'done': true},
    {'step': '2', 'text': 'Recibirás un correo con la decisión', 'done': false},
    {'step': '3', 'text': 'Propones tu horario semanal', 'done': false},
    {'step': '4', 'text': '¡Empiezas a usar AsistApp!', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    final args = (Get.arguments as Map<String, dynamic>?) ?? {};
    final String organizationName = args['organizationName'] as String? ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(top: false,
        child: Column(
          children: [
            AppTopBar(
              title: '',
              actions: [
                TextButton(
                  onPressed: () async {
                    await SessionService.to.logout();
                    Get.offAllNamed(AppRoutes.welcome);
                  },
                  child: const Text('Salir'),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.access_time_filled,
                          size: 40,
                          color: AppColors.info,
                        ),
                      ),
                    ),

                    const RoleBadge(
                      role: RoleOption.practitioner,
                      showSubtitle: false,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      'Solicitud enviada',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(text: 'Tu solicitud para unirte a '),
                          TextSpan(
                            text: organizationName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const TextSpan(
                            text:
                                ' está pendiente de aprobación. Te notificaremos cuando el jefe de área la revise.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.12),
                        border: Border.all(
                          color: AppColors.info.withValues(alpha: 0.4),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.info,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pendiente de aprobación',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              Theme.of(context).colorScheme.outlineVariant,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¿Qué sigue?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._steps.map((s) {
                            final bool isDone = s['done'] as bool;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    margin: const EdgeInsets.only(top: 2),
                                    decoration: BoxDecoration(
                                      color: isDone
                                          ? AppColors.chart1
                                          : Theme.of(context)
                                              .colorScheme
                                              .surfaceContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        s['step'] as String,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isDone
                                              ? Colors.white
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      s['text'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDone
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
