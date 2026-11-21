import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindbridge/app.dart';
import 'package:mindbridge/core/theme.dart';
import 'package:mindbridge/core/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({'mindbridge_onboarding_seen': true});
  });

  testWidgets('floating bottom navigation renders floating container with neo-brutalist styling', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();

    expect(find.byType(FloatingBottomBar), findsOneWidget);

    final floatingBarFinder = find.byType(FloatingBottomBar);
    final container = tester.widget<Container>(
      find.descendant(of: floatingBarFinder, matching: find.byType(Container)).first,
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.boxShadow, isNotNull);
    expect(decoration.border, isNotNull);
    expect(decoration.borderRadius, BorderRadius.circular(16));
  });

  testWidgets('active bottom nav item has stroked border and no solid fill highlight', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();

    // On home screen, Home is active
    final homeItem = find.ancestor(of: find.text('Home'), matching: find.byType(AnimatedContainer)).first;
    final homeContainer = tester.widget<AnimatedContainer>(homeItem);
    final homeDec = homeContainer.decoration as BoxDecoration;

    // Stroke outline only!
    expect(homeDec.border, isNotNull);
    final homeBorder = homeDec.border as Border;
    expect(homeBorder.top.color, MindBridgeTheme.forest);
    expect(homeBorder.top.width, 1.8);
    expect(homeDec.color, Colors.transparent);

    // Learn is inactive
    final learnItem = find.ancestor(of: find.text('Learn').last, matching: find.byType(AnimatedContainer)).first;
    final learnContainer = tester.widget<AnimatedContainer>(learnItem);
    final learnDec = learnContainer.decoration as BoxDecoration;
    final learnBorder = learnDec.border as Border;
    expect(learnBorder.top.color, Colors.transparent);
  });

  testWidgets('switching tabs triggers haptic feedback and updates active stroke', (tester) async {
    final List<String> hapticCalls = [];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (MethodCall methodCall) async {
        if (methodCall.method == 'HapticFeedback.vibrate') {
          hapticCalls.add(methodCall.arguments as String);
        }
        return null;
      },
    );

    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();

    // Tap Check-in tab
    await tester.tap(find.text('Check-in'));
    await tester.pumpAndSettle();

    expect(find.textContaining('How are you'), findsOneWidget);
    expect(hapticCalls, contains('HapticFeedbackType.lightImpact'));

    // Check-in item is now stroked
    final checkInItem = find.ancestor(of: find.text('Check-in'), matching: find.byType(AnimatedContainer)).first;
    final checkInContainer = tester.widget<AnimatedContainer>(checkInItem);
    final checkInDec = checkInContainer.decoration as BoxDecoration;
    final checkInBorder = checkInDec.border as Border;
    expect(checkInBorder.top.color, MindBridgeTheme.forest);
    expect(checkInDec.color, Colors.transparent);
  });

  testWidgets('SafetyNote renders neo-brutalist container with border and shadow', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SafetyNote(),
        ),
      ),
    );

    final containerFinder = find.descendant(
      of: find.byType(SafetyNote),
      matching: find.byType(Container),
    ).first;
    final container = tester.widget<Container>(containerFinder);
    final dec = container.decoration as BoxDecoration;

    expect(dec.border, isNotNull);
    expect(dec.boxShadow, isNotNull);
  });
}
