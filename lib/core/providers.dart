import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/reminders_repository.dart';
import '../data/settings_repository.dart';

export '../data/reminders_repository.dart' show FollowUpReminder, remindersRepositoryProvider;
export '../data/settings_repository.dart' show SettingsRepository, settingsRepositoryProvider;
export '../data/support_repository.dart' show SupportRepository, supportRepositoryProvider;

enum AppLanguage { english, hausa }

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier(this._repository, [super.initial = AppLanguage.english]) {
    _loadPreference();
  }

  final SettingsRepository _repository;
  bool _initialized = false;

  Future<void> _loadPreference() async {
    final saved = await _repository.getLanguage();
    if (!_initialized) {
      super.state = saved;
      _initialized = true;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    _initialized = true;
    super.state = language;
    await _repository.setLanguage(language);
  }

  @override
  set state(AppLanguage value) {
    setLanguage(value);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return LanguageNotifier(repository);
});

final isHausaSelectedProvider = Provider<bool>(
  (ref) => ref.watch(languageProvider) == AppLanguage.hausa,
);

final moodSelectionProvider = StateProvider<String?>((ref) => null);

class RemindersNotifier extends StateNotifier<List<FollowUpReminder>> {
  RemindersNotifier(this._repository) : super(List.of(_repository.getReminders()));

  final RemindersRepository _repository;

  void addReminder(FollowUpReminder reminder) {
    _repository.addReminder(reminder);
    state = List.of(_repository.getReminders());
  }

  void removeReminder(int index) {
    _repository.removeReminder(index);
    state = List.of(_repository.getReminders());
  }

  void clear() {
    _repository.clear();
    state = const [];
  }

  void update(List<FollowUpReminder> Function(List<FollowUpReminder>) callback) {
    final next = callback(state);
    _repository.clear();
    for (final item in next) {
      _repository.addReminder(item);
    }
    state = List.of(next);
  }
}

final remindersProvider = StateNotifierProvider<RemindersNotifier, List<FollowUpReminder>>((ref) {
  final repository = ref.watch(remindersRepositoryProvider);
  return RemindersNotifier(repository);
});
