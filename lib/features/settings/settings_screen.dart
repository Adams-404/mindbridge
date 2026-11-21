import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        const PageHeading(
          eyebrow: 'MAKE IT YOURS',
          title: 'Settings.',
          subtitle: 'A few ways to make MindBridge feel more comfortable to use.',
        ),
        const SizedBox(height: 27),
        Text('Language', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Choose a language. Your selection lasts only while the app is open in this prototype.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: MindBridgeTheme.paper,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
            boxShadow: MindBridgeTheme.neoShadowSmall,
          ),
          child: RadioGroup<AppLanguage>(
            groupValue: language,
            onChanged: (value) {
              if (value != null) {
                HapticFeedback.selectionClick();
                ref.read(languageProvider.notifier).state = value;
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
                  subtitle: Text('Translation review in progress', style: TextStyle(fontSize: 11)),
                  activeColor: MindBridgeTheme.forest,
                ),
              ],
            ),
          ),
        ),
        if (language == AppLanguage.hausa) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E3D9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
              boxShadow: MindBridgeTheme.neoShadowSmall,
            ),
            child: const Text(
              'The app remains in English for now. Hausa interface copy is not ready until language and mental-health contributors complete their review.',
              style: TextStyle(fontSize: 12, height: 1.5, fontWeight: FontWeight.w600, color: MindBridgeTheme.ink),
            ),
          ),
        ],
        const SizedBox(height: 28),
        const Divider(color: MindBridgeTheme.ink, thickness: 1.5),
        const SizedBox(height: 16),
        Text('Privacy and safety', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        const _InfoTile(icon: Icons.lock_outline, title: 'No account needed', subtitle: 'This prototype does not ask you to sign in.'),
        const _InfoTile(icon: Icons.visibility_off_outlined, title: 'Check-ins are not saved', subtitle: 'Your selection stays on the check-in screen only.'),
        const _InfoTile(icon: Icons.health_and_safety_outlined, title: 'Not a medical service', subtitle: 'MindBridge does not diagnose or replace professional care.'),
        const SizedBox(height: 22),
        const SafetyNote(compact: true),
        const SizedBox(height: 22),
        Center(
          child: Text(
            'MindBridge AI · Prototype 0.1.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: MindBridgeTheme.muted, fontWeight: FontWeight.w600),
          ),
        ),
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
