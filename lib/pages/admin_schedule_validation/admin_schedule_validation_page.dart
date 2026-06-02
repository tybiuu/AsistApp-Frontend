import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
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
            const AppTopBar(
              title: 'Cambios de horario',
              showBack: true,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3 solicitudes de horario pendientes',
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Text(
                                        req.initials,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
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
                                        const SizedBox(height: 4),
                                        Text(
                                          req.career,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.schedule, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${req.targetHours}h / sem',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${req.changedDaysCount} días',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            req.time,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                '"${req.reason}"',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 12,
                                  color: Colors.grey,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => c.viewDetails(req),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          side: BorderSide(
                                            color: theme.colorScheme.outline,
                                          ),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Ver horario completo',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => c.actionReject(req.id),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        side: const BorderSide(
                                          color: Color(0xffef4444),
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Denegar',
                                        style: TextStyle(
                                          color: Color(0xffef4444),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () => c.actionApprove(req.id),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff10b981),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Aprobar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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