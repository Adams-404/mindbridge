import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/ai_repository.dart';
import '../data/chat_history_repository.dart';
import '../data/check_in_repository.dart';
import '../data/reminders_repository.dart';
import '../data/settings_repository.dart';

export '../data/ai_repository.dart' show AiRepository, ChatMessage, aiRepositoryProvider;
export '../data/chat_history_repository.dart' show ChatHistoryRepository, ChatSession, chatHistoryRepositoryProvider;
export '../data/check_in_repository.dart' show CheckInEntry, CheckInRepository, checkInRepositoryProvider;
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

class CheckInNotifier extends StateNotifier<List<CheckInEntry>> {
  CheckInNotifier(this._repository) : super([]) {
    loadEntries();
  }

  final CheckInRepository _repository;

  Future<void> loadEntries() async {
    final entries = await _repository.getEntries();
    state = entries;
  }

  Future<void> addCheckIn({
    required String mood,
    required String symbol,
    required int score,
    String note = '',
    List<String> factors = const [],
  }) async {
    final entry = CheckInEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      mood: mood,
      symbol: symbol,
      score: score,
      note: note,
      factors: factors,
    );
    await _repository.addEntry(entry);
    state = [entry, ...state];
  }

  Future<void> deleteCheckIn(String id) async {
    await _repository.deleteEntry(id);
    state = state.where((e) => e.id != id).toList();
  }

  Future<void> clearAll() async {
    await _repository.clearAll();
    state = [];
  }
}

final checkInHistoryProvider = StateNotifierProvider<CheckInNotifier, List<CheckInEntry>>((ref) {
  final repo = ref.watch(checkInRepositoryProvider);
  return CheckInNotifier(repo);
});

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
    this.sessionId,
    this.sessionTitle,
    this.messages = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final String? sessionId;
  final String? sessionTitle;
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? errorMessage;

  ChatState copyWith({
    String? sessionId,
    String? sessionTitle,
    List<ChatMessage>? messages,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ChatState(
      sessionId: sessionId ?? this.sessionId,
      sessionTitle: sessionTitle ?? this.sessionTitle,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._aiRepository, this._chatHistoryRepository) : super(const ChatState());

  final AiRepository _aiRepository;
  final ChatHistoryRepository _chatHistoryRepository;

  void startNewChat() {
    state = const ChatState();
  }

  void loadSession(ChatSession session) {
    state = ChatState(
      sessionId: session.id,
      sessionTitle: session.title,
      messages: session.messages,
      isLoading: false,
    );
  }

  Future<void> sendUserMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty || state.isLoading) return;

    final sessionId = state.sessionId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final sessionTitle = state.sessionTitle ??
        (trimmed.length > 36 ? '${trimmed.substring(0, 36)}...' : trimmed);

    final userMessage = ChatMessage.user(trimmed);
    final updatedMessages = [...state.messages, userMessage];

    state = state.copyWith(
      sessionId: sessionId,
      sessionTitle: sessionTitle,
      messages: updatedMessages,
      isLoading: true,
      errorMessage: null,
    );

    // Save user message immediately to session history
    await _chatHistoryRepository.saveSession(
      ChatSession(
        id: sessionId,
        title: sessionTitle,
        createdAt: DateTime.now(),
        messages: updatedMessages,
      ),
    );

    try {
      final responseText = await _aiRepository.sendMessage(updatedMessages);
      final assistantMessage = ChatMessage.assistant(responseText);
      final finalMessages = [...updatedMessages, assistantMessage];
      state = state.copyWith(
        messages: finalMessages,
        isLoading: false,
      );
      await _chatHistoryRepository.saveSession(
        ChatSession(
          id: sessionId,
          title: sessionTitle,
          createdAt: DateTime.now(),
          messages: finalMessages,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> deleteSession(String id) async {
    await _chatHistoryRepository.deleteSession(id);
    if (state.sessionId == id) {
      state = const ChatState();
    }
  }

  void clearConversation() {
    state = const ChatState();
  }
}

class ChatSessionsNotifier extends StateNotifier<List<ChatSession>> {
  ChatSessionsNotifier(this._repository) : super([]) {
    loadSessions();
  }

  final ChatHistoryRepository _repository;

  Future<void> loadSessions() async {
    final list = await _repository.getSessions();
    state = list;
  }

  Future<void> deleteSession(String id) async {
    await _repository.deleteSession(id);
    state = state.where((s) => s.id != id).toList();
  }
}

final chatSessionsProvider = StateNotifierProvider<ChatSessionsNotifier, List<ChatSession>>((ref) {
  final repo = ref.watch(chatHistoryRepositoryProvider);
  return ChatSessionsNotifier(repo);
});

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final aiRepo = ref.watch(aiRepositoryProvider);
  final chatHistoryRepo = ref.watch(chatHistoryRepositoryProvider);
  return ChatNotifier(aiRepo, chatHistoryRepo);
});
