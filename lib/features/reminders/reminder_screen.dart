import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  final _controller = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _chooseDate() async {
    final chosen = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (chosen != null) setState(() => _date = chosen);
  }

  void _addReminder() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    ref.read(remindersProvider.notifier).update((items) => [
      ...items,
      FollowUpReminder(title: title, date: _date),
    ]);
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Follow-up added for this session.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'A NOTE TO YOUR FUTURE SELF',
          title: 'Keep a follow-up\nin sight.',
          subtitle: 'Add a personal reminder for an appointment or a next step you want to come back to.',
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _controller,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'What would you like to remember?',
            hintText: 'e.g. Call the clinic',
            filled: true,
            fillColor: MindBridgeTheme.paper,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _chooseDate,
          icon: const Icon(Icons.calendar_today_outlined),
          label: Text(MaterialLocalizations.of(context).formatMediumDate(_date)),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _addReminder,
          child: const Text('Add reminder'),
        ),
        const SizedBox(height: 28),
        Text('Your reminders', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        if (reminders.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Text('Nothing here yet. Add a reminder above if there is something you would like to return to.', style: TextStyle(fontSize: 12, height: 1.6, color: MindBridgeTheme.muted)),
            ),
          )
        else
          ...reminders.asMap().entries.map((entry) => Card(
            child: ListTile(
              title: Text(entry.value.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: Text(MaterialLocalizations.of(context).formatMediumDate(entry.value.date)),
              trailing: IconButton(
                tooltip: 'Delete reminder',
                onPressed: () => ref.read(remindersProvider.notifier).update((items) => [
                  for (var i = 0; i < items.length; i++)
                    if (i != entry.key) items[i],
                ]),
                icon: const Icon(Icons.delete_outline, color: MindBridgeTheme.clay),
              ),
            ),
          )),
        const SizedBox(height: 18),
        const SafetyNote(compact: true),
        const SizedBox(height: 10),
        const Text(
          'These reminders are held in memory only. They do not create phone notifications, sync to a provider, or indicate that anyone is monitoring your care. Closing the app clears them.',
          style: TextStyle(fontSize: 10, height: 1.5, color: MindBridgeTheme.muted),
        ),
      ],
    );
  }
}
