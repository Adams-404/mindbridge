import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../../core/widgets.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      children: [
        const PageHeading(
          eyebrow: 'MINDBRIDGE INFORMATION ASSISTANT',
          title: 'Questions are\na good place to start.',
          subtitle: 'A future assistant may help explain general mental-health information in simpler language.',
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: MindBridgeTheme.paper,
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
                  color: const Color(0xFFE8EDE5),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded, size: 26, color: MindBridgeTheme.forest),
              ),
              const SizedBox(height: 16),
              Text('This feature is not active yet.', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'We are keeping the assistant out of this prototype until its sources, safety boundaries, Hausa quality, and professional review process are ready.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EDE5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MindBridgeTheme.ink, width: 1.2),
                ),
                child: const Text(
                  'Planned · not connected to AI',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MindBridgeTheme.forest),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const SafetyNote(),
        const SizedBox(height: 14),
        const Text(
          'When developed, it will provide general education only. It will not diagnose conditions, prescribe medication, or replace qualified healthcare professionals.',
          style: TextStyle(fontSize: 11, height: 1.6, color: MindBridgeTheme.muted),
        ),
      ],
    );
  }
}
