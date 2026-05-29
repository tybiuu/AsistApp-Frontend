// lib/pages/analytics/components/lateness_bar_chart.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../analytics_controller.dart';

class LatenessBarChart extends StatelessWidget {
  final AnalyticsController controller;

  const LatenessBarChart({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final Color cardBorder = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final Color labelColor = isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
    final Color valueColor = isDark ? Colors.white : const Color(0xff1f2937);

    return Obx(() {
      final data = controller.lateData;
      if (data.isEmpty) {
        return const SizedBox.shrink();
      }

      // Find the maximum value to scale heights
      double maxValue = data.fold<double>(
        0.0,
        (max, item) => item.value > max ? item.value : max,
      );
      if (maxValue == 0) maxValue = 1.0;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Top tardanzas acumuladas'.toUpperCase(),
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
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: cardBorder, width: 1),
            ),
            child: SizedBox(
              height: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: data.map((item) {
                  final double ratio = item.value / maxValue;

                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Value tooltip above the bar
                        Text(
                          '${item.value.toStringAsFixed(0)}m',
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        
                        // Animated Bar Container
                        Expanded(
                          child: FractionallySizedBox(
                            heightFactor: 0.9, // Leave room for top value
                            alignment: Alignment.bottomCenter,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0.0, end: ratio),
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeOutBack,
                              builder: (context, animValue, child) {
                                return FractionallySizedBox(
                                  heightFactor: animValue.clamp(0.0, 1.0),
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF9F0A),
                                          Color(0xFFF59E0B),
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(8),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFF59E0B).withOpacity(0.16),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Name text under the bar
                        Text(
                          item.name,
                          style: TextStyle(
                            color: valueColor,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      );
    });
  }
}
