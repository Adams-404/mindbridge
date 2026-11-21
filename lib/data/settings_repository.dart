import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/providers.dart';

abstract interface class SettingsRepository {
  Future<AppLanguage> getLanguage();
  Future<void> setLanguage(AppLanguage language);
  Future<bool> hasSeenOnboarding();
  Future<void> setOnboardingSeen(bool seen);
}

class SharedPrefsSettingsRepository implements SettingsRepository {
  static const _langKey = 'mindbridge_language';
  static const _onboardingKey = 'mindbridge_onboarding_seen';

  @override
  Future<AppLanguage> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_langKey);
    if (saved == 'hausa') return AppLanguage.hausa;
    return AppLanguage.english;
  }

  @override
  Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, language.name);
  }

  @override
  Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) == true;
  }

  @override
  Future<void> setOnboardingSeen(bool seen) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, seen);
  }
}

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SharedPrefsSettingsRepository();
});
