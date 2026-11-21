import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      children: [
        const PageHeading(
          eyebrow: 'A MOMENT FOR YOU',
          title: 'How are you\nfeeling today?',
          subtitle: 'There is no right answer. Choose what feels closest, or leave this for another time.',
        ),
        const SizedBox(height: 25),
        if (selected == null) ...[
          ...moods.map((mood) => Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Container(
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
                    HapticFeedback.selectionClick();
                    ref.read(moodSelectionProvider.notifier).state = mood.$1;
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0E3D9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
                          ),
                          child: Text(
                            mood.$2,
                            style: const TextStyle(fontSize: 20, color: MindBridgeTheme.clay, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mood.$1, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink)),
                              const SizedBox(height: 2),
                              Text(mood.$3, style: const TextStyle(fontSize: 12, color: MindBridgeTheme.muted)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: MindBridgeTheme.ink),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(moodSelectionProvider.notifier).state = 'Skipped';
              },
              child: const Text('Skip this check-in', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EDE5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
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
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MindBridgeTheme.ink, width: 1.6),
                  ),
                  child: const Icon(Icons.spa_outlined, size: 28, color: MindBridgeTheme.forest),
                ),
                const SizedBox(height: 18),
                Text(
                  selected == 'Skipped' ? 'That’s completely okay.' : 'Thank you for pausing.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  selected == 'Skipped'
                      ? 'You do not have to check in to use MindBridge.'
                      : 'You chose: $selected. This reflection is not a diagnosis or a measure of your mental health.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(moodSelectionProvider.notifier).state = null;
                  },
                  child: const Text('Back to choices'),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        const SafetyNote(compact: true),
        const SizedBox(height: 12),
        const Text(
          'Your choice is kept in memory while the app is open. It is not written to storage or sent anywhere.',
          style: TextStyle(fontSize: 10, color: MindBridgeTheme.muted, height: 1.5),
        ),
      ],
    );
  }
}
