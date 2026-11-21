import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets.dart';
import '../../core/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 36),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  const Text('mindbridge', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -1)),
                  const Text('.', style: TextStyle(fontSize: 24, color: MindBridgeTheme.clay, fontWeight: FontWeight.w900)),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.go('/settings');
                    },
                    icon: const Icon(Icons.tune_rounded, color: MindBridgeTheme.ink),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const SectionLabel('A SPACE TO BEGIN'),
              const SizedBox(height: 12),
              Text(
                'Good to have\nyou here.',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 36, height: 1.08),
              ),
              const SizedBox(height: 12),
              Text(
                'You can take your time. Explore what feels useful, and leave the rest for another day.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EDE5),
                  border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: MindBridgeTheme.neoShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('A MOMENT FOR YOU'),
                    const SizedBox(height: 10),
                    Text(
                      'How are things\nfeeling today?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24, height: 1.15),
                    ),
                    const SizedBox(height: 6),
                    Text('No right answer. Just yours.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.go('/check-in');
                        },
                        child: const Text('Check in, if you like'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text('A place to begin', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              _HomeAction(
                icon: Icons.menu_book_outlined,
                title: 'Learn and understand',
                subtitle: 'Explore mental health information',
                onTap: () => context.go('/learn'),
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.air_rounded,
                title: 'Take a breathing pause',
                subtitle: 'A few moments at your own pace',
                onTap: () => context.go('/reset'),
                accent: true,
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.favorite_border,
                title: 'Find support',
                subtitle: 'Understand your options for professional care',
                onTap: () => context.go('/support'),
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.event_note_outlined,
                title: 'Keep a follow-up in sight',
                subtitle: 'Make a personal reminder',
                onTap: () => context.go('/reminders'),
                accent: true,
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.chat_bubble_outline,
                title: 'MindBridge information assistant',
                subtitle: 'A planned feature, not active yet',
                onTap: () => context.go('/assistant'),
              ),
              const SizedBox(height: 26),
              const SafetyNote(compact: true),
              const SizedBox(height: 28),
            ]),
          ),
        ),
      ],
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accent = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MindBridgeTheme.paper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
        boxShadow: MindBridgeTheme.neoShadowSmall,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accent ? const Color(0xFFF0E3D9) : const Color(0xFFE8EDE5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
                  ),
                  child: Icon(icon, color: accent ? MindBridgeTheme.clay : MindBridgeTheme.forest, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink)),
                      const SizedBox(height: 3),
                      Text(subtitle, style: const TextStyle(fontSize: 11, color: MindBridgeTheme.muted, height: 1.3)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_rounded, size: 18, color: MindBridgeTheme.clay),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
