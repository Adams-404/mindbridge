import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindbridge/app.dart';
import 'package:mindbridge/core/providers.dart';
import 'package:mindbridge/core/theme.dart';
import 'package:mindbridge/core/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'mindbridge_onboarding_seen': true,
      'mindbridge_theme_mode': 'system',
    });
  });

  group('Navigation Shell & Floating Elements', () {
    testWidgets('renders floating top header, ejected AI pill, and 5-item floating bottom bar', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Top floating header & ejected AI pill exist
      expect(find.byType(FloatingTopHeader), findsOneWidget);
      expect(find.byType(FloatingAiPill), findsOneWidget);
      expect(find.text('mindbridge'), findsOneWidget);
      expect(find.text('AI'), findsWidgets);

      // Bottom bar has 5 destinations: Home, Learn, Check-in, Support, Settings
      expect(find.byType(FloatingBottomBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Learn'), findsWidgets);
      expect(find.text('Check-in'), findsWidgets);
      expect(find.text('Support'), findsWidgets);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('tapping ejected AI pill enters chatbot with hidden header/bottom nav and floating back button', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Tap AI pill
      await tester.tap(find.byType(FloatingAiPill));
      await tester.pumpAndSettle();

      // On assistant screen: header and bottom nav are hidden
      expect(find.byType(FloatingTopHeader), findsNothing);
      expect(find.byType(FloatingBottomBar), findsNothing);
      expect(find.byType(FloatingBackButton), findsOneWidget);

      // Tap floating back button returns to home
      await tester.tap(find.byType(FloatingBackButton));
      await tester.pumpAndSettle();

      expect(find.byType(FloatingTopHeader), findsOneWidget);
      expect(find.byType(FloatingBottomBar), findsOneWidget);
    });

    testWidgets('theme switching in Settings toggles light and dark theme mode', (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
      await tester.pumpAndSettle();

      // Navigate to Settings via bottom nav
      await tester.tap(find.byTooltip('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Appearance & Theme'), findsOneWidget);
      expect(find.text('Dark (Pure Black)'), findsOneWidget);

      // Tap Dark theme
      await tester.tap(find.text('Dark (Pure Black)'));
      await tester.pumpAndSettle();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold).first);
      expect(scaffold.backgroundColor, Colors.black);
    });
  });
}
