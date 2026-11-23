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
    final themeMode = ref.watch(themeModeProvider);
    final isHausa = language == AppLanguage.hausa;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
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
          color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: MindBridgeTheme.borderWidth,
              ),
              boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
            ),
            child: RadioGroup<AppLanguage>(
              groupValue: language,
              onChanged: (value) {
                if (value != null) {
                  HapticFeedback.selectionClick();
                  ref.read(languageProvider.notifier).setLanguage(value);
                }
              },
              child: Column(
                children: [
                  RadioListTile<AppLanguage>(
                    value: AppLanguage.english,
                    title: const Text('English', style: TextStyle(fontWeight: FontWeight.w700)),
                    activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                  ),
                  Divider(height: 1, color: isDark ? MindBridgeTheme.darkLine : MindBridgeTheme.ink),
                  RadioListTile<AppLanguage>(
                    value: AppLanguage.hausa,
                    title: const Text('Hausa', style: TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: const Text('Translation review in progress · Fassarar na kan bita', style: TextStyle(fontSize: 11)),
                    activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
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
            color: isDark ? const Color(0xFF28201A) : const Color(0xFFF0E3D9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? MindBridgeTheme.clay : MindBridgeTheme.ink,
              width: MindBridgeTheme.borderWidth,
            ),
            boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.verified_user_outlined, size: 18, color: isDark ? MindBridgeTheme.clay : MindBridgeTheme.forest),
                  const SizedBox(width: 8),
                  Text(
                    'Translation Review Status',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.reviewDisclaimerEn,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.5,
                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                ),
              ),
              if (language == AppLanguage.hausa) ...[
                const SizedBox(height: 8),
                Text(
                  AppStrings.reviewDisclaimerHa,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                    color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 28),
        Divider(color: isDark ? MindBridgeTheme.darkLine : MindBridgeTheme.ink, thickness: 1.5),
        const SizedBox(height: 16),
        Text(isHausa ? 'Yanayin Launi' : 'Appearance & Theme', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          isHausa
              ? 'Zabi tsakanin baki mai tsarki (#000000), haske na asali, ko bin tsarin waya.'
              : 'Switch between pure black dark mode, warm light mode, or follow your system setting.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        Material(
          color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: MindBridgeTheme.borderWidth,
              ),
              boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
            ),
            child: RadioGroup<ThemeMode>(
              groupValue: themeMode,
              onChanged: (value) {
                if (value != null) {
                  HapticFeedback.selectionClick();
                  ref.read(themeModeProvider.notifier).setThemeMode(value);
                }
              },
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    title: Text(isHausa ? 'Tsarin Waya (System)' : 'System', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(isHausa ? 'Biyo tsarin da wayarka ke amfani da shi' : 'Automatically match your device theme', style: const TextStyle(fontSize: 11)),
                    activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                  ),
                  Divider(height: 1, color: isDark ? MindBridgeTheme.darkLine : MindBridgeTheme.ink),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    title: Text(isHausa ? 'Haske (Light)' : 'Light', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(isHausa ? 'Launin takarda da madara mai dumi' : 'Default warm paper & milk theme', style: const TextStyle(fontSize: 11)),
                    activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                  ),
                  Divider(height: 1, color: isDark ? MindBridgeTheme.darkLine : MindBridgeTheme.ink),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    title: Text(isHausa ? 'Baki Mai Tsarki (Dark)' : 'Dark (Pure Black)', style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(isHausa ? 'Baki na zahiri (#000000) tare da fari' : 'Pure OLED black (#000000) with milk accents', style: const TextStyle(fontSize: 11)),
                    activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),
        Divider(color: isDark ? MindBridgeTheme.darkLine : MindBridgeTheme.ink, thickness: 1.5),
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
            width: 1.4,
          ),
          boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF262626) : const Color(0xFFE8EDE5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                  width: 1.2,
                ),
              ),
              child: Icon(icon, color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest, size: 20),
            ),
            const SizedBox(width: 13),
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
