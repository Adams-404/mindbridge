import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: [
                  const Text('mindbridge', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -1)),
                  const Text('.', style: TextStyle(fontSize: 22, color: MindBridgeTheme.clay, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              const SectionLabel('A SPACE TO BEGIN'),
              const SizedBox(height: 13),
              Text('Good to have\nyou here.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 36)),
              const SizedBox(height: 12),
              Text(
                'You can take your time. Explore what feels useful, and leave the rest for another day.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 25),
              Container(
                padding: const EdgeInsets.all(19),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EDE5),
                  border: Border.all(color: const Color(0xFFC8D3C5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('A MOMENT FOR YOU'),
                    const SizedBox(height: 12),
                    Text('How are things\nfeeling today?', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24, height: 1.15)),
                    const SizedBox(height: 6),
                    Text('No right answer. Just yours.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 17),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: () => context.go('/check-in'),
                        child: const Text('Check in, if you like'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text('A place to begin', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 13),
              _HomeAction(
                icon: Icons.menu_book_outlined,
                title: 'Learn and understand',
                subtitle: 'Explore mental health information',
                onTap: () => context.go('/learn'),
              ),
              const SizedBox(height: 10),
              _HomeAction(
                icon: Icons.air_rounded,
                title: 'Take a breathing pause',
                subtitle: 'A few moments at your own pace',
                onTap: () => context.go('/reset'),
                accent: true,
              ),
              const SizedBox(height: 10),
              _HomeAction(
                icon: Icons.favorite_border,
                title: 'Find support',
                subtitle: 'Understand your options for professional care',
                onTap: () => context.go('/support'),
              ),
              const SizedBox(height: 10),
              _HomeAction(
                icon: Icons.event_note_outlined,
                title: 'Keep a follow-up in sight',
                subtitle: 'Make a personal reminder',
                onTap: () => context.go('/reminders'),
                accent: true,
              ),
              const SizedBox(height: 10),
              _HomeAction(
                icon: Icons.chat_bubble_outline,
                title: 'MindBridge information assistant',
                subtitle: 'A planned feature, not active yet',
                onTap: () => context.go('/assistant'),
              ),
              const SizedBox(height: 25),
              const SafetyNote(compact: true),
              const SizedBox(height: 15),
              Center(
                child: Text('A prototype built with care · 0.1.0', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: MindBridgeTheme.muted, fontSize: 10)),
              ),
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
    return Material(
      color: MindBridgeTheme.paper,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFD9D4C8)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent ? const Color(0xFFF0E3D9) : const Color(0xFFE8EDE5),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accent ? MindBridgeTheme.clay : MindBridgeTheme.forest),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: MindBridgeTheme.muted)),
                ]),
              ),
              const Icon(Icons.arrow_forward, size: 17, color: MindBridgeTheme.clay),
            ],
          ),
        ),
      ),
    );
  }
}
