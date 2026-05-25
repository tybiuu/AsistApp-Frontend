// lib/pages/admin_home/admin_home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/admin_member_tile.dart';
import '../../components/admin_request_card.dart';
import '../../components/primary_button.dart';
import '../../configs/theme.dart';
import '../../models/admin_home.dart';
import '../../models/user.dart';
import 'admin_home_controller.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  Color _statColor(AdminSummaryStat stat) {
    switch (stat.type) {
      case 'confirmed':
        return AppColors.chart2;
      case 'absences':
        return AppColors.destructive;
      default:
        return AppColors.chart1;
    }
  }

  Widget _topBar(BuildContext context, AdminHomeData data) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      color: colors.surface,
      alignment: Alignment.centerLeft,
      child: Text(
        data.organization.name,
        style: TextStyle(
          color: colors.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _summaryCard(
    BuildContext context,
    AdminHomeController controller,
    AdminHomeData data,
  ) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HOY',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            controller.currentDateLabel,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: data.stats
                .map(
                  (stat) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: _statBox(context, stat),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ver pendientes'),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 16),
              ],
            ),
            onPressed: controller.goToPendingRequests,
          ),
        ],
      ),
    );
  }

  Widget _statBox(BuildContext context, AdminSummaryStat stat) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${stat.value}',
            style: TextStyle(
              color: _statColor(stat),
              fontSize: 23,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.label,
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _requestsSection(
    BuildContext context,
    AdminHomeController controller,
    List<AdminRequestSummary> requests,
  ) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Solicitudes pendientes',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...requests.map(
          (request) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AdminRequestCard(
              request: request,
              onTap: () => controller.openRequest(request),
            ),
          ),
        ),
      ],
    );
  }

  Widget _membersSection(
    BuildContext context,
    AdminHomeController controller,
    List<User> members,
  ) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Miembros activos',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        ...members.map(
          (member) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: AdminMemberTile(
              member: member,
              onTap: () => controller.openMember(member),
            ),
          ),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, AdminHomeController controller) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: colors.primary));
      }

      final AdminHomeData? data = controller.adminHomeData.value;
      if (data == null) {
        return Center(
          child: Text(
            controller.message.value,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        );
      }

      return Column(
        children: [
          _topBar(context, data),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _summaryCard(context, controller, data),
                  const SizedBox(height: 18),
                  _requestsSection(context, controller, data.requests),
                  const SizedBox(height: 12),
                  _membersSection(context, controller, data.activeMembers),
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
