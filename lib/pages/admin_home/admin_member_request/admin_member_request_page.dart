// lib/pages/admin_home/admin_member_request/admin_member_request_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_top_bar.dart';
import '../../../components/primary_button.dart';
import '../../../models/user.dart';
import 'admin_member_request_controller.dart';

class AdminMemberRequestPage extends StatelessWidget {
  const AdminMemberRequestPage({super.key});

  String _formatRequestDate(DateTime date) {
    final DateTime now = DateTime.now();
    final bool isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    final int displayHour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final String minute = date.minute.toString().padLeft(2, '0');
    final String period = date.hour < 12 ? 'AM' : 'PM';

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
    final AdminMemberRequestController controller =
        Get.put(AdminMemberRequestController());
    final ColorScheme colors = Theme.of(context).colorScheme;
    final User member = controller.member;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(title: 'Solicitud de ingreso', showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.outlineVariant),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xff374151),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  member.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.fullName,
                                    style: TextStyle(
                                      color: colors.onSurface,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
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
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Divider(color: colors.outlineVariant, height: 1),
                          const SizedBox(height: 16),
                          _InfoRow(
                            label: 'Correo',
                            value: member.institutionalEmail,
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _InfoRow(
                            label: 'Celular',
                            value: member.phoneNumber.isNotEmpty
                                ? member.phoneNumber
                                : '—',
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _InfoRow(
                            label: 'Solicitó',
                            value: _formatRequestDate(member.createdAt),
                            icon: Icons.calendar_today_outlined,
                            colors: colors,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      variant: PrimaryButtonVariant.primary,
                      onPressed: controller.acceptMember,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle_outline_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Aceptar solicitud'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _RejectButton(onPressed: controller.rejectMember),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final ColorScheme colors;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.colors,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
          ),
        ),
        if (icon != null) ...[
          Icon(icon, size: 14, color: colors.onSurface),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _RejectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RejectButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          side: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cancel_outlined, size: 20),
            SizedBox(width: 8),
            Text('Rechazar solicitud'),
          ],
        ),
      ),
    );
  }
}
