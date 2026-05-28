// lib/components/member_request_card.dart

import 'package:flutter/material.dart';

import '../models/user.dart';

class MemberRequestCard extends StatelessWidget {
  final User member;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onTap;

  const MemberRequestCard({
    super.key,
    required this.member,
    this.onAccept,
    this.onReject,
    this.onTap,
  });

  String _formatRequestDate(DateTime date) {
    final DateTime now = DateTime.now();
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour < 12 ? 'AM' : 'PM';
    final int displayHour = date.hour % 12 == 0 ? 12 : date.hour % 12;

    if (isToday) {
      return 'Hoy, $displayHour:$minute $period';
    }

    final DateTime yesterday = now.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Ayer, $displayHour:$minute $period';
    }

    const List<String> months = [
      'ene', 'feb', 'mar', 'abr', 'may', 'jun',
      'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
    ];
    return '${date.day} ${months[date.month - 1]}, $displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: colors.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        size: 22,
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            member.fullName,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xffe15d27).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Practicante',
                              style: TextStyle(
                                color: Color(0xffe15d27),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            member.academicDetail,
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Solicitó: ${_formatRequestDate(member.createdAt)}',
                            style: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colors.onSurfaceVariant,
                      size: 20,
                    ),
                  ],
                ),
              ),
              Container(height: 1, color: colors.outlineVariant),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'Rechazar',
                      icon: Icons.cancel_outlined,
                      color: colors.error,
                      onTap: onReject,
                      isLeft: true,
                    ),
                  ),
                  Container(width: 1, height: 48, color: colors.outlineVariant),
                  Expanded(
                    child: _ActionButton(
                      label: 'Aceptar',
                      icon: Icons.check_circle_outline_rounded,
                      color: const Color(0xff16a34a),
                      onTap: onAccept,
                      isLeft: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool isLeft;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        bottomLeft: isLeft ? const Radius.circular(16) : Radius.zero,
        bottomRight: isLeft ? Radius.zero : const Radius.circular(16),
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (!isLeft) ...[
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_rounded, size: 14, color: color),
            ],
          ],
        ),
      ),
    );
  }
}
