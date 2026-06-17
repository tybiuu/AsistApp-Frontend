// lib/pages/admin_home/admin_home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../models/organization.dart';
import 'admin_home_controller.dart';
import 'components/active_members_section.dart';
import 'components/admin_summary_card.dart';
import 'components/pending_requests_section.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminHomeController());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(top: false,child: _Content(controller: controller)),
    );
  }
}

class _Content extends StatelessWidget {
  final AdminHomeController controller;
  const _Content({required this.controller});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: colors.primary));
      }

      final Organization? organization = controller.organization.value;
      if (organization == null) {
        return Center(
          child: Text(
            controller.message.value,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        );
      }

      return Column(
        children: [
          AppTopBar(title: organization.name),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminSummaryCard(controller: controller),
                  const SizedBox(height: 18),
                  PendingRequestsSection(
                    requests: controller.requests,
                    onRequestTap: controller.openRequest,
                  ),
                  const SizedBox(height: 12),
                  ActiveMembersSection(
                    members: controller.activeMembers,
                    onMemberTap: controller.openMember,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
