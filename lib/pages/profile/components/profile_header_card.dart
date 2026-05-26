// lib/pages/profile/components/profile_header_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/theme.dart';
import '../profile_controller.dart';
import '../profile_schedule.dart';

/// Top card: avatar, name, "Practicante" badge, and the three stats.
class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xff1A1D27) : Colors.white;
    final border = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final muted = isDark ? const Color(0xff6b7280) : const Color(0xff9ca3af);
    final onCard = isDark ? Colors.white : const Color(0xff1f2937);

    return Obx(() {
      final u = c.user.value;
      return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.chart1,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x33e15d27),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              u?.initials ?? '',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Full name
          Text(
            u?.fullName ?? '',
            style: TextStyle(
              color: onCard,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),

          // Badge + org
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.chart1.withValues(alpha: isDark ? 0.18 : 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Practicante',
                  style: TextStyle(
                    color: isDark ? const Color(0xfffb923c) : AppColors.chart1,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Empresa XYZ S.A.C.',
                style: TextStyle(color: muted, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _Stat(value: '92%', label: 'Asistencia', color: AppColors.chart1),
              _Divider(color: border),
              _Stat(value: '142h', label: 'Completadas', color: onCard),
              _Divider(color: border),
              _Stat(value: cicloLabel(c.cycle), label: 'Ciclo', color: onCard),
            ],
          ),
        ],
      ),
    );
    });
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  final Color  color;

  const _Stat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xff6b7280)
        : const Color(0xff9ca3af);

    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: muted, fontSize: 10)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: color);
}
