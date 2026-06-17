// lib/components/primary_button.dart

import 'package:flutter/material.dart';

import '../configs/theme.dart';

enum PrimaryButtonVariant {
  primary,
  secondary,
  destructive,
  success,
}

class PrimaryButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final bool fullWidth;
  final PrimaryButtonVariant variant;

  const PrimaryButton({
    super.key,
    this.text,
    this.child,
    this.onPressed,
    this.fullWidth = true,
    this.variant = PrimaryButtonVariant.primary,
  }) : assert(text != null || child != null);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (variant == PrimaryButtonVariant.success) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        height: 54,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          child: child ?? Text(text!),
        ),
      );
    }

    if (variant == PrimaryButtonVariant.destructive) {
      final Color errorColor = Theme.of(context).colorScheme.error;
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        height: 54,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: errorColor,
            side: BorderSide(color: errorColor, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          child: child ?? Text(text!),
        ),
      );
    }

    final bool isPrimary = variant == PrimaryButtonVariant.primary;

    final Color backgroundColor = onPressed == null
        ? colors.surfaceContainerHigh
        : isPrimary
            ? colors.primary
            : colors.surface;

    final Color foregroundColor = onPressed == null
        ? colors.onSurfaceVariant
        : isPrimary
            ? colors.onPrimary
            : colors.primary;

    final Color borderColor = isPrimary
        ? Colors.transparent
        : colors.primary;

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        child: child ?? Text(text!),
      ),
    );
  }
}