// lib/pages/admin_setup/admin_setup_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../components/primary_button.dart';
import '../../configs/theme.dart';
import 'admin_setup_controller.dart';

class AdminSetupPage extends StatelessWidget {
  const AdminSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminSetupController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final AdminSetupController control = Get.find();
    final ColorScheme colors = Theme.of(context).colorScheme;

    return SafeArea(top: false,
      child: Column(
        children: [
          AppTopBar(
            title: 'Crea tu laboratorio',
            showBack: true,
            onBack: control.goBack,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _PhotoPicker(),
                  const SizedBox(height: 22),
                  _TextInput(
                    label: 'Nombre del laboratorio',
                    hint: 'Ej: ITLAB, BioLab, QuimLab...',
                    controller: control.nameController,
                  ),
                  const SizedBox(height: 18),
                  const _TardinessStepper(),
                  const SizedBox(height: 18),
                  _TextInput(
                    label: 'Descripcion (opcional)',
                    hint: 'Describe brevemente tu laboratorio...',
                    controller: control.descriptionController,
                  ),
                  const SizedBox(height: 18),
                  Obx(
                    () => PrimaryButton(
                      text: control.isLoading.value ? 'Creando...' : 'Crear organizacion',
                      onPressed: control.canCreate ? control.createOrganization : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 18,
            color: colors.surfaceContainerLow,
            alignment: Alignment.center,
            child: Container(
              width: 98,
              height: 4,
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker();

  @override
  Widget build(BuildContext context) {
    final AdminSetupController control = Get.find();
    final ColorScheme colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: control.selectPhoto,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Obx(
                () => Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.chart1,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: control.laboratoryPhotoBytes.value == null
                      ? Icon(
                          Icons.question_mark_rounded,
                          color: colors.onPrimary,
                          size: 32,
                        )
                      : Image.memory(
                          control.laboratoryPhotoBytes.value!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.chart1,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.surface, width: 3),
                  ),
                  child: Icon(
                    Icons.photo_camera_outlined,
                    color: colors.onPrimary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Foto del laboratorio',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Opcional',
            style: TextStyle(
              color: colors.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextInput extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const _TextInput({
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: 1,
          style: TextStyle(color: colors.onSurface, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
            filled: true,
            fillColor: colors.surfaceContainerLowest,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _TardinessStepper extends StatelessWidget {
  const _TardinessStepper();

  @override
  Widget build(BuildContext context) {
    final AdminSetupController control = Get.find();
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiempo limite de tardanza',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            children: [
              _StepperButton(
                icon: Icons.remove_rounded,
                onPressed: control.decreaseTardinessLimit,
              ),
              Expanded(
                child: Obx(
                  () => Text(
                    '${control.tardinessLimit.value} min',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add_rounded,
                onPressed: control.increaseTardinessLimit,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _StepperButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: colors.primaryContainer,
          foregroundColor: AppColors.chart1,
          shape: const CircleBorder(),
        ),
      ),
    );
  }
}
