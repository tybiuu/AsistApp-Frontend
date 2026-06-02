// lib/pages/admin_home/admin_home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/organization.dart';
import 'admin_home_controller.dart';
import 'components/active_members_section.dart';
import 'components/admin_summary_card.dart';
import 'components/pending_requests_section.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  Widget _content(BuildContext context, AdminHomeController controller) {
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
          _HomeTopBar(organization: organization),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminSummaryCard(controller: controller),
                  const SizedBox(height: 18),
                  PendingRequestsSection(
                    controller: controller,
                    requests: controller.requests,
                  ),
                  const SizedBox(height: 12),
                  ActiveMembersSection(
                    controller: controller,
                    members: controller.activeMembers,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final AdminHomeController controller = Get.put(AdminHomeController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(child: _content(context, controller)),
    );
  }
}

class _HomeTopBar extends StatelessWidget {
  final Organization organization;

  const _HomeTopBar({required this.organization});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      color: colors.surface,
      alignment: Alignment.centerLeft,
      child: Text(
        organization.name,
        style: TextStyle(
          color: colors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
