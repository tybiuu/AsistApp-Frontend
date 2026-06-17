// lib/components/input_field.dart

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? placeholder;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? icon;
  final Widget? rightIcon;
  final String? prefixText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.label,
    this.placeholder,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.icon,
    this.rightIcon,
    this.prefixText,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
            prefixIcon: icon != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        icon!,
                        if (prefixText != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            prefixText!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ]
                      ],
                    ),
                  )
                : (prefixText != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 16, right: 12),
                        child: Text(
                          prefixText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : null),
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: rightIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: rightIcon,
                  )
                : null,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
