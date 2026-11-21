import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mindbridge/app.dart';
import 'package:mindbridge/core/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mindbridge_onboarding_seen': true});
  });

  group('Issue #8: Routing, bottom navigation and 404 fallback', () {
    testWidgets('unknown routes show custom neo-brutalist 404 fallback page', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Navigate to an unknown route safely using GoRouter
      final router = GoRouter.of(tester.element(find.byType(AppShell)));
      router.go('/non-existent-route-xyz');
      await tester.pumpAndSettle();

      expect(find.byType(NotFoundScreen), findsOneWidget);
      expect(find.text('404 · NOT FOUND'), findsOneWidget);
      expect(find.text('This page does not exist.'), findsOneWidget);
      expect(find.textContaining('non-existent-route-xyz'), findsOneWidget);

      // Return to home button returns to '/'
      await tester.tap(find.text('Return to Home'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Good to have'), findsOneWidget);
    });

    testWidgets('routes resolve safely and bottom navigation reflects active tab', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Tap Support tab
      await tester.tap(find.text('Support'));
      await tester.pumpAndSettle();
      expect(find.textContaining('right support'), findsOneWidget);

      // Tap Home tab
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Good to have'), findsOneWidget);

      // Tap Settings
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();
      expect(find.text('Settings.'), findsOneWidget);
    });
  });

  group('Issue #10: English and Hausa localisation foundation', () {
    testWidgets('switching language to Hausa dynamically translates home, bottom nav, and safety note', (tester) async {
      SharedPreferences.setMockInitialValues({'mindbridge_onboarding_seen': true});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MindBridgeApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Initially English
      expect(find.textContaining('Good to have'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Learn').last, findsOneWidget);

      // Switch language to Hausa via provider
      await container.read(languageProvider.notifier).setLanguage(AppLanguage.hausa);
      await tester.pumpAndSettle();

      // Verify translated Hausa text on Home screen
      expect(find.textContaining('Muna maraba da'), findsOneWidget);
      expect(find.text('Gida'), findsOneWidget);
      expect(find.text('Koyi'), findsOneWidget);
      expect(find.text('Dubawa'), findsOneWidget);
      expect(find.text('Tallafi'), findsOneWidget);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Koyi kuma ka fahimta'), findsOneWidget);
      expect(find.text('Huta ka sha iska'), findsOneWidget);

      // Verify saved to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('mindbridge_language'), 'hausa');
    });

    testWidgets('restores Hausa language preference from SharedPreferences on app launch', (tester) async {
      SharedPreferences.setMockInitialValues({
        'mindbridge_onboarding_seen': true,
        'mindbridge_language': 'hausa',
      });

      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Home should be in Hausa
      expect(find.textContaining('Muna maraba da'), findsOneWidget);
      expect(find.text('Gida'), findsOneWidget);
    });

    testWidgets('Settings screen documents translation review status clearly', (tester) async {
      SharedPreferences.setMockInitialValues({'mindbridge_onboarding_seen': true});
      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Go to settings
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings.'), findsOneWidget);
      expect(find.text('Translation Review Status'), findsOneWidget);
      expect(find.textContaining('Community & Clinical Review in Progress'), findsOneWidget);
      expect(find.textContaining('No machine translation is presented as fully approved'), findsOneWidget);

      // Select Hausa in Settings
      await tester.tap(find.text('Hausa'));
      await tester.pumpAndSettle();

      expect(find.text('Saituna.'), findsOneWidget);
      expect(find.textContaining('karkashin bitar al\'umma da masana lafiya'), findsOneWidget);
    });
  });
}
