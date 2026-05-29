import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../components/info_card.dart';
import '../../components/status_badge.dart';
import '../../models/schedule.dart';
import 'admin_schedule_validation_controller.dart';

class AdminScheduleValidationPage extends StatelessWidget {
  const AdminScheduleValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AdminScheduleValidationController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff0f1117) : const Color(0xffffffff),
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(title: 'Cambios de horario'),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solicitudes de horario',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          '${c.requests.length} solicitudes cargadas desde los JSONs de assets',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                      ],
                    ),
                  ),
                  Obx(() => StatusBadge(
                    status: c.requests.isEmpty
                        ? BadgeStatus.confirmed
                        : BadgeStatus.pending,
                  )),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (c.requests.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay solicitudes disponibles',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: c.requests.length,
                  itemBuilder: (context, index) {
                    final req = c.requests[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  req.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              StatusBadge(status: _badgeStatus(req.status)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          InfoCard(
                            title: 'Solicitud ${req.id}',
                            actionLabel: 'Ver detalle',
                            actionIcon: Icons.open_in_new,
                            onAction: () => c.viewDetails(req),
                            rows: [
                              InfoRowData(
                                icon: Icons.school,
                                label: 'Carrera',
                                value: req.career,
                              ),
                              InfoRowData(
                                icon: Icons.timeline,
                                label: 'Ciclo',
                                value: cicloLabel(req.ciclo),
                              ),
                              InfoRowData(
                                icon: Icons.schedule,
                                label: 'Horas semanales',
                                value: '${req.targetHours}h',
                              ),
                              InfoRowData(
                                icon: Icons.calendar_today,
                                label: 'Días modificados',
                                value: '${req.changedDaysCount}',
                              ),
                              InfoRowData(
                                icon: Icons.access_time,
                                label: 'Fecha de envío',
                                value: req.time,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '"${req.reason}"',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Colors.grey,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () => c.actionReject(req.id),
                                  child: const Text(
                                    'Denegar',
                                    style: TextStyle(
                                      color: Color(0xffef4444),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () => c.actionApprove(req.id),
                                  child: const Text(
                                    'Aprobar',
                                    style: TextStyle(
                                      color: Color(0xff10b981),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  BadgeStatus _badgeStatus(String status) {
    switch (status) {
      case 'approved':
        return BadgeStatus.confirmed;
      case 'rejected':
        return BadgeStatus.rejected;
      default:
        return BadgeStatus.pending;
    }
  }
}