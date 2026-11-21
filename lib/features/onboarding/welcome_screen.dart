import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';
import '../../core/theme.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final hasSeen = await settingsRepo.hasSeenOnboarding();
    if (!mounted) return;
    if (hasSeen) {
      context.go('/');
      return;
    }
    setState(() => _checking = false);
  }

  Future<void> _finish() async {
    HapticFeedback.mediumImpact();
    await ref.read(settingsRepositoryProvider).setOnboardingSeen(true);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: MindBridgeTheme.forest)),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 40),
          children: [
            const Text(
              'MINDBRIDGE AI',
              style: TextStyle(
                color: MindBridgeTheme.forest,
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'A place to\nstart with care.',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 38,
                    height: 1.08,
                  ),
            ),
            const SizedBox(height: 14),
            Text(
              'A little context before you begin. Use what feels helpful, skip what does not, and take things at your own pace.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            const _WelcomeSection(
              icon: Icons.translate_rounded,
              title: 'Language',
              body: 'The current interface is in English. Hausa translation is being prepared and will be labelled clearly when it has been reviewed.',
            ),
            const SizedBox(height: 14),
            const _WelcomeSection(
              icon: Icons.lock_outline_rounded,
              title: 'Privacy, plainly',
              body: 'No account is needed. This prototype keeps check-ins and reminders in app memory only. They are not sent to a server or saved as personal records. One local preference remembers that you have seen this introduction.',
            ),
            const SizedBox(height: 14),
            const _WelcomeSection(
              icon: Icons.health_and_safety_outlined,
              title: 'What MindBridge can and cannot do',
              body: 'MindBridge offers general mental health information and self-guided activities. It does not diagnose, provide therapy, replace a qualified professional, or provide emergency or crisis support.',
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0E3D9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
                boxShadow: MindBridgeTheme.neoShadowSmall,
              ),
              child: const Text(
                'You do not need to share symptoms, personal history, or any sensitive information to use this app.',
                style: TextStyle(fontSize: 12, height: 1.55, fontWeight: FontWeight.w600, color: MindBridgeTheme.ink),
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              onPressed: _finish,
              child: const Text('Continue to MindBridge'),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _finish();
                },
                child: const Text('Skip introduction', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MindBridgeTheme.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
        boxShadow: MindBridgeTheme.neoShadowSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDE5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
            ),
            child: Icon(icon, color: MindBridgeTheme.forest, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink)),
                const SizedBox(height: 5),
                Text(body, style: const TextStyle(fontSize: 12, height: 1.55, color: MindBridgeTheme.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
