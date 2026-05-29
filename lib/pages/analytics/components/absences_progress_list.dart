// lib/pages/analytics/components/absences_progress_list.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../analytics_controller.dart';

class AbsencesProgressList extends StatelessWidget {
  final AnalyticsController controller;

  const AbsencesProgressList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final Color cardBorder = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final Color labelColor = isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
    final Color textColor = isDark ? const Color(0xfff3f4f6) : const Color(0xff1f2937);

    return Obx(() {
      final data = controller.absentData;
      if (data.isEmpty) {
        return const SizedBox.shrink();
      }

      // Find max absences to scale the bars nicely, default to 4 as in the React mock data
      double maxAbsences = data.fold<double>(
        4.0,
        (max, item) => item.value > max ? item.value : max,
      );
      if (maxAbsences == 0) maxAbsences = 4.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Top inasistencias'.toUpperCase(),
                style: TextStyle(
                  color: labelColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: cardBorder, width: 1),
            ),
            child: Column(
              children: data.map((d) {
                final double progress = (d.value / maxAbsences).clamp(0.0, 1.0);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Trainee Name
                      SizedBox(
                        width: 80,
                        child: Text(
                          d.name,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Progress Bar
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            height: 10,
                            color: isDark ? const Color(0xff242836) : const Color(0xfff3f4f6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.0, end: progress),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                builder: (context, animVal, child) {
                                  return FractionallySizedBox(
                                    widthFactor: animVal,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444), // red-500
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Days text
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${d.value.toStringAsFixed(0)}d',
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList()..removeLast()..add(
                // Re-add last item without bottom padding
                Padding(
                  padding: EdgeInsets.zero,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          data.last.name,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            height: 10,
                            color: isDark ? const Color(0xff242836) : const Color(0xfff3f4f6),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.0, end: (data.last.value / maxAbsences).clamp(0.0, 1.0)),
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeInOut,
                                builder: (context, animVal, child) {
                                  return FractionallySizedBox(
                                    widthFactor: animVal,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 24,
                        child: Text(
                          '${data.last.value.toStringAsFixed(0)}d',
                          style: const TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
