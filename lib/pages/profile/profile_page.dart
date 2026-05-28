// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/app_top_bar.dart';
import '../../components/primary_button.dart';
import '../../components/status_badge.dart';
import '../../services/session_service.dart';
import '../../components/schedule_card.dart';
import '../dashboard/dashboard_controller.dart';
import 'profile_controller.dart';
import 'components/profile_header_card.dart';
import 'components/personal_data_card.dart';
import 'components/solicitudes_section.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff0f1117) : const Color(0xffffffff),
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(title: 'Mi perfil'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header ────────────────────────────────────────────
                    const ProfileHeaderCard(),
                    const SizedBox(height: 16),

                    // ── Personal data ────────────────────────────────────
                    const PersonalDataCard(),
                    const SizedBox(height: 16),

                    // ── Schedule ─────────────────────────────────────────
                    _SectionHeader(title: 'Mi horario', isDark: isDark),
                    const SizedBox(height: 10),
                    ScheduleCard(
                      schedule: c.schedule,
                      expandedDay: c.expandedDay,
                      onToggleDay: c.toggleDay,
                    ),
                    const SizedBox(height: 12),
                    PrimaryButton(
                      text: 'Solicitar cambio de horario',
                      variant: PrimaryButtonVariant.secondary,
                      onPressed: () {}, // TODO: navigate to change-schedule
                    ),
                    const SizedBox(height: 16),

                    // ── Solicitudes ───────────────────────────────────────
                    _SectionHeader(title: 'Mis solicitudes', isDark: isDark),
                    const SizedBox(height: 10),
                    SolicitudesSection(
                      solicitudes: const [
                        SolicitudItem(type: 'Asistencia faltante', date: '15 abril 2025', status: BadgeStatus.confirmed),
                        SolicitudItem(type: 'Cambio de horario', date: '8 abril 2025', status: BadgeStatus.pending),
                      ],
                      onRequestAbsence: () {}, // TODO: navigate to request-absence
                    ),
                    const SizedBox(height: 16),

                    // ── Logout ────────────────────────────────────────────
                    _LogoutButton(onTap: () async {
                      await SessionService.to.logout();
                      Get.delete<DashboardController>(force: true);
                      Get.offAllNamed('/welcome');
                    }),
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

// ── Local helper widgets ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 2),
    child: Text(
      title,
      style: TextStyle(
        color: isDark ? Colors.white : const Color(0xff1f2937),
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          'Cerrar sesión',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xffef4444),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}
