import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/app_top_bar.dart';
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Obx(() => Text(
                  '${c.requests.length} solicitudes de horario pendientes',
                  style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
                )),
              ),
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: c.requests.length,
                itemBuilder: (context, index) {
                  final req = c.requests[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: const Color(0xffe15d27), // AppColors.chart1
                              child: Text(req.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(req.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffe15d27).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(req.type, style: const TextStyle(color: Color(0xffe15d27), fontSize: 10, fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  ),
                                  Text('${req.career} • ${cicloLabel(req.ciclo)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildMetaChip(context, Icons.timelapse_rounded, '${req.targetHours}h / sem'),
                            _buildMetaChip(context, Icons.calendar_view_week_rounded, '${req.changedDaysCount} días'),
                            _buildMetaChip(context, Icons.calendar_today_outlined, req.time),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${req.reason}"',
                          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12, color: Colors.grey, height: 1.3),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () => c.viewDetails(req),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xffe15d27)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Ver horario completo >', style: TextStyle(color: Color(0xffe15d27), fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => c.actionReject(req.id),
                                child: const Text('Denegar', style: TextStyle(color: Color(0xffef4444), fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () => c.actionApprove(req.id),
                                child: const Text('Aprobar', style: TextStyle(color: Color(0xff10b981), fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMetaChip(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}