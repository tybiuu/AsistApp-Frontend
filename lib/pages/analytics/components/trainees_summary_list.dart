// lib/pages/analytics/components/trainees_summary_list.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../analytics_controller.dart';
import '../../../configs/routes.dart';

class TraineesSummaryList extends StatelessWidget {
  final AnalyticsController controller;

  const TraineesSummaryList({super.key, required this.controller});

  Color _hoursColor(int pct) {
    if (pct >= 90) return const Color(0xFF22C55E); // bg-green-500
    if (pct >= 70) return const Color(0xFFF59E0B); // bg-orange-400 (amber)
    return const Color(0xFFEF4444); // bg-red-500
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final Color cardBorder = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final Color textColor = isDark ? const Color(0xfff3f4f6) : const Color(0xff1f2937);

    return Obx(() {
      if (controller.members.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Resumen del mes — Practicantes'.toUpperCase(),
                style: TextStyle(
                  color: isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.members.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final m = controller.members[index];
              
              return InkWell(
                onTap: () {
                  // Find the original User model to pass it as argument
                  final originalUser = controller.trainees.firstWhereOrNull((t) => t.id == m.id);
                  if (originalUser != null) {
                    Get.toNamed(AppRoutes.adminMemberDetail, arguments: originalUser);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorder, width: 1),
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6A00), // App orange
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          m.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Progress info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.name,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                // Progress bar
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: SizedBox(
                                      height: 6,
                                      child: LinearProgressIndicator(
                                        value: m.pct / 100.0,
                                        backgroundColor: isDark ? const Color(0xff242836) : const Color(0xfff3f4f6),
                                        valueColor: AlwaysStoppedAnimation<Color>(_hoursColor(m.pct)),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                
                                // Hours indicator
                                Text(
                                  '${m.hours.toStringAsFixed(0)}h',
                                  style: TextStyle(
                                    color: _hoursColor(m.pct),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      
                      // Percentage Text
                      Text(
                        '${m.pct}%',
                        style: const TextStyle(
                          color: Color(0xff9ca3af),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      );
    });
  }
}
