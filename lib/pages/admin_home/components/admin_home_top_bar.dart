// lib/pages/admin_home/components/admin_home_top_bar.dart

import 'package:flutter/material.dart';

import '../../../models/organization.dart';

class AdminHomeTopBar extends StatelessWidget {
  final Organization organization;

  const AdminHomeTopBar({super.key, required this.organization});

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
