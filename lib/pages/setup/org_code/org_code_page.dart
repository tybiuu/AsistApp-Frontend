// lib/pages/auth/org_code_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_top_bar.dart';
import '../../../components/primary_button.dart';
import '../../../components/role_badge.dart';
import '../../../configs/theme.dart';
import '../role_select/role_select_controller.dart';
import 'org_code_controller.dart';

class OrgCodePage extends StatelessWidget {
  const OrgCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrgCodeController());
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            AppTopBar(
              title: '',
              showBack: true,
              onBack: controller.goBack,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.chart1.withValues(alpha: 0.3)
                            : const Color(0xfffff7ed),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.domain,
                          size: 40,
                          color: AppColors.chart1,
                        ),
                      ),
                    ),

                    Text(
                      'Únete a tu laboratorio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ingresa el código que te compartió tu jefe de área',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    const RoleBadge(
                      role: RoleOption.practitioner,
                      showSubtitle: false,
                    ),
                    const SizedBox(height: 24),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Código de organización',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      onChanged: controller.setCode,
                      maxLength: 14,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0,
                        color: AppColors.chart1,
                        fontFamily: 'monospace',
                      ),
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'XXXX-0000',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.chart1.withValues(alpha: 0.3)
                              : AppColors.chart1.withValues(alpha: 0.4),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.chart1.withValues(alpha: 0.1)
                            : const Color(0xfffff7ed),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.chart1.withValues(alpha: 0.6)
                                : AppColors.chart1.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppColors.chart1,
                            width: 2,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Obx(() => PrimaryButton(
                          fullWidth: true,
                          text: 'Enviar solicitud',
                          onPressed: controller.code().length >= 8
                              ? controller.submitCode
                              : null,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
