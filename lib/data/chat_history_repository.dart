import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ai_repository.dart';

class ChatSession {
  const ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'] as String,
        title: json['title'] as String? ?? 'Conversation',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        messages: (json['messages'] as List<dynamic>?)
                ?.map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}

abstract interface class ChatHistoryRepository {
  Future<List<ChatSession>> getSessions();
  Future<void> saveSession(ChatSession session);
  Future<void> deleteSession(String id);
  Future<void> clearAllSessions();
}

class SharedPrefsChatHistoryRepository implements ChatHistoryRepository {
  static const _storageKey = 'mindbridge_chat_history_sessions';

  @override
  Future<List<ChatSession>> getSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    final list = <ChatSession>[];
    for (final item in raw) {
      try {
        list.add(ChatSession.fromJson(jsonDecode(item) as Map<String, dynamic>));
      } catch (_) {}
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> saveSession(ChatSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.insert(0, session);
    }
    final encoded = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  @override
  Future<void> deleteSession(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final sessions = await getSessions();
    sessions.removeWhere((s) => s.id == id);
    final encoded = sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_storageKey, encoded);
  }

  @override
  Future<void> clearAllSessions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

final chatHistoryRepositoryProvider = Provider<ChatHistoryRepository>((ref) {
  return SharedPrefsChatHistoryRepository();
});
