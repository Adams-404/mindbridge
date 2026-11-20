import 'package:flutter/material.dart';
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
    await tester.view.setPhysicalSize(const Size(1080, 1920));
    await tester.view.setDevicePixelRatio(2);
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
    await tester.view.setPhysicalSize(const Size(1080, 1920));
    await tester.view.setDevicePixelRatio(2);
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
}
