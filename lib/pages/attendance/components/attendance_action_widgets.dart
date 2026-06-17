import 'package:flutter/material.dart';

import '../../../configs/theme.dart';
import 'attendance_step.dart';

class AttendanceActionButton extends StatelessWidget {
  final AttendanceStep step;
  final VoidCallback onTap;

  const AttendanceActionButton({super.key, required this.step, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: step.color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(step.icon, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Text(
              step.action,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontFamily: 'RobotoMono',
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceConfirmCard extends StatelessWidget {
  const AttendanceConfirmCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 28),
          SizedBox(width: 10),
          Text(
            '¡Registrado!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class AttendanceDoneCard extends StatelessWidget {
  const AttendanceDoneCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 32),
          SizedBox(height: 8),
          Text(
            'Jornada completada',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
          ),
          SizedBox(height: 2),
          Text(
            'Todos los registros marcados',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
