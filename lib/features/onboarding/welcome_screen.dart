import 'dart:math' as math;
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
  final Set<String> _selectedIntents = {'Just exploring'};

  static const _intentOptions = [
    ('🌿 Easing stress & worry', 'Easing stress & worry'),
    ('🌙 Better sleep & calm', 'Better sleep & calm'),
    ('🧭 Understanding emotions', 'Understanding emotions'),
    ('🌬️ Breathing & grounding', 'Breathing & grounding'),
    ('✨ Just exploring', 'Just exploring'),
  ];

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

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                      width: 1.4,
                    ),
                    boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
                  ),
                  child: const Text(
                    'MINDBRIDGE AI',
                    style: TextStyle(
                      color: MindBridgeTheme.clay,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _finish();
                  },
                  child: Text(
                    'Skip introduction',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Hero Row with Title + Custom Neo-Brutalist Vector Art
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'A place to\nstart with care.',
                    style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 32,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF18221D) : const Color(0xFFE8EDE5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                      width: MindBridgeTheme.borderWidth,
                    ),
                    boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CustomPaint(
                      painter: _OnboardingSunrisePainter(isDark: isDark),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'A little context before you begin. Use what feels helpful, skip what does not, and take things at your own pace.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            const _WelcomeSection(
              icon: Icons.translate_rounded,
              title: 'Language',
              body: 'The current interface is in English. Hausa translation is being prepared and will be labelled clearly when it has been reviewed.',
            ),
            const SizedBox(height: 10),
            const _WelcomeSection(
              icon: Icons.lock_outline_rounded,
              title: 'Privacy, plainly',
              body: 'No account is needed. MindBridge stores check-ins and reminders privately on your device. Your reflections are never sent to external servers or sold. One local preference remembers that you have seen this introduction.',
            ),
            const SizedBox(height: 10),
            const _WelcomeSection(
              icon: Icons.health_and_safety_outlined,
              title: 'What MindBridge can and cannot do',
              body: 'MindBridge offers general mental health information and self-guided activities. It does not diagnose, provide therapy, replace a qualified professional, or provide emergency or crisis support.',
            ),
            const SizedBox(height: 18),
            // Intent Selection Chips
            Text(
              'What brings you here today?',
              style: theme.textTheme.titleMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _intentOptions.map((opt) {
                final isSelected = _selectedIntents.contains(opt.$2);
                return FilterChip(
                  label: Text(
                    opt.$1,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? (isDark ? Colors.black : MindBridgeTheme.paper)
                          : (isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink),
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                  backgroundColor: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                      width: 1.4,
                    ),
                  ),
                  showCheckmark: false,
                  onSelected: (selected) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      if (selected) {
                        _selectedIntents.add(opt.$2);
                      } else if (_selectedIntents.length > 1) {
                        _selectedIntents.remove(opt.$2);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2B201A) : const Color(0xFFF0E3D9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? MindBridgeTheme.clay : MindBridgeTheme.ink,
                  width: MindBridgeTheme.borderWidth,
                ),
                boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
              ),
              child: Text(
                'You do not need to share symptoms, personal history, or any sensitive information to use this app.',
                style: TextStyle(
                  fontSize: 12,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                ),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: _finish,
              child: const Text('Continue to MindBridge'),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _finish();
                },
                child: Text(
                  'Skip introduction',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
                  ),
                ),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
          width: MindBridgeTheme.borderWidth,
        ),
        boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF262626) : const Color(0xFFE8EDE5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: 1.4,
              ),
            ),
            child: Icon(icon, color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.45,
                    color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSunrisePainter extends CustomPainter {
  const _OnboardingSunrisePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final sunFill = Paint()
      ..color = MindBridgeTheme.clay
      ..style = PaintingStyle.fill;

    final hillFill1 = Paint()
      ..color = isDark ? const Color(0xFF1E2F26) : const Color(0xFFD3DEC8)
      ..style = PaintingStyle.fill;

    final hillFill2 = Paint()
      ..color = isDark ? const Color(0xFF2A4236) : const Color(0xFFB8C8AC)
      ..style = PaintingStyle.fill;

    // Sun
    final sunCenter = Offset(size.width * 0.5, size.height * 0.75);
    const sunRadius = 24.0;

    // Sun rays
    final rayPaint = Paint()
      ..color = isDark ? MindBridgeTheme.milk.withOpacity(0.5) : MindBridgeTheme.clay.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    for (int i = 0; i < 7; i++) {
      final angle = math.pi + (i * (math.pi / 6));
      final p1 = Offset(
        sunCenter.dx + math.cos(angle) * (sunRadius + 6),
        sunCenter.dy + math.sin(angle) * (sunRadius + 6),
      );
      final p2 = Offset(
        sunCenter.dx + math.cos(angle) * (sunRadius + 14),
        sunCenter.dy + math.sin(angle) * (sunRadius + 14),
      );
      canvas.drawLine(p1, p2, rayPaint);
    }

    canvas.drawCircle(sunCenter, sunRadius, sunFill);
    canvas.drawCircle(sunCenter, sunRadius, strokePaint);

    // Rolling hill 1
    final hillPath1 = Path()
      ..moveTo(-5, size.height)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.5, size.width * 0.65, size.height)
      ..close();
    canvas.drawPath(hillPath1, hillFill1);
    canvas.drawPath(hillPath1, strokePaint);

    // Rolling hill 2
    final hillPath2 = Path()
      ..moveTo(size.width * 0.35, size.height)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.55, size.width + 5, size.height)
      ..close();
    canvas.drawPath(hillPath2, hillFill2);
    canvas.drawPath(hillPath2, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _OnboardingSunrisePainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
