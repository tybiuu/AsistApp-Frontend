// lib/pages/auth/register_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/app_top_bar.dart';
import '../../../components/role_badge.dart';
import '../../setup/role_select/role_select_controller.dart';
import 'register_controller.dart';
import 'components/personal_info_fields.dart';
import 'components/practitioner_fields.dart';
import 'components/password_fields.dart';
import 'components/register_footer.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final RegisterController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RegisterController());
  }

  @override
  void dispose() {
    Get.delete<RegisterController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = controller.role;
    final bool isPractitioner = role == RoleOption.practitioner;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(title: 'Crea tu cuenta', showBack: true),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoleBadge(role: role),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const PersonalInfoFields(),
                    if (isPractitioner) const PractitionerFields(),
                    const PasswordFields(),
                    const SizedBox(height: 24),
                    const RegisterFooter(),
                    const SizedBox(height: 20),
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
