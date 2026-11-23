import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../core/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      children: [
        PageHeading(
          eyebrow: AppStrings.settingsEyebrow(language),
          title: AppStrings.settingsTitle(language),
          subtitle: 'A few ways to make MindBridge feel more comfortable to use.',
        ),
        const SizedBox(height: 27),
        Text(AppStrings.settingsLanguageTitle(language), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          AppStrings.settingsLanguageSubtitle(language),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        Material(
          color: MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
              boxShadow: MindBridgeTheme.neoShadowSmall,
            ),
            child: RadioGroup<AppLanguage>(
              groupValue: language,
              onChanged: (value) {
                if (value != null) {
                  HapticFeedback.selectionClick();
                  ref.read(languageProvider.notifier).setLanguage(value);
                }
              },
              child: const Column(
                children: [
                  RadioListTile<AppLanguage>(
                    value: AppLanguage.english,
                    title: Text('English', style: TextStyle(fontWeight: FontWeight.w700)),
                    activeColor: MindBridgeTheme.forest,
                  ),
                  Divider(height: 1, color: MindBridgeTheme.ink),
                  RadioListTile<AppLanguage>(
                    value: AppLanguage.hausa,
                    title: Text('Hausa', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('Translation review in progress · Fassarar na kan bita', style: TextStyle(fontSize: 11)),
                    activeColor: MindBridgeTheme.forest,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E3D9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
            boxShadow: MindBridgeTheme.neoShadowSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.verified_user_outlined, size: 18, color: MindBridgeTheme.forest),
                  SizedBox(width: 8),
                  Text(
                    'Translation Review Status',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.reviewDisclaimerEn,
                style: TextStyle(fontSize: 11, height: 1.5, color: MindBridgeTheme.ink),
              ),
              if (language == AppLanguage.hausa) ...[
                const SizedBox(height: 8),
                const Text(
                  AppStrings.reviewDisclaimerHa,
                  style: TextStyle(fontSize: 11, height: 1.5, fontStyle: FontStyle.italic, color: MindBridgeTheme.ink),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 28),
        const Divider(color: MindBridgeTheme.ink, thickness: 1.5),
        const SizedBox(height: 16),
        Text(AppStrings.settingsPrivacyTitle(language), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        const _InfoTile(icon: Icons.lock_outline, title: 'No account needed', subtitle: 'MindBridge works privately on your device without requiring sign in.'),
        const _InfoTile(icon: Icons.visibility_off_outlined, title: 'Check-ins are not saved', subtitle: 'Your selection stays on the check-in screen only.'),
        const _InfoTile(icon: Icons.health_and_safety_outlined, title: 'Not a medical service', subtitle: 'MindBridge does not diagnose or replace professional care.'),
        const SizedBox(height: 22),
        SafetyNote(compact: true, text: AppStrings.safetyNoteText(language)),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.title, required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: MindBridgeTheme.paper,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
        boxShadow: MindBridgeTheme.neoShadowSmall,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDE5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: MindBridgeTheme.ink, width: 1.2),
            ),
            child: Icon(icon, color: MindBridgeTheme.forest, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, height: 1.4, color: MindBridgeTheme.muted)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
