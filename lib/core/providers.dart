import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ai_repository.dart';
import '../data/reminders_repository.dart';
import '../data/settings_repository.dart';

export '../data/ai_repository.dart' show AiRepository, ChatMessage, aiRepositoryProvider;
export '../data/reminders_repository.dart' show FollowUpReminder, remindersRepositoryProvider;
export '../data/settings_repository.dart' show SettingsRepository, settingsRepositoryProvider;
export '../data/support_repository.dart' show SupportRepository, supportRepositoryProvider;

enum AppLanguage { english, hausa }

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._repository, [super.initial = ThemeMode.system]) {
    _loadPreference();
  }

  final SettingsRepository _repository;
  bool _initialized = false;

  Future<void> _loadPreference() async {
    final saved = await _repository.getThemeMode();
    if (!_initialized) {
      super.state = saved;
      _initialized = true;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _initialized = true;
    super.state = mode;
    await _repository.setThemeMode(mode);
  }

  @override
  set state(ThemeMode value) {
    setThemeMode(value);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ThemeModeNotifier(repository);
});

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

class ChatState {
  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._aiRepository) : super(const ChatState());

  final AiRepository _aiRepository;

  Future<void> sendUserMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final userMessage = ChatMessage.user(trimmed);
    final updatedMessages = [...state.messages, userMessage];

    state = state.copyWith(
      messages: updatedMessages,
      isLoading: true,
      errorMessage: null,
    );

    try {
      final responseText = await _aiRepository.sendMessage(updatedMessages);
      final assistantMessage = ChatMessage.assistant(responseText);
      state = state.copyWith(
        messages: [...updatedMessages, assistantMessage],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void clearConversation() {
    state = const ChatState();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final aiRepo = ref.watch(aiRepositoryProvider);
  return ChatNotifier(aiRepo);
});
