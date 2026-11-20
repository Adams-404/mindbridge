import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { english, hausa }

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.english);

final isHausaSelectedProvider = Provider<bool>(
  (ref) => ref.watch(languageProvider) == AppLanguage.hausa,
);

final moodSelectionProvider = StateProvider<String?>((ref) => null);

class FollowUpReminder {
  const FollowUpReminder({required this.title, required this.date});
  final String title;
  final DateTime date;
}

final remindersProvider = StateProvider<List<FollowUpReminder>>((ref) => []);
