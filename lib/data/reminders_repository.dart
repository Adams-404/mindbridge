import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowUpReminder {
  const FollowUpReminder({required this.title, required this.date});
  final String title;
  final DateTime date;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FollowUpReminder &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          date == other.date;

  @override
  int get hashCode => title.hashCode ^ date.hashCode;
}

abstract interface class RemindersRepository {
  List<FollowUpReminder> getReminders();
  void addReminder(FollowUpReminder reminder);
  void removeReminder(int index);
  void clear();
}

class InMemoryRemindersRepository implements RemindersRepository {
  final List<FollowUpReminder> _items = [];

  @override
  List<FollowUpReminder> getReminders() => List.of(_items);

  @override
  void addReminder(FollowUpReminder reminder) {
    _items.add(reminder);
  }

  @override
  void removeReminder(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  @override
  void clear() {
    _items.clear();
  }
}

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  return InMemoryRemindersRepository();
});
