import 'package:material_ui/material_ui.dart';

import '../../core/theme.dart';
import '../../core/widgets.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'MINDBRIDGE INFORMATION ASSISTANT',
          title: 'Questions are\na good place to start.',
          subtitle: 'A future assistant may help explain general mental-health information in simpler language.',
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: MindBridgeTheme.paper,
            border: Border.all(color: const Color(0xFFD9D4C8)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.chat_bubble_outline, size: 28, color: MindBridgeTheme.forest),
              const SizedBox(height: 15),
              Text('This feature is not active yet.', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'We are keeping the assistant out of this prototype until its sources, safety boundaries, Hausa quality, and professional review process are ready.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 17),
              const Chip(
                label: Text('Planned · not connected to AI'),
                side: BorderSide.none,
                backgroundColor: Color(0xFFE8EDE5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SafetyNote(),
        const SizedBox(height: 12),
        const Text(
          'When developed, it will provide general education only. It will not diagnose conditions, prescribe medication, or replace qualified healthcare professionals.',
          style: TextStyle(fontSize: 11, height: 1.6, color: MindBridgeTheme.muted),
        ),
      ],
    );
  }
}
