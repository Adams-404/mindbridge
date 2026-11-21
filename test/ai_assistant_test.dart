import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mindbridge/core/config/ai_config.dart';
import 'package:mindbridge/core/providers.dart';
import 'package:mindbridge/data/ai_repository.dart';
import 'package:mindbridge/features/assistant/assistant_screen.dart';

class FakeAiRepository implements AiRepository {
  FakeAiRepository({this.customResponse, this.throwError = false, this.delay});

  final String? customResponse;
  final bool throwError;
  final Duration? delay;
  final List<List<ChatMessage>> recordedCalls = [];

  @override
  Future<String> sendMessage(
    List<ChatMessage> conversation, {
    String? model,
    String? customApiKey,
  }) async {
    recordedCalls.add(List.from(conversation));
    if (delay != null) {
      await Future<void>.delayed(delay!);
    }
    if (throwError) {
      throw Exception('Simulated network timeout');
    }
    return customResponse ??
        'This is a compassionate psychoeducational response from MindBridge AI.';
  }
}

class FakeSettingsRepository implements SettingsRepository {
  AppLanguage _lang = AppLanguage.english;
  bool _seenOnboarding = true;

  @override
  Future<AppLanguage> getLanguage() async => _lang;

  @override
  Future<void> setLanguage(AppLanguage language) async {
    _lang = language;
  }

  @override
  Future<bool> hasSeenOnboarding() async => _seenOnboarding;

  @override
  Future<void> setOnboardingSeen(bool seen) async {
    _seenOnboarding = seen;
  }
}

void main() {
  group('AiConfig & Groq specifications', () {
    test('Default configuration targets Groq Qwen 3.8 27B with safety boundaries', () {
      expect(AiConfig.groqApiUrl, 'https://api.groq.com/openai/v1/chat/completions');
      expect(AiConfig.defaultModel, 'qwen/qwen3.8-27b');
      expect(AiConfig.apiKey, startsWith('gsk_'));
      expect(AiConfig.apiKey.length, greaterThan(20));

      expect(AiConfig.systemPrompt, contains('MindBridge AI'));
      expect(AiConfig.systemPrompt, contains('CRITICAL SAFETY BOUNDARIES'));
      expect(AiConfig.systemPrompt, contains('NEVER diagnose'));
      expect(AiConfig.systemPrompt, contains('NEVER prescribe'));
      expect(AiConfig.systemPrompt, contains('Hausa'));
    });
  });

  group('GroqAiRepository HTTP communication', () {
    test('Successful API response decodes assistant message content', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), AiConfig.groqApiUrl);
        expect(request.headers['Authorization'], startsWith('Bearer gsk_'));

        final body = jsonDecode(request.body) as Map<String, dynamic>;
        expect(body['model'], 'qwen/qwen3.8-27b');
        expect(body['messages'], isNotEmpty);

        final sampleResponse = {
          'id': 'chatcmpl-test-123',
          'choices': [
            {
              'message': {
                'role': 'assistant',
                'content': 'Deep breathing helps activate your parasympathetic nervous system.',
              },
              'finish_reason': 'stop',
            }
          ]
        };

        return http.Response(jsonEncode(sampleResponse), 200, headers: {
          'content-type': 'application/json; charset=utf-8',
        });
      });

      final repo = GroqAiRepository(client: mockClient);
      final reply = await repo.sendMessage([
        ChatMessage.user('How does breathing help?'),
      ]);

      expect(reply, 'Deep breathing helps activate your parasympathetic nervous system.');
    });

    test('Non-200 API response surfaces descriptive exception', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'error': {'message': 'Invalid API Key'}}),
          401,
          headers: {'content-type': 'application/json'},
        );
      });

      final repo = GroqAiRepository(client: mockClient);
      expect(
        () => repo.sendMessage([ChatMessage.user('Hello')]),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('ChatNotifier & Riverpod state', () {
    test('User message submission updates state and receives assistant reply', () async {
      final fakeRepo = FakeAiRepository(customResponse: 'Stress is your body reaction.');
      final notifier = ChatNotifier(fakeRepo);

      expect(notifier.state.messages, isEmpty);
      expect(notifier.state.isLoading, isFalse);

      final future = notifier.sendUserMessage('What is stress?');
      expect(notifier.state.isLoading, isTrue);
      expect(notifier.state.messages.length, 1);
      expect(notifier.state.messages.first.content, 'What is stress?');

      await future;

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.messages.length, 2);
      expect(notifier.state.messages[1].role, 'assistant');
      expect(notifier.state.messages[1].content, 'Stress is your body reaction.');
      expect(notifier.state.errorMessage, isNull);
    });

    test('Error during message sending captures errorMessage in state', () async {
      final fakeRepo = FakeAiRepository(throwError: true);
      final notifier = ChatNotifier(fakeRepo);

      await notifier.sendUserMessage('Test error');

      expect(notifier.state.isLoading, isFalse);
      expect(notifier.state.errorMessage, contains('Simulated network timeout'));
      expect(notifier.state.messages.length, 1);
    });

    test('clearConversation resets all messages', () async {
      final fakeRepo = FakeAiRepository();
      final notifier = ChatNotifier(fakeRepo);

      await notifier.sendUserMessage('Hi');
      expect(notifier.state.messages, isNotEmpty);

      notifier.clearConversation();
      expect(notifier.state.messages, isEmpty);
      expect(notifier.state.isLoading, isFalse);
    });
  });

  group('AssistantScreen Neo-Brutalist UI & Interaction', () {
    testWidgets('Renders model status banner, suggestions and sends prompt', (tester) async {
      final fakeRepo = FakeAiRepository(
        customResponse: 'Damuwa da gajiya alamu ne da ke nuna bukatar hutu.',
        delay: const Duration(milliseconds: 100),
      );
      final fakeSettings = FakeSettingsRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiRepositoryProvider.overrideWithValue(fakeRepo),
            settingsRepositoryProvider.overrideWithValue(fakeSettings),
          ],
          child: const MaterialApp(
            home: AssistantScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify active model indicator
      expect(find.textContaining('Active Model: Qwen 3.8 27B (Groq)'), findsOneWidget);
      expect(find.text('Grounded Psychoeducation'), findsOneWidget);
      expect(find.text('SUGGESTED EXPLORATIONS'), findsOneWidget);

      // Verify suggestion chips
      final suggestionChip = find.text('What is the difference between stress and anxiety?');
      expect(suggestionChip, findsOneWidget);

      // Tap suggestion chip
      await tester.tap(suggestionChip);
      await tester.pump(); // Triggers loading state

      expect(find.text('MindBridge AI is reflecting...'), findsOneWidget);

      await tester.pumpAndSettle(); // Completes async call

      // User and assistant bubbles visible
      expect(find.text('What is the difference between stress and anxiety?'), findsOneWidget);
      expect(find.text('Damuwa da gajiya alamu ne da ke nuna bukatar hutu.'), findsOneWidget);

      // Verify clear button appears when conversation is non-empty
      final clearButton = find.byTooltip('Clear conversation');
      expect(clearButton, findsOneWidget);

      // Tap clear conversation
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Restored to initial introductory state
      expect(find.text('SUGGESTED EXPLORATIONS'), findsOneWidget);
    });

    testWidgets('Custom input field submits question via send button', (tester) async {
      final fakeRepo = FakeAiRepository(
        customResponse: 'Breathing slowly stimulates the vagus nerve.',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aiRepositoryProvider.overrideWithValue(fakeRepo),
          ],
          child: const MaterialApp(
            home: AssistantScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Enter query
      await tester.enterText(find.byType(TextField), 'How does deep breathing work?');
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pumpAndSettle();

      expect(find.text('How does deep breathing work?'), findsOneWidget);
      expect(find.text('Breathing slowly stimulates the vagus nerve.'), findsOneWidget);
    });
  });
}
