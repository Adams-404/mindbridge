import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/widgets.dart';
import '../../core/theme.dart';

class CheckInScreen extends ConsumerWidget {
  const CheckInScreen({super.key});

  static const moods = [
    ('Bright', '☀', 'A little lighter'),
    ('Calm', '◒', 'Steady for now'),
    ('Worried', '⌁', 'A lot on my mind'),
    ('Sad', '○', 'Things feel heavy'),
    ('Anxious', '〰', 'Feeling unsettled'),
    ('Overwhelmed', '⋯', 'More than I can hold'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(moodSelectionProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'A MOMENT FOR YOU',
          title: 'How are you\nfeeling today?',
          subtitle: 'There is no right answer. Choose what feels closest, or leave this for another time.',
        ),
        const SizedBox(height: 25),
        if (selected == null) ...[
          ...moods.map((mood) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Material(
              color: MindBridgeTheme.paper,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => ref.read(moodSelectionProvider.notifier).state = mood.$1,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD9D4C8)), borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Text(mood.$2, style: const TextStyle(fontSize: 23, color: MindBridgeTheme.clay)),
                    const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(mood.$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      Text(mood.$3, style: const TextStyle(fontSize: 11, color: MindBridgeTheme.muted)),
                    ])),
                    const Icon(Icons.chevron_right, color: MindBridgeTheme.muted),
                  ]),
                ),
              ),
            ),
          )),
          TextButton(
            onPressed: () => ref.read(moodSelectionProvider.notifier).state = 'Skipped',
            child: const Text('Skip this check-in'),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(color: const Color(0xFFE8EDE5), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFC9D4C7))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.spa_outlined, size: 30, color: MindBridgeTheme.forest),
              const SizedBox(height: 17),
              Text(selected == 'Skipped' ? 'That’s completely okay.' : 'Thank you for pausing.', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(selected == 'Skipped'
                  ? 'You do not have to check in to use MindBridge.'
                  : 'You chose: $selected. This reflection is not a diagnosis or a measure of your mental health.',
                style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () => ref.read(moodSelectionProvider.notifier).state = null,
                child: const Text('Back to choices'),
              ),
            ]),
          ),
        ],
        const SizedBox(height: 20),
        const SafetyNote(compact: true),
        const SizedBox(height: 10),
        const Text('Your choice is kept in memory while the app is open. It is not written to storage or sent anywhere.', style: TextStyle(fontSize: 10, color: MindBridgeTheme.muted, height: 1.5)),
      ],
    );
  }
}
