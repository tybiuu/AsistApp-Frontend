// lib/pages/admin_analytics/components/metric_cards_grid.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_analytics_controller.dart';

class MetricCardsGrid extends StatelessWidget {
  final AdminAnalyticsController controller;

  const MetricCardsGrid({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Resumen del mes'.toUpperCase(),
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
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.45,
            children: [
              _LocalMetricCard(
                label: 'Asistencias confirmadas',
                value: controller.confirmedCount.value.toString(),
                color: const Color(0xFF22C55E), // green
                isDark: isDark,
              ),
              _LocalMetricCard(
                label: 'Puntualidad promedio',
                value: '${controller.punctualityPct.value}%',
                color: const Color(0xFFF59E0B), // orange/amber
                isDark: isDark,
              ),
              _LocalMetricCard(
                label: 'Total tardanzas',
                value: controller.totalLates.value.toString(),
                color: const Color(0xFFF59E0B), // amber
                isDark: isDark,
              ),
              _LocalMetricCard(
                label: 'Total inasistencias',
                value: controller.totalAbsences.value.toString(),
                color: const Color(0xFFEF4444), // red
                isDark: isDark,
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _LocalMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  const _LocalMetricCard({
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final Color border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final Color titleColor = isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
    final Color valueColor = isDark ? Colors.white : const Color(0xff1f2937);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with indicator accent
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
        ],
      ),
    );
  }
}
