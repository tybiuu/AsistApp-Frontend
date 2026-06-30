// lib/services/session_service.dart

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../models/organization.dart';
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

  /// The organization linked to the current session.
  final currentOrganization = Rx<Organization?>(null);

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
    final savedOrg = await _prefs.getOrganization();
    if (savedOrg != null) {
      currentOrganization.value = savedOrg;
      debugPrint('[SessionService] Restored organization → ${savedOrg.name}');
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

  Future<void> saveOrganization(Organization organization) async {
    currentOrganization.value = organization;
    await _prefs.saveOrganization(organization);
    debugPrint('[SessionService] Organization saved → ${organization.name}');
  }

  Future<void> updateOrganization(Organization organization) async {
    await saveOrganization(organization);
    debugPrint('[SessionService] Organization updated → ${organization.name}');
  }

  Future<void> clearOrganization() async {
    currentOrganization.value = null;
    await _prefs.clearOrganization();
    debugPrint('[SessionService] Organization cleared.');
  }

  /// Clears memory + SharedPreferences.
  Future<void> logout() async {
    currentUser.value = null;
    currentOrganization.value = null;
    await _prefs.clearUser();
    await _prefs.clearToken();
    await _prefs.clearOrganization();
    debugPrint('[SessionService] Session cleared.');
  }
}
