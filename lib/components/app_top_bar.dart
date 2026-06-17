// lib/components/app_top_bar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final Color? backgroundColor;

  const AppTopBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.actions = const [],
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg         = backgroundColor ?? Theme.of(context).colorScheme.surface;
    final Color titleColor = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (showBack)
                GestureDetector(
                  onTap: onBack ?? Get.back,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ...actions,
            ],
          ),
          ),
        ),
      ),
    );
  }
}
