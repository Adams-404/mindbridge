import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: MindBridgeTheme.paper,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .84,
        maxChildSize: .96,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 34),
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: MindBridgeTheme.ink,
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
            const SizedBox(height: 10),
            _ArticleMetadata(article: article),
            const SizedBox(height: 20),
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
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
      children: [
        const PageHeading(
          eyebrow: 'LEARN AND UNDERSTAND',
          title: 'A little clarity\ncan go a long way.',
          subtitle: 'Explore structured, evidence-based mental health resources at your own pace.',
        ),
        const SizedBox(height: 22),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search topics',
            prefixIcon: const Icon(Icons.search, color: MindBridgeTheme.ink),
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
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _TopicChip(
              label: 'All topics',
              selected: _category == null,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                setState(() => _category = null);
              },
            ),
            ...categories.map((category) => _TopicChip(
              label: category,
              selected: _category == category,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                setState(() => _category = category);
              },
            )),
          ],
        ),
        const SizedBox(height: 18),
        Semantics(
          liveRegion: true,
          child: Text(
            '${visibleArticles.length} ${visibleArticles.length == 1 ? 'article' : 'articles'}',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: MindBridgeTheme.muted),
          ),
        ),
        const SizedBox(height: 12),
        if (visibleArticles.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: MindBridgeTheme.paper,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
              boxShadow: MindBridgeTheme.neoShadowSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.search_off_rounded, color: MindBridgeTheme.muted, size: 28),
                const SizedBox(height: 10),
                Text('No matching topics', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                const Text('Try another search or clear the selected category.'),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _query = '';
                      _category = null;
                    });
                  },
                  child: const Text('Clear filters'),
                ),
              ],
            ),
          )
        else
          ...visibleArticles.map((article) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
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
                  onTap: () => _openArticle(context, article),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EDE5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
                          ),
                          child: const Icon(Icons.article_outlined, color: MindBridgeTheme.forest, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  letterSpacing: .9,
                                  color: MindBridgeTheme.forest,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(article.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink)),
                              const SizedBox(height: 4),
                              Text(article.summary, style: const TextStyle(fontSize: 11, height: 1.4, color: MindBridgeTheme.muted)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, size: 18, color: MindBridgeTheme.clay),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
        const SizedBox(height: 12),
        const SafetyNote(compact: true),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: selected ? MindBridgeTheme.paper : MindBridgeTheme.ink,
        ),
      ),
      selected: selected,
      selectedColor: MindBridgeTheme.forest,
      backgroundColor: MindBridgeTheme.paper,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: MindBridgeTheme.ink, width: 1.6),
      ),
      showCheckmark: false,
      onSelected: onSelected,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1E8DE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
        boxShadow: MindBridgeTheme.neoShadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel('CONTENT RECORD'),
          const SizedBox(height: 10),
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
          width: 114,
          child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MindBridgeTheme.muted)),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MindBridgeTheme.ink)),
        ),
      ],
    ),
  );
}
