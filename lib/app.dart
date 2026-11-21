import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers.dart';
import 'core/theme.dart';
import 'core/widgets.dart';
import 'features/assistant/assistant_screen.dart';
import 'features/check_in/check_in_screen.dart';
import 'features/home/home_screen.dart';
import 'features/learn/learn_screen.dart';
import 'features/onboarding/welcome_screen.dart';
import 'features/reset/reset_screen.dart';
import 'features/reminders/reminder_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/support/support_screen.dart';

Page<dynamic> _buildFadeSlidePage({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.025),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

final _routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    errorBuilder: (context, state) => NotFoundScreen(uri: state.uri.toString()),
    routes: [
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/learn',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const LearnScreen(),
            ),
          ),
          GoRoute(
            path: '/check-in',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const CheckInScreen(),
            ),
          ),
          GoRoute(
            path: '/reset',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const ResetScreen(),
            ),
          ),
          GoRoute(
            path: '/support',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const SupportScreen(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const SettingsScreen(),
            ),
          ),
          GoRoute(
            path: '/reminders',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const ReminderScreen(),
            ),
          ),
          GoRoute(
            path: '/assistant',
            pageBuilder: (context, state) => _buildFadeSlidePage(
              context: context,
              state: state,
              child: const AssistantScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

class _FallbackMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    return const DefaultMaterialLocalizations();
  }

  @override
  bool shouldReload(_FallbackMaterialLocalizationsDelegate old) => false;
}

class _FallbackCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) async {
    return const DefaultCupertinoLocalizations();
  }

  @override
  bool shouldReload(_FallbackCupertinoLocalizationsDelegate old) => false;
}

class MindBridgeApp extends ConsumerWidget {
  const MindBridgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final locale = language == AppLanguage.hausa
        ? const Locale('ha')
        : const Locale('en');

    return MaterialApp.router(
      title: 'MindBridge',
      debugShowCheckedModeBanner: false,
      theme: MindBridgeTheme.light,
      locale: locale,
      supportedLocales: const [
        Locale('en', ''),
        Locale('ha', ''),
      ],
      localizationsDelegates: const [
        _FallbackMaterialLocalizationsDelegate(),
        _FallbackCupertinoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
      backgroundColor: MindBridgeTheme.milk,
      body: SafeArea(
        bottom: false,
        child: child,
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: FloatingBottomBar(
            selectedIndex: _index,
            onDestinationSelected: (index) {
              const paths = ['/', '/learn', '/check-in', '/support'];
              if (index >= 0 && index < paths.length) {
                context.go(paths[index]);
              }
            },
          ),
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({required this.uri, super.key});
  final String uri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MindBridgeTheme.milk,
      appBar: AppBar(
        title: const Text('Page not found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.go('/');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel('404 · NOT FOUND'),
              const SizedBox(height: 12),
              Text(
                'This page does not exist.',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 14),
              Text(
                'The address "$uri" was not recognized. You can return home safely.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.go('/');
                },
                icon: const Icon(Icons.home_outlined),
                label: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
