import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_strings.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../core/theme.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              SectionLabel(AppStrings.homeSpaceToBegin(language)),
              const SizedBox(height: 12),
              Text(
                AppStrings.homeGreeting(language),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 36, height: 1.08),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.homeSubtitle(language),
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
                    SectionLabel(AppStrings.homeMomentForYou(language)),
                    const SizedBox(height: 10),
                    Text(
                      AppStrings.homeHowAreThings(language),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24, height: 1.15),
                    ),
                    const SizedBox(height: 6),
                    Text(AppStrings.homeNoRightAnswer(language), style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          context.go('/check-in');
                        },
                        child: Text(AppStrings.homeCheckInButton(language)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(AppStrings.homePlaceToBegin(language), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 14),
              _HomeAction(
                icon: Icons.menu_book_outlined,
                title: AppStrings.homeActionLearnTitle(language),
                subtitle: AppStrings.homeActionLearnSubtitle(language),
                onTap: () => context.go('/learn'),
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.air_rounded,
                title: AppStrings.homeActionBreathingTitle(language),
                subtitle: AppStrings.homeActionBreathingSubtitle(language),
                onTap: () => context.go('/reset'),
                accent: true,
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.favorite_border,
                title: AppStrings.homeActionSupportTitle(language),
                subtitle: AppStrings.homeActionSupportSubtitle(language),
                onTap: () => context.go('/support'),
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.event_note_outlined,
                title: AppStrings.homeActionRemindersTitle(language),
                subtitle: AppStrings.homeActionRemindersSubtitle(language),
                onTap: () => context.go('/reminders'),
                accent: true,
              ),
              const SizedBox(height: 12),
              _HomeAction(
                icon: Icons.chat_bubble_outline,
                title: AppStrings.homeActionAssistantTitle(language),
                subtitle: AppStrings.homeActionAssistantSubtitle(language),
                onTap: () => context.go('/assistant'),
              ),
              const SizedBox(height: 26),
              SafetyNote(compact: true, text: AppStrings.safetyNoteText(language)),
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
