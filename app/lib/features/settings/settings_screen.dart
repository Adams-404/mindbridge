import 'package:material_ui/material_ui.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'MAKE IT YOURS',
          title: 'Settings.',
          subtitle: 'A few ways to make MindBridge feel more comfortable to use.',
        ),
        const SizedBox(height: 27),
        Text('Language', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 5),
        Text('Choose a language. Your selection lasts only while the app is open in this prototype.', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        RadioListTile<AppLanguage>(
          value: AppLanguage.english,
          groupValue: language,
          onChanged: (value) => ref.read(languageProvider.notifier).state = value!,
          title: const Text('English'),
          contentPadding: EdgeInsets.zero,
          activeColor: MindBridgeTheme.forest,
        ),
        RadioListTile<AppLanguage>(
          value: AppLanguage.hausa,
          groupValue: language,
          onChanged: (value) => ref.read(languageProvider.notifier).state = value!,
          title: const Text('Hausa'),
          subtitle: const Text('Translation review in progress'),
          contentPadding: EdgeInsets.zero,
          activeColor: MindBridgeTheme.forest,
        ),
        if (language == AppLanguage.hausa)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF0E3D9), borderRadius: BorderRadius.circular(8)),
            child: const Text(
              'Hausa content is being reviewed with language and mental-health contributors. Some prototype interface text may still appear in English.',
              style: TextStyle(fontSize: 11, height: 1.5),
            ),
          ),
        const SizedBox(height: 28),
        const Divider(color: Color(0xFFD9D4C8)),
        const SizedBox(height: 15),
        Text('Privacy and safety', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const _InfoTile(icon: Icons.lock_outline, title: 'No account needed', subtitle: 'This prototype does not ask you to sign in.'),
        const _InfoTile(icon: Icons.visibility_off_outlined, title: 'Check-ins are not saved', subtitle: 'Your selection stays on the check-in screen only.'),
        const _InfoTile(icon: Icons.health_and_safety_outlined, title: 'Not a medical service', subtitle: 'MindBridge does not diagnose or replace professional care.'),
        const SizedBox(height: 20),
        const SafetyNote(compact: true),
        const SizedBox(height: 22),
        Center(child: Text('MindBridge AI · Prototype 0.1.0', style: Theme.of(context).textTheme.bodySmall)),
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
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: MindBridgeTheme.forest),
    title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
    subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, height: 1.4)),
  );
}
