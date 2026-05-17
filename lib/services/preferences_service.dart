// lib/services/preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _onboardingSeenKey = 'onboarding_seen';

  Future<bool> hasSeenOnboarding() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingSeenKey, true);
  }

  Future<void> clearOnboardingSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingSeenKey);
  }
}