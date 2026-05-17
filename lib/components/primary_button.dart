// lib/components/primary_button.dart

import 'package:flutter/material.dart';

import '../configs/theme.dart';

enum PrimaryButtonVariant {
  primary,
  secondary,
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool fullWidth;
  final PrimaryButtonVariant variant;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fullWidth = true,
    this.variant = PrimaryButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == PrimaryButtonVariant.primary;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color backgroundColor = isPrimary
        ? AppColors.chart1
        : isDark
            ? const Color(0xff1a1d27)
            : AppColors.card;

    final Color foregroundColor = isPrimary
        ? AppColors.primaryForeground
        : isDark
            ? const Color(0xfff9fafb)
            : AppColors.foreground;

    final Color borderColor = isPrimary
        ? Colors.transparent
        : isDark
            ? const Color(0xff333333)
            : AppColors.border;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: isPrimary ? 0 : 0,
          shadowColor: Colors.transparent,
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: borderColor),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        child: Text(text),
      ),
    );
  }
}