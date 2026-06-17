// lib/pages/admin_home/admin_member_request/admin_member_request_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_top_bar.dart';
import '../../../components/info_row.dart';
import '../../../components/primary_button.dart';
import '../../../models/user.dart';
import '../../../utils/date_utils.dart';
import 'admin_member_request_controller.dart';

class AdminMemberRequestPage extends StatelessWidget {
  const AdminMemberRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminMemberRequestController controller =
        Get.put(AdminMemberRequestController());
    final ColorScheme colors = Theme.of(context).colorScheme;
    final User member = controller.member;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(top: false,
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
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  member.initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
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
                                      fontSize: 19,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    member.academicDetail,
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                      fontSize: 14,
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
                          InfoRow(
                            label: 'Correo',
                            value: member.institutionalEmail,
                          ),
                          const SizedBox(height: 10),
                          InfoRow(
                            label: 'Celular',
                            value: member.phoneNumber.isNotEmpty
                                ? member.phoneNumber
                                : '—',
                          ),
                          const SizedBox(height: 10),
                          InfoRow(
                            label: 'Solicitó',
                            value: formatRequestDate(member.createdAt),
                            icon: Icons.calendar_today_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      variant: PrimaryButtonVariant.success,
                      onPressed: controller.acceptMember,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline_rounded, size: 20),
                          SizedBox(width: 8),
                          Text('Aceptar solicitud'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      variant: PrimaryButtonVariant.destructive,
                      onPressed: controller.rejectMember,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel_outlined, size: 20),
                          SizedBox(width: 8),
                          Text('Rechazar solicitud'),
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


