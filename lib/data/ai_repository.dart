import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../core/config/ai_config.dart';

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });

  final String role; // 'user' | 'assistant' | 'system'
  final String content;
  final DateTime timestamp;

  Map<String, String> toJson() => {
        'role': role,
        'content': content,
      };

  factory ChatMessage.user(String content) => ChatMessage(
        role: 'user',
        content: content,
        timestamp: DateTime.now(),
      );

  factory ChatMessage.assistant(String content) => ChatMessage(
        role: 'assistant',
        content: content,
        timestamp: DateTime.now(),
      );
}

abstract interface class AiRepository {
  Future<String> sendMessage(
    List<ChatMessage> conversation, {
    String? model,
    String? customApiKey,
  });
}

class GroqAiRepository implements AiRepository {
  GroqAiRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<String> sendMessage(
    List<ChatMessage> conversation, {
    String? model,
    String? customApiKey,
  }) async {
    final apiKey = (customApiKey != null && customApiKey.isNotEmpty)
        ? customApiKey
        : AiConfig.apiKey;

    final targetModel = model ?? AiConfig.defaultModel;

    final messages = [
      {'role': 'system', 'content': AiConfig.systemPrompt},
      ...conversation.map((m) => m.toJson()),
    ];

    try {
      final response = await _client.post(
        Uri.parse(AiConfig.groqApiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': targetModel,
          'messages': messages,
          'temperature': 0.6,
          'max_tokens': 1024,
        }),
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final choices = data['choices'] as List<dynamic>?;
        if (choices != null && choices.isNotEmpty) {
          final firstChoice = choices[0] as Map<String, dynamic>;
          final message = firstChoice['message'] as Map<String, dynamic>?;
          final content = message?['content'] as String?;
          if (content != null && content.trim().isNotEmpty) {
            return content.trim();
          }
        }
        return 'Thank you for sharing. How else can I support your understanding today?';
      } else {
        final errorBody = response.body;
        throw Exception('Groq API error (${response.statusCode}): $errorBody');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Unable to reach MindBridge AI assistant. Please check your network connection.');
      }
      rethrow;
    }
  }
}

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return GroqAiRepository();
});
