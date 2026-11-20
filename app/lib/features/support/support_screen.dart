import 'package:flutter/material.dart';

import '../../core/widgets.dart';
import '../../core/theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'YOU DO NOT HAVE TO FIGURE IT OUT ALONE',
          title: 'Finding the\nright support.',
          subtitle: 'Learning about your options can be a useful first step. A qualified health professional can help you understand what support may be appropriate.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: const Color(0xFFE8EDE5), border: Border.all(color: const Color(0xFFC9D4C7)), borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.people_alt_outlined, size: 27, color: MindBridgeTheme.forest),
            const SizedBox(height: 13),
            Text('Verified support directory', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'We are building a process to verify professionals and services before listing them. There are no verified provider listings available in this prototype yet.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 15),
            const Chip(label: Text('Directory not yet available'), side: BorderSide.none, backgroundColor: Color(0xFFDDE5D9)),
          ]),
        ),
        const SizedBox(height: 24),
        Text('What you can ask a provider', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const _PromptRow(text: 'What qualifications and experience do you have?'),
        const _PromptRow(text: 'What kinds of support do you offer?'),
        const _PromptRow(text: 'What are the costs and available options?'),
        const _PromptRow(text: 'How is my information kept private?'),
        const SizedBox(height: 22),
        const SafetyNote(),
        const SizedBox(height: 12),
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
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.check_circle_outline, size: 17, color: MindBridgeTheme.clay),
      const SizedBox(width: 10),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 13, height: 1.45))),
    ]),
  );
}
