// lib/services/preferences_service.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class PreferencesService {
  // ── Keys ──────────────────────────────────────────────────────────────────
  static const String _onboardingSeenKey = 'onboarding_seen';
  static const String _userKey = 'session_user';

  // ── Onboarding ────────────────────────────────────────────────────────────
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  Future<void> clearOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingSeenKey);
  }

  // ── Session user ──────────────────────────────────────────────────────────

  /// Persists [user] as a JSON string in SharedPreferences.
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  /// Returns the stored [User], or null if no session exists.
  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      return User.fromJson(jsonDecode(raw));
    } catch (_) {
      // Corrupted data → clear it
      await prefs.remove(_userKey);
      return null;
    }
  }

  /// Removes the stored user (logout).
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}