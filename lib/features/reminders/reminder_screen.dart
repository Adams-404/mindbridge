import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    HapticFeedback.selectionClick();
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
    HapticFeedback.mediumImpact();
    ref.read(remindersProvider.notifier).addReminder(
      FollowUpReminder(title: title, date: _date),
    );
    _controller.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Follow-up added for this session.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = ref.watch(remindersProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
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
          decoration: InputDecoration(
            labelText: 'What would you like to remember?',
            hintText: 'e.g. Call the clinic',
            filled: true,
            fillColor: MindBridgeTheme.paper,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MindBridgeTheme.forest, width: 2.2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
            ),
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
        const SizedBox(height: 30),
        Text('Your reminders', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        if (reminders.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: MindBridgeTheme.paper,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
              boxShadow: MindBridgeTheme.neoShadowSmall,
            ),
            child: const Text(
              'Nothing here yet. Add a reminder above if there is something you would like to return to.',
              style: TextStyle(fontSize: 12, height: 1.6, color: MindBridgeTheme.muted),
            ),
          )
        else
          ...reminders.asMap().entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Container(
              decoration: BoxDecoration(
                color: MindBridgeTheme.paper,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
                boxShadow: MindBridgeTheme.neoShadowSmall,
              ),
              child: ListTile(
                title: Text(entry.value.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink)),
                subtitle: Text(
                  MaterialLocalizations.of(context).formatMediumDate(entry.value.date),
                  style: const TextStyle(fontSize: 12, color: MindBridgeTheme.muted),
                ),
                trailing: IconButton(
                  tooltip: 'Delete reminder',
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(remindersProvider.notifier).removeReminder(entry.key);
                  },
                  icon: const Icon(Icons.delete_outline_rounded, color: MindBridgeTheme.clay),
                ),
              ),
            ),
          )),
        const SizedBox(height: 20),
        const SafetyNote(compact: true),
        const SizedBox(height: 12),
        const Text(
          'These reminders are held in memory only. They do not create phone notifications, sync to a provider, or indicate that anyone is monitoring your care. Closing the app clears them.',
          style: TextStyle(fontSize: 10, height: 1.5, color: MindBridgeTheme.muted),
        ),
      ],
    );
  }
}
