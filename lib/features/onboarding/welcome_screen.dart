import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const _seenKey = 'mindbridge_onboarding_seen';
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _checkFirstRun();
  }

  Future<void> _checkFirstRun() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    if (preferences.getBool(_seenKey) == true) {
      context.go('/');
      return;
    }
    setState(() => _checking = false);
  }

  Future<void> _finish() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_seenKey, true);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 34, 24, 30),
          children: [
            const Text(
              'MINDBRIDGE AI',
              style: TextStyle(
                color: MindBridgeTheme.forest,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 35),
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
            _WelcomeSection(
              icon: Icons.translate_rounded,
              title: 'Language',
              body: 'The current interface is in English. Hausa translation is being prepared and will be labelled clearly when it has been reviewed.',
            ),
            const SizedBox(height: 12),
            _WelcomeSection(
              icon: Icons.lock_outline_rounded,
              title: 'Privacy, plainly',
              body: 'No account is needed. This prototype keeps check-ins and reminders in app memory only. They are not sent to a server or saved as personal records. One local preference remembers that you have seen this introduction.',
            ),
            const SizedBox(height: 12),
            _WelcomeSection(
              icon: Icons.health_and_safety_outlined,
              title: 'What MindBridge can and cannot do',
              body: 'MindBridge offers general mental health information and self-guided activities. It does not diagnose, provide therapy, replace a qualified professional, or provide emergency or crisis support.',
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF0E3D9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE0C9BA)),
              ),
              child: const Text(
                'You do not need to share symptoms, personal history, or any sensitive information to use this app.',
                style: TextStyle(fontSize: 12, height: 1.55, color: MindBridgeTheme.ink),
              ),
            ),
            const SizedBox(height: 25),
            FilledButton(
              onPressed: _finish,
              child: const Text('Continue to MindBridge'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _finish,
              child: const Text('Skip introduction'),
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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD9D4C8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: MindBridgeTheme.forest, size: 21),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: MindBridgeTheme.ink)),
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
