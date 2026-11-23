import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindbridge/features/support/support_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableSupportScreen() {
    return const ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: SupportScreen()),
      ),
    );
  }

  testWidgets('SupportScreen renders verified crisis lifelines and emergency alert', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableSupportScreen());
    await tester.pumpAndSettle();

    expect(find.text('IMMEDIATE CRISIS & LIFELINES'), findsOneWidget);
    expect(find.text('988 Suicide & Crisis Lifeline'), findsOneWidget);
    expect(find.text('NHS 111 Mental Health Triage'), findsOneWidget);
    expect(find.text('European Unified Emergency Services'), findsOneWidget);
    expect(find.text('Mentally Aware Nigeria Initiative (MANI)'), findsOneWidget);
  });

  testWidgets('SupportScreen copy button copies number and displays snackbar', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableSupportScreen());
    await tester.pumpAndSettle();

    final copyButtons = find.byTooltip('Copy 988');
    expect(copyButtons, findsOneWidget);

    await tester.tap(copyButtons);
    await tester.pumpAndSettle();

    expect(find.text('Copied 988 to clipboard'), findsOneWidget);
  });

  testWidgets('Appointment preparation checklist toggles question checked state', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableSupportScreen());
    await tester.pumpAndSettle();

    final checklistHeading = find.text('Preparing for Your Appointment');
    await tester.scrollUntilVisible(checklistHeading, 150);
    await tester.pumpAndSettle();

    expect(find.text('0/5 prepared', skipOffstage: false), findsOneWidget);

    // Tap first question
    final firstQuestion = find.text('What licensing and specialized clinical experience do you hold?');
    await tester.scrollUntilVisible(firstQuestion, 150);
    await tester.tap(firstQuestion);
    await tester.pumpAndSettle();

    expect(find.text('1/5 prepared', skipOffstage: false), findsOneWidget);

    // Tap again to uncheck
    await tester.tap(firstQuestion);
    await tester.pumpAndSettle();

    expect(find.text('0/5 prepared', skipOffstage: false), findsOneWidget);
  });
}
