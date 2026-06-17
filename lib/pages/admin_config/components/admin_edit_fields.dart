// lib/pages/admin_config/components/admin_edit_fields.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminEditTextField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;

  const AdminEditTextField({
    super.key,
    required this.icon,
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminEditLabel(icon: icon, label: label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(color: colors.onSurface, fontSize: 15),
          decoration: adminInputDecoration(context, hint: hint),
        ),
      ],
    );
  }
}

class AdminPhoneField extends StatelessWidget {
  final TextEditingController controller;

  const AdminPhoneField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminEditLabel(icon: Icons.phone_outlined, label: 'Celular'),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            children: [
              Text(
                '+51',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Container(width: 1, height: 20, color: colors.outlineVariant),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(color: colors.onSurface, fontSize: 15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AdminDisabledEmailField extends StatelessWidget {
  final String email;

  const AdminDisabledEmailField({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AdminEditLabel(
          icon: Icons.mail_outline,
          label: 'Correo electrónico',
        ),
        const SizedBox(height: 8),
        Opacity(
          opacity: 0.55,
          child: TextFormField(
            enabled: false,
            initialValue: email,
            style: TextStyle(color: colors.onSurface, fontSize: 15),
            decoration: adminInputDecoration(context),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'El correo asociado no puede modificarse.',
          style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
        ),
      ],
    );
  }
}

class AdminEditLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const AdminEditLabel({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: colors.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: colors.onSurfaceVariant,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

InputDecoration adminInputDecoration(BuildContext context, {String? hint}) {
  final ColorScheme colors = Theme.of(context).colorScheme;

  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: colors.onSurfaceVariant, fontSize: 15),
    filled: true,
    fillColor: colors.surfaceContainerLowest,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.outlineVariant),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.outlineVariant),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.outlineVariant),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: colors.primary, width: 1.4),
    ),
  );
}
