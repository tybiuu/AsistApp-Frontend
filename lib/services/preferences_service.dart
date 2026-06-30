// lib/services/preferences_service.dart

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/organization.dart';
import '../models/user.dart';

class PreferencesService {
  // ── Keys ──────────────────────────────────────────────────────────────────
  static const String _userKey = 'session_user';
  static const String _tokenKey = 'session_token';
  static const String _organizationKey = 'session_organization';

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

  // ── Session token ─────────────────────────────────────────────────────────

  /// Persists the JWT token in SharedPreferences.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Returns the stored JWT token, or null if it doesn't exist.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Removes the stored JWT token.
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // ── Session organization ──────────────────────────────────────────────────

  Future<void> saveOrganization(Organization organization) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_organizationKey, jsonEncode(organization.toJson()));
  }

  Future<Organization?> getOrganization() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_organizationKey);
    if (raw == null) return null;
    try {
      return Organization.fromJson(jsonDecode(raw));
    } catch (_) {
      await prefs.remove(_organizationKey);
      return null;
    }
  }

  Future<void> clearOrganization() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_organizationKey);
  }
}