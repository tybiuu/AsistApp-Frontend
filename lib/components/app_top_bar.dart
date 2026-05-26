// lib/components/app_top_bar.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// General-purpose top app bar used across practitioner and admin pages.
///
/// [title]       — required page title.
/// [showBack]    — shows a back arrow that calls [Get.back] when tapped.
/// [actions]     — optional trailing widgets (e.g. icon buttons).
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget> actions;

  const AppTopBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg          = isDark ? const Color(0xff1A1D27) : Colors.white;
    final Color borderColor = isDark ? const Color(0xff2D3042) : const Color(0xfff3f4f6);
    final Color titleColor  = isDark ? Colors.white : const Color(0xff1f2937);

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showBack)
              GestureDetector(
                onTap: Get.back,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: isDark ? const Color(0xff9ca3af) : const Color(0xff6b7280),
                  ),
                ),
              ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}
