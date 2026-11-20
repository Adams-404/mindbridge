import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'core/theme.dart';
import 'features/assistant/assistant_screen.dart';
import 'features/check_in/check_in_screen.dart';
import 'features/home/home_screen.dart';
import 'features/learn/learn_screen.dart';
import 'features/reset/reset_screen.dart';
import 'features/reminders/reminder_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/support/support_screen.dart';

final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(path: '/learn', builder: (context, state) => const LearnScreen()),
          GoRoute(path: '/check-in', builder: (context, state) => const CheckInScreen()),
          GoRoute(path: '/reset', builder: (context, state) => const ResetScreen()),
          GoRoute(path: '/support', builder: (context, state) => const SupportScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
          GoRoute(path: '/reminders', builder: (context, state) => const ReminderScreen()),
          GoRoute(path: '/assistant', builder: (context, state) => const AssistantScreen()),
        ],
      ),
    ],
  );
});

class MindBridgeApp extends ConsumerWidget {
  const MindBridgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(languageProvider);
    return MaterialApp.router(
      title: 'MindBridge',
      debugShowCheckedModeBanner: false,
      theme: MindBridgeTheme.light,
      routerConfig: ref.watch(_routerProvider),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  int get _index {
    if (location.startsWith('/learn')) return 1;
    if (location.startsWith('/check-in')) return 2;
    if (location.startsWith('/support')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          const paths = ['/', '/learn', '/check-in', '/support'];
          context.go(paths[index]);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Learn'),
          NavigationDestination(icon: Icon(Icons.spa_outlined), selectedIcon: Icon(Icons.spa), label: 'Check-in'),
          NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Support'),
        ],
      ),
    );
  }
}
