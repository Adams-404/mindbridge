import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindbridge/app.dart';

void main() {
  testWidgets('app opens on the home screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();

    expect(find.textContaining('Good to have'), findsOneWidget);
  });

  testWidgets('bottom navigation opens learning screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('A little clarity'), findsOneWidget);
    expect(find.text('Search topics'), findsOneWidget);
  });

  testWidgets('learning library filters articles by search query', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'anxiety');
    await tester.pumpAndSettle();

    expect(find.text('Understanding anxiety'), findsOneWidget);
    expect(find.text('Understanding depression'), findsNothing);
    expect(find.text('1 article'), findsOneWidget);
  });

  testWidgets('article detail exposes review metadata honestly', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Understanding depression'));
    await tester.pumpAndSettle();

    expect(find.text('CONTENT RECORD'), findsOneWidget);
    expect(find.text('Pending verification'), findsOneWidget);
    expect(find.text('Not assigned'), findsOneWidget);
    expect(find.text('0.1.0'), findsOneWidget);
  });

  testWidgets('check-in can be skipped without creating a score', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check-in').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Skip this check-in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Skip this check-in'));
    await tester.pumpAndSettle();

    expect(find.text('That’s completely okay.'), findsOneWidget);
    expect(find.textContaining('not a diagnosis'), findsNothing);
    expect(find.textContaining('not written to storage'), findsOneWidget);
  });

  testWidgets('follow-up reminders can be added and deleted in-session', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.text('Keep a follow-up in sight'),
      find.byType(Scrollable).first,
      const Offset(0, -280),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep a follow-up in sight'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Call the clinic');
    await tester.ensureVisible(find.text('Add reminder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add reminder'));
    await tester.pumpAndSettle();

    expect(find.text('Call the clinic'), findsOneWidget);
    expect(find.textContaining('held in memory only'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete reminder'));
    await tester.pumpAndSettle();

    expect(find.text('Call the clinic'), findsNothing);
  });

  testWidgets('reset screen offers breathing, grounding and body pause exercises', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Take a breathing pause'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take a breathing pause'));
    await tester.pumpAndSettle();

    expect(find.text('Choose an exercise'), findsOneWidget);
    await tester.tap(find.text('Grounding'));
    await tester.pumpAndSettle();
    expect(find.text('things you can see'), findsOneWidget);
    expect(find.text('things you can hear'), findsOneWidget);

    await tester.tap(find.text('Body pause'));
    await tester.pumpAndSettle();
    expect(find.text('A moment to notice your body'), findsOneWidget);
  });

  testWidgets('breathing exercise can be paused, resumed and stopped', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ProviderScope(child: MindBridgeApp()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Take a breathing pause'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Take a breathing pause'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Begin gently'));
    await tester.pump();
    expect(find.text('Pause'), findsOneWidget);
    await tester.tap(find.text('Pause'));
    await tester.pump();
    expect(find.text('Resume'), findsOneWidget);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(find.text('Stop exercise'), findsOneWidget);
    await tester.tap(find.text('Stop exercise'));
    await tester.pumpAndSettle();
    expect(find.text('Begin gently'), findsOneWidget);
  });

}
