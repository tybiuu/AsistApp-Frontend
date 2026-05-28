// lib/pages/admin_config/components/admin_profile_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/info_card.dart';
import '../../../components/primary_button.dart';
import '../../../models/user.dart';
import '../admin_config_controller.dart';
import 'admin_edit_fields.dart';
import 'editable_info_card.dart';

class AdminProfileCard extends StatelessWidget {
  final AdminConfigController controller;
  final User admin;

  const AdminProfileCard({
    super.key,
    required this.controller,
    required this.admin,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.editingProfile.value) {
        return _AdminProfileEditCard(controller: controller, admin: admin);
      }

      return InfoCard(
        title: 'Mi perfil',
        actionLabel: 'Editar',
        actionIcon: Icons.edit_outlined,
        onAction: controller.editProfile,
        rows: [
          InfoRowData(
            icon: Icons.person_outline,
            label: 'Nombres',
            value: admin.firstName,
          ),
          InfoRowData(
            icon: Icons.person_outline,
            label: 'Apellidos',
            value: admin.lastName,
          ),
          InfoRowData(
            icon: Icons.phone_outlined,
            label: 'Celular',
            value: '+51 ${admin.phoneNumber}',
          ),
          InfoRowData(
            icon: Icons.mail_outline,
            label: 'Correo electrónico',
            value: admin.institutionalEmail,
          ),
        ],
      );
    });
  }
}

class _AdminProfileEditCard extends StatelessWidget {
  final AdminConfigController controller;
  final User admin;

  const _AdminProfileEditCard({required this.controller, required this.admin});

  @override
  Widget build(BuildContext context) {
    return EditableInfoCard(
      title: 'Mi perfil',
      onCancel: controller.cancelProfileEdit,
      onSave: () => controller.saveProfile(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminEditTextField(
            icon: Icons.person_outline,
            label: 'Nombres',
            controller: controller.firstNameController,
          ),
          const SizedBox(height: 18),
          AdminEditTextField(
            icon: Icons.person_outline,
            label: 'Apellidos',
            controller: controller.lastNameController,
          ),
          const SizedBox(height: 18),
          AdminPhoneField(controller: controller),
          const SizedBox(height: 18),
          AdminDisabledEmailField(email: admin.institutionalEmail),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Guardar cambios',
            onPressed: () => controller.saveProfile(),
          ),
        ],
      ),
    );
  }
}
