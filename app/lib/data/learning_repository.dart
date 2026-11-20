import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'learning_content.dart';

abstract interface class LearningRepository {
  List<LearningArticle> getArticles();
}

class BundledLearningRepository implements LearningRepository {
  @override
  List<LearningArticle> getArticles() => learningArticles;
}

final learningRepositoryProvider = Provider<LearningRepository>(
  (ref) => BundledLearningRepository(),
);
