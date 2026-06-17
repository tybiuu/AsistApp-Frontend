// lib/pages/admin_home/admin_new_members/components/member_request_card.dart

import 'package:flutter/material.dart';

import '../../../../models/user.dart';
import '../../../../utils/date_utils.dart';
import '../../../../configs/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor = isDark ? AppColors.chart6 : colors.primary;
    final Color avatarBg = isDark
        ? AppColors.chart6.withValues(alpha: 0.15)
        : colors.primaryContainer;
    final Color badgeColor = isDark ? AppColors.chart6 : colors.primary;

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
                        color: avatarBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.school_outlined,
                        size: 22,
                        color: accentColor,
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
                              fontSize: 17,
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
                              color: badgeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Practicante',
                              style: TextStyle(
                                color: badgeColor,
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
                            'Solicitó: ${formatRequestDate(member.createdAt)}',
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
                      color: AppColors.error,
                      onTap: onReject,
                      isLeft: true,
                    ),
                  ),
                  Container(width: 1, height: 48, color: colors.outlineVariant),
                  Expanded(
                    child: _ActionButton(
                      label: 'Aceptar',
                      icon: Icons.check_circle_outline_rounded,
                      color: isDark ? const Color(0xff04df72) : AppColors.success,
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
                fontSize: 15,
                fontWeight: FontWeight.w900,
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
