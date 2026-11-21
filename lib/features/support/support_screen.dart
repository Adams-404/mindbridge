import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../core/theme.dart';
import '../../data/support_repository.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final directoryMetadata = ref.watch(supportDirectoryMetadataProvider).valueOrNull;
    final noticeText = directoryMetadata?.statusMessage ?? AppStrings.supportDirectoryNotice(language);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      children: [
        PageHeading(
          eyebrow: AppStrings.supportEyebrow(language),
          title: AppStrings.supportTitle(language),
          subtitle: 'Learning about your options can be a useful first step. A qualified health professional can help you understand what support may be appropriate.',
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: MindBridgeTheme.paper,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
                ),
                child: const Icon(Icons.people_alt_outlined, size: 26, color: MindBridgeTheme.forest),
              ),
              const SizedBox(height: 14),
              Text(AppStrings.supportDirectoryTitle(language), style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                noticeText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: MindBridgeTheme.paper,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MindBridgeTheme.ink, width: 1.2),
                ),
                child: const Text(
                  'Directory not yet available',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MindBridgeTheme.forest),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text('What you can ask a provider', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        const _PromptRow(text: 'What qualifications and experience do you have?'),
        const _PromptRow(text: 'What kinds of support do you offer?'),
        const _PromptRow(text: 'What are the costs and available options?'),
        const _PromptRow(text: 'How is my information kept private?'),
        const SizedBox(height: 24),
        SafetyNote(text: AppStrings.safetyNoteText(language)),
        const SizedBox(height: 14),
        const Text(
          'If you or someone else may be in immediate danger, seek urgent in-person help from local emergency services or a trusted person. MindBridge is not monitored and cannot dispatch assistance. Local contact details will only be added after they are verified.',
          style: TextStyle(fontSize: 11, height: 1.6, color: MindBridgeTheme.muted),
        ),
      ],
    );
  }
}

class _PromptRow extends StatelessWidget {
  const _PromptRow({required this.text});
  final String text;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline_rounded, size: 18, color: MindBridgeTheme.clay),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45, fontWeight: FontWeight.w600, color: MindBridgeTheme.ink)),
          ),
        ],
      ),
    ),
  );
}
