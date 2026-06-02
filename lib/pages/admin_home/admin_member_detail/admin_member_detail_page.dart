// lib/pages/admin_home/admin_member_detail/admin_member_detail_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_top_bar.dart';
import '../../../components/member_metric_card.dart';
import '../../../components/primary_button.dart';
import '../../../components/schedule_card.dart';
import '../../../utils/label_utils.dart';
import 'admin_member_detail_controller.dart';

class AdminMemberDetailPage extends StatelessWidget {
  const AdminMemberDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminMemberDetailController controller =
        Get.put(AdminMemberDetailController());
    final ColorScheme colors = Theme.of(context).colorScheme;
    final member = controller.member;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(title: 'Miembro', showBack: true),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Info card ─────────────────────────────────────────────
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
                                  color: const Color(0xffe15d27),
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
                              Expanded(
                                child: Column(
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
                                    const SizedBox(height: 2),
                                    if (member.career != null)
                                      Text(
                                        member.career!,
                                        style: TextStyle(
                                          color: colors.onSurfaceVariant,
                                          fontSize: 13,
                                        ),
                                      ),
                                                    if (member.cycle != null)
                                      Text(
                                        cicloLabel(member.cycle!),
                                        style: TextStyle(
                                          color: colors.onSurfaceVariant,
                                          fontSize: 13,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Divider(color: colors.outlineVariant, height: 1),
                          const SizedBox(height: 14),
                          _InfoRow(
                            label: 'Correo',
                            value: member.institutionalEmail,
                            colors: colors,
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Celular',
                            value: member.phoneNumber.isNotEmpty
                                ? member.phoneNumber
                                : '—',
                            colors: colors,
                          ),
                        ],
                      ),
                    ),

                    // ── Metrics ───────────────────────────────────────────────
                    const SizedBox(height: 20),
                    Text(
                      'MÉTRICAS DE ${controller.currentMonthLabel}',
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.35,
                      children: controller.metrics
                          .map(
                            (m) => MemberMetricCard(
                              label: m.label,
                              value: m.value,
                              valueColor: m.valueColor,
                              subtitle: m.subtitle,
                              progress: m.progress,
                            ),
                          )
                          .toList(),
                    ),

                    // ── Schedule ──────────────────────────────────────────────
                    const SizedBox(height: 20),
                    ScheduleCard(
                      schedule: controller.schedule,
                      expandedDay: controller.expandedDay,
                      onToggleDay: controller.toggleDay,
                    ),

                    // ── Delete button ─────────────────────────────────────────
                    const SizedBox(height: 24),
                    PrimaryButton(
                      variant: PrimaryButtonVariant.destructive,
                      onPressed: controller.deleteMember,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_remove_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Eliminar miembro'),
                        ],
                      ),
                    ),
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
  final ColorScheme colors;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
          ),
        ),
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

