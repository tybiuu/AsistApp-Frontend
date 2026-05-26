// lib/pages/profile/profile_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../../services/session_service.dart';
import 'profile_schedule.dart';

class ProfileController extends GetxController {
  // ── Current user — sourced from SessionService ────────────────────────────
  /// Mirrors [SessionService.currentUser] so all profile widgets react to
  /// changes without coupling every widget directly to SessionService.
  final user = Rx<User?>(null);

  // ── Convenience getters ───────────────────────────────────────────────────
  String get firstName => user.value?.firstName ?? '';
  String get lastName => user.value?.lastName ?? '';
  String get phone => user.value?.phoneNumber ?? '';
  String get career => user.value?.career ?? '';
  int get cycle => user.value?.cycle ?? 5;
  bool get isTrainee => user.value?.role == UserRole.trainee;

  // ── Edit state ────────────────────────────────────────────────────────────
  final editing = false.obs;
  final carreraOpen = false.obs;

  late final TextEditingController cFirstName;
  late final TextEditingController cLastName;
  late final TextEditingController cPhone;

  final dCarrera = ''.obs;
  final dCiclo = 5.obs;

  // ── Schedule UI state ─────────────────────────────────────────────────────
  final expandedDay = RxnInt();

  // ── Static data ───────────────────────────────────────────────────────────
  final schedule = kMySchedule;
  final carreras = kCarreras;

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    // Load user from the active session
    user.value = SessionService.to.currentUser.value;

    cFirstName = TextEditingController(text: firstName);
    cLastName = TextEditingController(text: lastName);
    cPhone = TextEditingController(text: phone);
  }

  @override
  void onClose() {
    cFirstName.dispose();
    cLastName.dispose();
    cPhone.dispose();
    super.onClose();
  }

  // ── Computed ──────────────────────────────────────────────────────────────
  int get totalWeekMins =>
      schedule.values.fold(0, (sum, d) => sum + dayWorkMins(d));

  // ── Edit actions ──────────────────────────────────────────────────────────
  void startEdit() {
    cFirstName.text = firstName;
    cLastName.text = lastName;
    cPhone.text = phone;
    dCarrera.value = career;
    dCiclo.value = cycle;
    carreraOpen.value = false;
    editing.value = true;
  }

  void cancelEdit() {
    editing.value = false;
    carreraOpen.value = false;
  }

  /// Saves edited data into a new [User], persists it via [SessionService],
  /// and prints the updated fields.
  Future<void> saveEdit() async {
    final current = user.value;
    if (current == null) return;

    final updated = User(
      id: current.id,
      firstName: cFirstName.text.trim(),
      lastName: cLastName.text.trim(),
      institutionalEmail: current.institutionalEmail,
      phoneNumber: cPhone.text.trim(),
      career: dCarrera.value,
      cycle: dCiclo.value,
      organizationId: current.organizationId,
      role: current.role,
      status: current.status,
      deviceToken: current.deviceToken,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );

    // Persist in SharedPreferences via SessionService
    await SessionService.to.updateUser(updated);

    // Update local observable so widgets rebuild immediately
    user.value = updated;
    editing.value = false;
    carreraOpen.value = false;

    debugPrint('──── Profile saved ────────────────────────────────────────');
    debugPrint('  firstName  : ${updated.firstName}');
    debugPrint('  lastName   : ${updated.lastName}');
    debugPrint('  phoneNumber: ${updated.phoneNumber}');
    debugPrint('  career     : ${updated.career}');
    debugPrint('  cycle      : ${updated.cycle}');
    debugPrint('  role       : ${updated.role.name}');
    debugPrint('  updatedAt  : ${updated.updatedAt}');
    debugPrint('────────────────────────────────────────────────────────────');
  }

  void toggleCarreraDropdown() => carreraOpen.toggle();

  void selectCarrera(String value) {
    dCarrera.value = value;
    carreraOpen.value = false;
  }

  void decrementCiclo() { if (dCiclo.value > 5)  dCiclo.value--; }
  void incrementCiclo() { if (dCiclo.value < 10) dCiclo.value++; }

  // ── Schedule actions ──────────────────────────────────────────────────────
  void toggleDay(int idx) {
    expandedDay.value = expandedDay.value == idx ? null : idx;
  }
}
