import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindbridge/app.dart';
import 'package:mindbridge/data/check_in_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'mindbridge_onboarding_seen': true,
    });
  });

  group('Check-In Production System & Analytics', () {
    testWidgets('CheckInRepository persists and restores check-ins via SharedPreferences', (tester) async {
      final repo = SharedPrefsCheckInRepository();
      expect(await repo.getEntries(), isEmpty);

      final entry = CheckInEntry(
        id: 'test-1',
        timestamp: DateTime.now(),
        mood: 'Bright',
        symbol: '☀',
        score: 5,
        note: 'Feeling refreshed after a morning walk.',
        factors: ['Sleep', 'Body & Health'],
      );

      await repo.addEntry(entry);
      final list = await repo.getEntries();
      expect(list.length, 1);
      expect(list.first.mood, 'Bright');
      expect(list.first.score, 5);
      expect(list.first.factors, contains('Sleep'));

      await repo.deleteEntry('test-1');
      expect(await repo.getEntries(), isEmpty);
    });

    testWidgets('User can select mood, add factors, save reflection and see stats updated', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Navigate to Check-in screen
      await tester.tap(find.text('Check-in').first);
      await tester.pumpAndSettle();

      expect(find.text('How are you\nfeeling today?'), findsOneWidget);
      expect(find.text('No check-ins logged yet'), findsOneWidget);

      // Select 'Calm'
      await tester.tap(find.text('Calm'));
      await tester.pumpAndSettle();

      expect(find.text('Feeling Calm'), findsOneWidget);

      // Tap Save Reflection
      await tester.tap(find.text('Save Reflection'));
      await tester.pumpAndSettle();

      expect(find.text('Thank you for pausing.'), findsOneWidget);
      expect(find.text('Mood Trajectory'), findsOneWidget);
      expect(find.text('TOTAL LOGGED'), findsOneWidget);
      expect(find.text('1'), findsWidgets); // 1 logged
    });
  });
}
