import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  });
}
