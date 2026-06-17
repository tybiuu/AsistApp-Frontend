import 'package:flutter/material.dart';

import 'trainee_card_widgets.dart';

class MissingCard extends StatelessWidget {
  final String initials;
  final String name;
  final String career;

  const MissingCard({
    super.key,
    required this.initials,
    required this.name,
    required this.career,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const blueColor = Color(0xFF3B82F6);

    return CustomPaint(
      painter: _DashedBorderPainter(color: blueColor.withValues(alpha: 0.5)),
      child: Container(
        decoration: BoxDecoration(
          color: blueColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  TraineeAvatar(initials: initials),
                  const SizedBox(width: 12),
                  Expanded(child: TraineePersonInfo(name: name, career: career)),
                  const TraineeStatusBadge(
                    text: 'Sin marcar',
                    color: blueColor,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: List.generate(4, (i) {
                  const labels = ['ING.', 'S.REF', 'R.REF', 'SAL.'];
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: i < 3 ? 6 : 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              labels[i],
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '-',
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

// ── Dashed border painter ─────────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  final Color color;

  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const radius = Radius.circular(18);
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(Offset.zero & size, radius));

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + 6),
          Offset.zero,
        );
        distance += 10;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
