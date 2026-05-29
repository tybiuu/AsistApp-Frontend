// lib/pages/admin_analytics/components/distribution_donut_chart.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../admin_analytics_controller.dart';

class DistributionDonutChart extends StatelessWidget {
  final AdminAnalyticsController controller;

  const DistributionDonutChart({super.key, required this.controller});

  Color _parseColor(String hex) {
    try {
      final String cleanHex = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleanHex', radix: 16));
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardBg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final Color cardBorder = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final Color labelColor = isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280);
    final Color textColor = isDark ? const Color(0xfff3f4f6) : const Color(0xff1f2937);

    return Obx(() {
      final segments = controller.pieData;
      final int totalValue = segments.fold<int>(0, (sum, item) => sum + item.value);

      if (segments.isEmpty || totalValue == 0) {
        return const SizedBox.shrink();
      }

      // Convert segments to fractions
      final List<double> values = [];
      final List<Color> colors = [];
      for (final s in segments) {
        values.add(s.value / totalValue);
        colors.add(_parseColor(s.colorHex));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Distribución general del mes'.toUpperCase(),
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
              children: [
                // Custom Donut Chart Container
                SizedBox(
                  height: 160,
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.decelerate,
                      builder: (context, animVal, child) {
                        return CustomPaint(
                          size: const Size(140, 140),
                          painter: _DonutChartPainter(
                            fractions: values,
                            colors: colors,
                            animationValue: animVal,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2x2 Legend Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: segments.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 22,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final item = segments[index];
                    final color = _parseColor(item.colorHex);

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: '${item.name}: ',
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 11,
                              ),
                              children: [
                                TextSpan(
                                  text: item.value.toString(),
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<double> fractions;
  final List<Color> colors;
  final double animationValue;

  _DonutChartPainter({
    required this.fractions,
    required this.colors,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = math.min(size.width, size.height) / 2.0;
    final Offset center = Offset(size.width / 2.0, size.height / 2.0);

    final double thickness = radius * 0.32; // Thickness of the donut ring
    final Rect rect = Rect.fromCircle(center: center, radius: radius - (thickness / 2.0));

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..isAntiAlias = true;

    double startAngle = -math.pi / 2.0; // Start at top center (-90 degrees)
    const double paddingAngle = 0.04; // Small gap between segments in radians

    for (int i = 0; i < fractions.length; i++) {
      final double fraction = fractions[i] * animationValue;
      if (fraction <= 0) continue;

      double sweepAngle = fraction * 2.0 * math.pi;

      // Deduct padding angle to create a nice segmented look, but only if segment is wide enough
      if (sweepAngle > paddingAngle * 2) {
        sweepAngle -= paddingAngle;
        startAngle += paddingAngle / 2.0;
      }

      paint.color = colors[i];
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      // Restore sweep & start angle for calculations
      if (sweepAngle > 0) {
        startAngle += sweepAngle + (paddingAngle / 2.0);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.fractions != fractions ||
        oldDelegate.colors != colors;
  }
}
