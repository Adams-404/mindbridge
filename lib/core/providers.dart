import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, hausa }

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier([super.initial = AppLanguage.english]) {
    _loadPreference();
  }

  static const prefKey = 'mindbridge_language';

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(prefKey);
    if (saved == 'hausa') {
      super.state = AppLanguage.hausa;
    } else if (saved == 'english') {
      super.state = AppLanguage.english;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    super.state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(prefKey, language.name);
  }

  @override
  set state(AppLanguage value) {
    setLanguage(value);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

final isHausaSelectedProvider = Provider<bool>(
  (ref) => ref.watch(languageProvider) == AppLanguage.hausa,
);

final moodSelectionProvider = StateProvider<String?>((ref) => null);

class FollowUpReminder {
  const FollowUpReminder({required this.title, required this.date});
  final String title;
  final DateTime date;
}

final remindersProvider = StateProvider<List<FollowUpReminder>>((ref) => []);
