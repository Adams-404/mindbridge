import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage { english, hausa }

final languageProvider = StateProvider<AppLanguage>((ref) => AppLanguage.english);

final isHausaSelectedProvider = Provider<bool>(
  (ref) => ref.watch(languageProvider) == AppLanguage.hausa,
);

final moodSelectionProvider = StateProvider<String?>((ref) => null);
