import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
import '../../core/theme.dart';
import '../../data/learning_content.dart';
import '../../data/learning_repository.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  void _openArticle(BuildContext context, LearningArticle article) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: MindBridgeTheme.paper,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .82,
        maxChildSize: .95,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
          children: [
            Center(child: Container(width: 38, height: 4, decoration: BoxDecoration(color: const Color(0xFFD5D0C5), borderRadius: BorderRadius.circular(5)))),
            const SizedBox(height: 25),
            SectionLabel(article.category),
            const SizedBox(height: 12),
            Text(article.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 14),
            Text(article.summary, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 22),
            ...article.sections.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Text(entry.value, style: Theme.of(context).textTheme.bodyLarge),
            )),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFF1E8DE), borderRadius: BorderRadius.circular(8)),
              child: Text(article.reviewStatus, style: const TextStyle(fontSize: 11, color: MindBridgeTheme.ink)),
            ),
            const SizedBox(height: 18),
            const SafetyNote(compact: true),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = ref.watch(learningRepositoryProvider).getArticles();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'LEARN AND UNDERSTAND',
          title: 'A little clarity\ncan go a long way.',
          subtitle: 'Explore introductory information at your own pace. These prototype articles need qualified clinical review before publication.',
        ),
        const SizedBox(height: 27),
        ...articles.map((article) => Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: Card(
            child: InkWell(
              onTap: () => _openArticle(context, article),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(color: const Color(0xFFE8EDE5), borderRadius: BorderRadius.circular(9)),
                      child: const Icon(Icons.article_outlined, color: MindBridgeTheme.forest),
                    ),
                    const SizedBox(width: 13),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(article.category.toUpperCase(), style: const TextStyle(fontSize: 9, letterSpacing: .8, color: MindBridgeTheme.forest, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 5),
                      Text(article.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Text(article.summary, style: const TextStyle(fontSize: 11, height: 1.4, color: MindBridgeTheme.muted)),
                    ])),
                    const Icon(Icons.arrow_forward, size: 17, color: MindBridgeTheme.clay),
                  ],
                ),
              ),
            ),
          ),
        )),
        const SizedBox(height: 8),
        const SafetyNote(compact: true),
      ],
    );
  }
}
