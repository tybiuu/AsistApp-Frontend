// lib/pages/profile/profile_controller.dart

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/schedule.dart';
import '../../models/user.dart';
import '../../services/session_service.dart';

class ProfileController extends GetxController {
  // ── Current user — sourced from SessionService ────────────────────────────
  /// Mirrors [SessionService.currentUser] so all profile widgets react to
  /// changes without coupling every widget directly to SessionService.
  final user = Rx<User?>(null);
  late final Worker _userWorker;

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
  final schedule = <String, DaySchedule>{
    'Lunes': const DaySchedule(enabled: false, blocks: []),
    'Martes': const DaySchedule(enabled: false, blocks: []),
    'Miércoles': const DaySchedule(enabled: false, blocks: []),
    'Jueves': const DaySchedule(enabled: false, blocks: []),
    'Viernes': const DaySchedule(enabled: false, blocks: []),
    'Sábado': const DaySchedule(enabled: false, blocks: []),
  }.obs;
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
    dCarrera.value = career;
    dCiclo.value = cycle;

    _userWorker = ever<User?>(SessionService.to.currentUser, _syncSessionUser);

    _loadMockSchedule();
  }

  void _syncSessionUser(User? currentUser) {
    user.value = currentUser;
    if (editing.value) return;

    cFirstName.text = firstName;
    cLastName.text = lastName;
    cPhone.text = phone;
    dCarrera.value = career;
    dCiclo.value = cycle;
  }

  Future<void> _loadMockSchedule() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/jsons/mock_schedules.json',
      );
      final List<dynamic> data = jsonDecode(response);

      if (data.isNotEmpty) {
        // Obtenemos el horario del usuario actual (o el primero si no lo encontramos)
        final userSchedule = data.firstWhere(
          (s) => s['user_id'] == user.value?.id,
          orElse: () => data.first,
        );

        final daysList = userSchedule['days'] as List<dynamic>;

        final dayMap = {
          'monday': 'Lunes',
          'tuesday': 'Martes',
          'wednesday': 'Miércoles',
          'thursday': 'Jueves',
          'friday': 'Viernes',
          'saturday': 'Sábado',
          'sunday': 'Domingo',
        };

        // Clonamos el estado inicial para mantener el orden
        final newSchedule = Map<String, DaySchedule>.from(schedule);

        for (var d in daysList) {
          final dayName = dayMap[d['day']] ?? d['day'];

          List<ScheduleBlock> blocks = [];

          String? checkIn = d['check_in_time'] as String?;
          String? lunchStart = d['lunch_start_time'] as String?;
          String? lunchEnd = d['lunch_end_time'] as String?;
          String? checkOut = d['check_out_time'] as String?;

          // Remove seconds if present
          if (checkIn != null && checkIn.length > 5)
            checkIn = checkIn.substring(0, 5);
          if (lunchStart != null && lunchStart.length > 5)
            lunchStart = lunchStart.substring(0, 5);
          if (lunchEnd != null && lunchEnd.length > 5)
            lunchEnd = lunchEnd.substring(0, 5);
          if (checkOut != null && checkOut.length > 5)
            checkOut = checkOut.substring(0, 5);

          if (checkIn != null && checkOut != null) {
            if (lunchStart != null && lunchEnd != null) {
              blocks.add(
                ScheduleBlock(
                  type: BlockType.work,
                  start: checkIn,
                  end: lunchStart,
                ),
              );
              blocks.add(
                ScheduleBlock(
                  type: BlockType.breakTime,
                  start: lunchStart,
                  end: lunchEnd,
                ),
              );
              blocks.add(
                ScheduleBlock(
                  type: BlockType.work,
                  start: lunchEnd,
                  end: checkOut,
                ),
              );
            } else {
              blocks.add(
                ScheduleBlock(
                  type: BlockType.work,
                  start: checkIn,
                  end: checkOut,
                ),
              );
            }
          }

          if (newSchedule.containsKey(dayName)) {
            newSchedule[dayName] = DaySchedule(
              enabled: blocks.isNotEmpty,
              blocks: blocks,
            );
          }
        }

        schedule.assignAll(newSchedule);
      }
    } catch (e) {
      debugPrint('Error loading schedule mock: $e');
    }
  }

  @override
  void onClose() {
    _userWorker.dispose();
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

  void decrementCiclo() {
    if (dCiclo.value > 5) dCiclo.value--;
  }

  void incrementCiclo() {
    if (dCiclo.value < 10) dCiclo.value++;
  }

  // ── Schedule actions ──────────────────────────────────────────────────────
  void toggleDay(int idx) {
    expandedDay.value = expandedDay.value == idx ? null : idx;
  }
}
