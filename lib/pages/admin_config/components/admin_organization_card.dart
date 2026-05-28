// lib/pages/admin_config/components/admin_organization_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/info_card.dart';
import '../../../components/number_stepper.dart';
import '../../../components/primary_button.dart';
import '../../../configs/theme.dart';
import '../../../models/organization.dart';
import '../admin_config_controller.dart';
import 'admin_edit_fields.dart';
import 'editable_info_card.dart';
import 'organization_avatar.dart';

class AdminOrganizationCard extends StatelessWidget {
  final AdminConfigController controller;
  final Organization organization;

  const AdminOrganizationCard({
    super.key,
    required this.controller,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.editingOrganization.value) {
        return _OrganizationEditCard(
          controller: controller,
          organization: organization,
        );
      }

      return InfoCard(
        title: 'Mi organización',
        actionLabel: 'Editar',
        actionIcon: Icons.edit_outlined,
        onAction: controller.editOrganization,
        rows: [
          InfoRowData(
            icon: Icons.business_rounded,
            label: 'Nombre del laboratorio',
            value: organization.name,
            leading: OrganizationAvatar(
                organization: organization,
                photoBytes: controller.savedOrganizationPhotoBytes,
              ),
          ),
          InfoRowData(
            icon: Icons.schedule_rounded,
            label: 'Límite de tardanza',
            value: '${organization.lateTimeLimit} minutos',
          ),
          InfoRowData(
            icon: Icons.description_outlined,
            label: 'Descripción',
            value: organization.description ?? 'Sin descripción',
          ),
        ],
      );
    });
  }
}

class _OrganizationEditCard extends StatelessWidget {
  final AdminConfigController controller;
  final Organization organization;

  const _OrganizationEditCard({
    required this.controller,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    return EditableInfoCard(
      title: 'Mi organización',
      onCancel: controller.cancelOrganizationEdit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OrganizationPhotoEditor(
            controller: controller,
            organization: organization,
          ),
          const SizedBox(height: 24),
          AdminEditTextField(
            icon: Icons.business_outlined,
            label: 'Nombre del laboratorio',
            controller: controller.organizationNameController,
          ),
          const SizedBox(height: 18),
          Obx(
            () => NumberStepper(
              icon: Icons.schedule_rounded,
              title: 'Tiempo límite de tardanza',
              value: controller.tardinessLimit.value,
              valueLabel: 'minutos',
              canDecrease: controller.tardinessLimit.value > 0,
              canIncrease: controller.tardinessLimit.value < 60,
              onDecrease: controller.decreaseTardinessLimit,
              onIncrease: controller.increaseTardinessLimit,
            ),
          ),
          const SizedBox(height: 18),
          AdminEditTextField(
            icon: Icons.description_outlined,
            label: 'Descripción',
            controller: controller.organizationDescriptionController,
            hint: 'Describe el laboratorio...',
            maxLines: 4,
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'Guardar cambios',
            onPressed: controller.saveOrganization,
          ),
        ],
      ),
    );
  }
}

class _OrganizationPhotoEditor extends StatelessWidget {
  final AdminConfigController controller;
  final Organization organization;

  const _OrganizationPhotoEditor({
    required this.controller,
    required this.organization,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final String? photoUrl = organization.photoUrl?.trim();

    return Column(
      children: [
        GestureDetector(
          onTap: controller.selectOrganizationPhoto,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 126,
                height: 126,
                decoration: BoxDecoration(
                  color: AppColors.chart1,
                  borderRadius: BorderRadius.circular(30),
                ),
                clipBehavior: Clip.antiAlias,
                child: Obx(() {
                  final bytes =
                      controller.organizationPhotoBytes.value ??
                      controller.savedOrganizationPhotoBytes.value;
                  if (bytes != null) {
                    return Image.memory(bytes, fit: BoxFit.cover);
                  }

                  if (photoUrl != null && photoUrl.isNotEmpty) {
                    return Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return OrganizationInitialsAvatar(
                          organization: organization,
                        );
                      },
                    );
                  }

                  return OrganizationInitialsAvatar(organization: organization);
                }),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.chart1,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.surface, width: 2),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: AppColors.primaryForeground,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Foto del laboratorio',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Opcional',
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
        ),
      ],
    );
  }
}
