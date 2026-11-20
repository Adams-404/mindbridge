import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets.dart';
import '../../core/theme.dart';
import '../../data/learning_content.dart';
import '../../data/learning_repository.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  String _query = '';
  String? _category;

  void _openArticle(BuildContext context, LearningArticle article) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: MindBridgeTheme.paper,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .84,
        maxChildSize: .96,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5D0C5),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 25),
            SectionLabel(article.category),
            const SizedBox(height: 12),
            Semantics(
              header: true,
              child: Text(article.title, style: Theme.of(context).textTheme.headlineMedium),
            ),
            const SizedBox(height: 14),
            Text(article.summary, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 22),
            ...article.sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Text(section, style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
            const SizedBox(height: 8),
            _ArticleMetadata(article: article),
            const SizedBox(height: 18),
            const SafetyNote(compact: true),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final articles = ref.watch(learningRepositoryProvider).getArticles();
    final categories = articles.map((article) => article.category).toSet().toList()..sort();
    final normalizedQuery = _query.trim().toLowerCase();
    final visibleArticles = articles.where((article) {
      final matchesCategory = _category == null || article.category == _category;
      final searchable = '${article.title} ${article.summary} ${article.category}'.toLowerCase();
      return matchesCategory && searchable.contains(normalizedQuery);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 30),
      children: [
        const PageHeading(
          eyebrow: 'LEARN AND UNDERSTAND',
          title: 'A little clarity\ncan go a long way.',
          subtitle: 'Explore introductory information at your own pace. These prototype articles need qualified clinical review before publication.',
        ),
        const SizedBox(height: 22),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search topics',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: MindBridgeTheme.paper,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ChoiceChip(
              label: const Text('All topics'),
              selected: _category == null,
              onSelected: (_) => setState(() => _category = null),
            ),
            ...categories.map((category) => ChoiceChip(
              label: Text(category),
              selected: _category == category,
              onSelected: (_) => setState(() => _category = category),
            )),
          ],
        ),
        const SizedBox(height: 18),
        Semantics(
          liveRegion: true,
          child: Text(
            '${visibleArticles.length} ${visibleArticles.length == 1 ? 'article' : 'articles'}',
            style: const TextStyle(fontSize: 11, color: MindBridgeTheme.muted),
          ),
        ),
        const SizedBox(height: 10),
        if (visibleArticles.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.search_off, color: MindBridgeTheme.muted),
                  const SizedBox(height: 10),
                  Text('No matching topics', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 5),
                  const Text('Try another search or clear the selected category.'),
                  TextButton(
                    onPressed: () => setState(() {
                      _query = '';
                      _category = null;
                    }),
                    child: const Text('Clear filters'),
                  ),
                ],
              ),
            ),
          )
        else
          ...visibleArticles.map((article) => Padding(
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
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EDE5),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: const Icon(Icons.article_outlined, color: MindBridgeTheme.forest),
                      ),
                      const SizedBox(width: 13),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.category.toUpperCase(),
                            style: const TextStyle(fontSize: 9, letterSpacing: .8, color: MindBridgeTheme.forest, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 5),
                          Text(article.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(article.summary, style: const TextStyle(fontSize: 11, height: 1.4, color: MindBridgeTheme.muted)),
                        ],
                      )),
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

class _ArticleMetadata extends StatelessWidget {
  const _ArticleMetadata({required this.article});

  final LearningArticle article;

  @override
  Widget build(BuildContext context) {
    final reviewedDate = article.reviewDate == null
        ? 'Pending'
        : MaterialLocalizations.of(context).formatMediumDate(article.reviewDate!);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E8DE),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE1D1C4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('CONTENT RECORD'),
          const SizedBox(height: 9),
          _MetadataLine(label: 'Review status', value: article.reviewStatus),
          _MetadataLine(label: 'Source', value: article.source ?? 'Pending verification'),
          _MetadataLine(label: 'Clinical reviewer', value: article.reviewer ?? 'Not assigned'),
          _MetadataLine(label: 'Last reviewed', value: reviewedDate),
          _MetadataLine(label: 'Content version', value: article.contentVersion),
        ],
      ),
    );
  }
}

class _MetadataLine extends StatelessWidget {
  const _MetadataLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 7),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 112,
          child: Text(label, style: const TextStyle(fontSize: 10, color: MindBridgeTheme.muted)),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
      ],
    ),
  );
}
