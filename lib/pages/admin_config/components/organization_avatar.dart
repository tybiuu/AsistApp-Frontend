// lib/pages/admin_config/components/organization_avatar.dart

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../configs/theme.dart';
import '../../../models/organization.dart';

class OrganizationAvatar extends StatelessWidget {
  final Organization organization;
  final double size;
  final double borderRadius;
  final Rx<Uint8List?>? photoBytes;

  const OrganizationAvatar({
    super.key,
    required this.organization,
    this.size = 46,
    this.borderRadius = 14,
    this.photoBytes,
  });

  @override
  Widget build(BuildContext context) {
    final String? photoUrl = organization.photoUrl?.trim();

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.chart1,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Obx(() {
        final bytes = photoBytes?.value;
        if (bytes != null) {
          return Image.memory(
            bytes,
            width: size,
            height: size,
            fit: BoxFit.cover,
          );
        }

        if (photoUrl == null || photoUrl.isEmpty) {
          return OrganizationInitialsAvatar(organization: organization);
        }

        return Image.network(
          photoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return OrganizationInitialsAvatar(organization: organization);
          },
        );
      }),
    );
  }
}

class OrganizationInitialsAvatar extends StatelessWidget {
  final Organization organization;

  const OrganizationInitialsAvatar({super.key, required this.organization});

  String get _initials {
    final String name = organization.name.trim();
    if (name.length <= 2) return name.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _initials,
        style: const TextStyle(
          color: AppColors.primaryForeground,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
