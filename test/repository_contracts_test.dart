import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindbridge/app.dart';
import 'package:mindbridge/core/providers.dart';
import 'package:mindbridge/data/learning_content.dart';
import 'package:mindbridge/data/learning_repository.dart';
import 'package:mindbridge/data/reminders_repository.dart';
import 'package:mindbridge/data/support_repository.dart';
import 'package:mindbridge/features/support/support_screen.dart';

// --- Fakes & Mocks for Testing ---

class FakeLearningRepository implements LearningRepository {
  FakeLearningRepository(this.articles);
  final List<LearningArticle> articles;

  @override
  List<LearningArticle> getArticles() => articles;
}

class FakeSupportRepository implements SupportRepository {
  FakeSupportRepository({
    this.statusMessage = 'Fake verification status message.',
    this.isAvailable = false,
    this.providers = const [],
  });

  final String statusMessage;
  final bool isAvailable;
  final List<SupportProviderEntry> providers;

  @override
  Future<SupportDirectoryMetadata> getDirectoryMetadata() async {
    return SupportDirectoryMetadata(
      isAvailable: isAvailable,
      statusMessage: statusMessage,
      verificationGuidelines: 'Fake guidelines.',
    );
  }

  @override
  Future<List<SupportProviderEntry>> getProviders() async => providers;
}

class FakeSettingsRepository implements SettingsRepository {
  AppLanguage _language = AppLanguage.english;
  bool _onboardingSeen = false;

  @override
  Future<AppLanguage> getLanguage() async => _language;

  @override
  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
  }

  @override
  Future<bool> hasSeenOnboarding() async => _onboardingSeen;

  @override
  Future<void> setOnboardingSeen(bool seen) async {
    _onboardingSeen = seen;
  }
}

void main() {
  group('Issue #9: Riverpod dependency injection and repository contracts', () {
    test('RemindersRepository in-memory implementation operates cleanly without global state', () {
      final repo1 = InMemoryRemindersRepository();
      final repo2 = InMemoryRemindersRepository();

      final reminder = FollowUpReminder(title: 'Doctor visit', date: DateTime(2026, 12, 1));
      repo1.addReminder(reminder);

      expect(repo1.getReminders(), [reminder]);
      expect(repo2.getReminders(), isEmpty); // No shared mutable global state!

      repo1.removeReminder(0);
      expect(repo1.getReminders(), isEmpty);
    });

    test('SettingsRepository fake isolates settings and language state between containers', () async {
      final fakeSettings = FakeSettingsRepository();
      final container = ProviderContainer(
        overrides: [
          settingsRepositoryProvider.overrideWithValue(fakeSettings),
        ],
      );
      addTearDown(container.dispose);

      expect(await fakeSettings.hasSeenOnboarding(), isFalse);
      await fakeSettings.setOnboardingSeen(true);
      expect(await fakeSettings.hasSeenOnboarding(), isTrue);

      expect(container.read(languageProvider), AppLanguage.english);
      await container.read(languageProvider.notifier).setLanguage(AppLanguage.hausa);
      expect(container.read(languageProvider), AppLanguage.hausa);
      expect(await fakeSettings.getLanguage(), AppLanguage.hausa);
    });

    testWidgets('LearningRepository provider override dynamically feeds LearnScreen with fakes', (tester) async {
      final fakeArticles = [
        const LearningArticle(
          id: 'test-article',
          title: 'Custom Injected Article',
          summary: 'Injected through Riverpod dependency injection fake.',
          category: 'Test Category',
          reviewStatus: 'Verified by Unit Test',
          sections: ['Section content.'],
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            learningRepositoryProvider.overrideWithValue(FakeLearningRepository(fakeArticles)),
            settingsRepositoryProvider.overrideWithValue(
              FakeSettingsRepository()..setOnboardingSeen(true),
            ),
          ],
          child: const MindBridgeApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Go to learn tab
      await tester.tap(find.text('Learn').last);
      await tester.pumpAndSettle();

      expect(find.text('Custom Injected Article'), findsOneWidget);
      expect(find.text('1 article'), findsOneWidget);
    });

    testWidgets('SupportRepository provider override delivers custom directory status to SupportScreen', (tester) async {
      const customMessage = 'Custom directory test notice from injected fake repository.';

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            supportRepositoryProvider.overrideWithValue(
              FakeSupportRepository(statusMessage: customMessage),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SupportScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('RemindersRepository provider override isolates reminders state in UI', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final fakeRemindersRepo = InMemoryRemindersRepository()
        ..addReminder(FollowUpReminder(title: 'Pre-seeded reminder', date: DateTime(2026, 11, 25)));

      final container = ProviderContainer(
        overrides: [
          remindersRepositoryProvider.overrideWithValue(fakeRemindersRepo),
          settingsRepositoryProvider.overrideWithValue(
            FakeSettingsRepository()..setOnboardingSeen(true),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MindBridgeApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Tap reminder entry point
      await tester.dragUntilVisible(
        find.text('Keep a follow-up in sight'),
        find.byType(Scrollable).first,
        const Offset(0, -280),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.ancestor(
        of: find.text('Keep a follow-up in sight'),
        matching: find.byType(InkWell),
      ).first);
      await tester.pumpAndSettle();

      expect(find.text('Pre-seeded reminder'), findsOneWidget);

      // Add reminder
      container.read(remindersProvider.notifier).addReminder(
        FollowUpReminder(title: 'Second reminder', date: DateTime(2026, 11, 26)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Second reminder'), findsOneWidget);
      expect(fakeRemindersRepo.getReminders().length, 2);
    });
  });
}
