// lib/services/session_service.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import 'preferences_service.dart';

/// Singleton GetX service that owns the authenticated [User] for the whole
/// app lifetime. Backed by [PreferencesService] for persistence across cold
/// starts.
///
/// Usage:
///   - Read:    SessionService.to.currentUser
///   - Save:    await SessionService.to.saveUser(user)
///   - Logout:  await SessionService.to.logout()
class SessionService extends GetxService {
  // Singleton accessor
  static SessionService get to => Get.find<SessionService>();

  final _prefs = PreferencesService();

  /// The currently authenticated user. Null = not logged in.
  final currentUser = Rx<User?>(null);

  bool get isLoggedIn => currentUser.value != null;
  bool get isTrainee  => currentUser.value?.role == UserRole.trainee;
  bool get isAdmin    => currentUser.value?.role == UserRole.admin;

  // ── Initialization ────────────────────────────────────────────────────────

  /// Called once at startup (before [runApp]).
  /// Restores a previously saved session from SharedPreferences.
  Future<SessionService> init() async {
    final saved = await _prefs.getUser();
    if (saved != null) {
      currentUser.value = saved;
      debugPrint('[SessionService] Restored session → ${saved.fullName} (${saved.role.name})');
    } else {
      debugPrint('[SessionService] No saved session found.');
    }
    return this;
  }

  // ── Session actions ───────────────────────────────────────────────────────

  /// Persists [user] in memory and in SharedPreferences.
  Future<void> saveUser(User user) async {
    currentUser.value = user;
    await _prefs.saveUser(user);
    debugPrint('[SessionService] Session saved → ${user.fullName} (${user.role.name})');
  }

  /// Updates the saved user (e.g. after a profile edit).
  Future<void> updateUser(User user) async {
    await saveUser(user);
    debugPrint('[SessionService] Session updated → ${user.fullName}');
  }

  /// Clears memory + SharedPreferences.
  Future<void> logout() async {
    currentUser.value = null;
    await _prefs.clearUser();
    debugPrint('[SessionService] Session cleared.');
  }
}
