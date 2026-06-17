// lib/pages/admin_config/admin_config_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../models/organization.dart';
import '../../models/user.dart';
import 'admin_config_controller.dart';
import 'components/admin_actions_card.dart';
import 'components/admin_organization_card.dart';
import 'components/admin_profile_card.dart';
import 'components/organization_code_card.dart';

class AdminConfigPage extends StatelessWidget {
  const AdminConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminConfigController controller = Get.put(AdminConfigController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(top: false,
        child: Column(
          children: [
            const AppTopBar(title: 'Configuración'),
            Expanded(child: _Content(controller: controller)),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AdminConfigController controller;
  const _Content({required this.controller});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: colors.primary));
      }

      final Organization? organization = controller.organization.value;
      final User? admin = controller.admin;

      if (organization == null || admin == null) {
        return Center(
          child: Text(
            controller.message.value,
            style: TextStyle(color: colors.onSurfaceVariant),
          ),
        );
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AdminOrganizationCard(
              controller: controller,
              organization: organization,
            ),
            const SizedBox(height: 28),
            OrganizationCodeCard(
              controller: controller,
              organization: organization,
            ),
            const SizedBox(height: 28),
            AdminProfileCard(controller: controller, admin: admin),
            const SizedBox(height: 28),
            AdminActionsCard(controller: controller),
          ],
        ),
      );
    });
  }
}
