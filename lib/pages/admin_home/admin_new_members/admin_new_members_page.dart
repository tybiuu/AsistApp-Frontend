// lib/pages/admin_home/admin_new_members/admin_new_members_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_top_bar.dart';
import 'components/member_request_card.dart';
import 'admin_new_members_controller.dart';

class AdminNewMembersPage extends StatelessWidget {
  const AdminNewMembersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminNewMembersController controller =
        Get.put(AdminNewMembersController());
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surfaceContainerLow,
      body: SafeArea(top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Nuevos miembros', showBack: true),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(color: colors.primary),
                  );
                }

                if (controller.pendingMembers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group_add_outlined,
                          size: 48,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.message.value.isNotEmpty
                              ? controller.message.value
                              : 'No hay solicitudes pendientes',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                      child: Text(
                        '${controller.pendingMembers.length} solicitudes pendientes',
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
                        itemCount: controller.pendingMembers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final member = controller.pendingMembers[index];
                          return MemberRequestCard(
                            member: member,
                            onTap: () => controller.openMemberRequest(member),
                            onAccept: () => controller.acceptMember(member),
                            onReject: () => controller.rejectMember(member),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
