import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme.dart';
import '../../core/widgets.dart';
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
  bool _showOnlyOffline = false;
  bool _showCertificatesOnly = false;

  void _openArticle(BuildContext context, LearningArticle article) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF141414)
          : MindBridgeTheme.paper,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? MindBridgeTheme.paper
              : MindBridgeTheme.ink,
          width: MindBridgeTheme.borderWidth,
        ),
      ),
      builder: (context) => _CourseDetailSheet(article: article),
    );
  }

  void _openCertificatesModal(BuildContext context) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF141414)
          : MindBridgeTheme.paper,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? MindBridgeTheme.paper
              : MindBridgeTheme.ink,
          width: MindBridgeTheme.borderWidth,
        ),
      ),
      builder: (context) => const _CertificatesListSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF141414) : MindBridgeTheme.paper;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final textColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;

    final articles = ref.watch(learningRepositoryProvider).getArticles();
    final downloadedIds = ref.watch(downloadedCoursesProvider);
    final certificates = ref.watch(courseCertificatesProvider);

    final categories = articles.map((article) => article.category).toSet().toList()..sort();
    final normalizedQuery = _query.trim().toLowerCase();

    final visibleArticles = articles.where((article) {
      if (_showOnlyOffline && !downloadedIds.contains(article.id)) {
        return false;
      }
      final matchesCategory = _category == null || article.category == _category;
      final searchable =
          '${article.title} ${article.summary} ${article.category} ${article.lessons.map((l) => l.title).join(" ")}'
              .toLowerCase();
      return matchesCategory && searchable.contains(normalizedQuery);
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 100),
      children: [
        const PageHeading(
          eyebrow: 'LEARN AND UNDERSTAND',
          title: 'A little clarity\ncan go a long way.',
          subtitle: 'Explore accredited, evidence-based mental health courses with quizzes & certificates.',
        ),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          textInputAction: TextInputAction.search,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: 'Search topics',
            hintStyle: TextStyle(
              color: isDark ? const Color(0xFF888888) : MindBridgeTheme.muted,
            ),
            prefixIcon: Icon(Icons.search, color: textColor),
            filled: true,
            fillColor: cardBg,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: MindBridgeTheme.forest, width: 2.2),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
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
              selected: _category == null && !_showOnlyOffline && !_showCertificatesOnly,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                setState(() {
                  _category = null;
                  _showOnlyOffline = false;
                  _showCertificatesOnly = false;
                });
              },
            ),
            ...categories.map((category) => _TopicChip(
              label: category,
              selected: _category == category && !_showOnlyOffline,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                setState(() {
                  _category = category;
                  _showOnlyOffline = false;
                  _showCertificatesOnly = false;
                });
              },
            )),
            _TopicChip(
              label: '💾 Offline (${downloadedIds.length})',
              selected: _showOnlyOffline,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                setState(() {
                  _showOnlyOffline = !_showOnlyOffline;
                  _showCertificatesOnly = false;
                });
              },
            ),
            _TopicChip(
              label: '🏆 Certificates (${certificates.length})',
              selected: _showCertificatesOnly,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                _openCertificatesModal(context);
              },
            ),
          ],
        ),
        const SizedBox(height: 18),
        Semantics(
          liveRegion: true,
          child: Text(
            '${visibleArticles.length} ${visibleArticles.length == 1 ? 'article' : 'articles'}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (visibleArticles.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
              boxShadow: MindBridgeTheme.neoShadowSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.search_off_rounded, color: isDark ? const Color(0xFF888888) : MindBridgeTheme.muted, size: 28),
                const SizedBox(height: 10),
                Text('No matching topics', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 5),
                Text(
                  _showOnlyOffline
                      ? 'No courses are downloaded yet. Tap the download icon on any course to save it for offline use.'
                      : 'Try another search or clear the selected category.',
                  style: TextStyle(color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _query = '';
                      _category = null;
                      _showOnlyOffline = false;
                    });
                  },
                  child: const Text('Clear filters'),
                ),
              ],
            ),
          )
        else
          ...visibleArticles.map((article) {
            final isDownloaded = downloadedIds.contains(article.id);
            final hasCertificate = certificates.containsKey(article.id);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF222B22) : const Color(0xFFE8EDE5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: borderColor, width: 1.4),
                                ),
                                child: const Icon(Icons.school_outlined, color: MindBridgeTheme.forest, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
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
                                        const Spacer(),
                                        Text(
                                          '⏱ ${article.estimatedMinutes} min',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      article.title,
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            article.summary,
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: isDark ? const Color(0xFFCCCCCC) : MindBridgeTheme.muted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if (hasCertificate)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F4EA),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: MindBridgeTheme.forest, width: 1.2),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.workspace_premium, size: 13, color: MindBridgeTheme.forest),
                                      SizedBox(width: 4),
                                      Text(
                                        'CERTIFIED',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: MindBridgeTheme.forest,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else if (article.quiz != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF202020) : const Color(0xFFF1E8DE),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: borderColor, width: 1.2),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.quiz_outlined, size: 12, color: textColor),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Quiz ready',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              const Spacer(),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                tooltip: isDownloaded ? 'Downloaded for offline' : 'Download course offline',
                                icon: Icon(
                                  isDownloaded ? Icons.download_done_rounded : Icons.download_outlined,
                                  size: 19,
                                  color: isDownloaded ? MindBridgeTheme.forest : MindBridgeTheme.clay,
                                ),
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  ref.read(downloadedCoursesProvider.notifier).toggle(article.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 2),
                                      content: Text(
                                        isDownloaded
                                            ? 'Removed "${article.title}" from offline storage'
                                            : 'Downloaded "${article.title}" for offline use without internet',
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_rounded, size: 18, color: MindBridgeTheme.clay),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final unselectedBg = isDark ? const Color(0xFF141414) : MindBridgeTheme.paper;
    final unselectedText = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: selected ? MindBridgeTheme.paper : unselectedText,
        ),
      ),
      selected: selected,
      selectedColor: MindBridgeTheme.forest,
      backgroundColor: unselectedBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor, width: 1.6),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final bgColor = isDark ? const Color(0xFF1B1B1B) : const Color(0xFFF1E8DE);

    final reviewedDate = article.reviewDate == null
        ? 'Pending'
        : MaterialLocalizations.of(context).formatMediumDate(article.reviewDate!);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted;
    final valColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;

    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 114,
            child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: labelColor)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: valColor)),
          ),
        ],
      ),
    );
  }
}

class _CourseDetailSheet extends ConsumerStatefulWidget {
  const _CourseDetailSheet({required this.article});

  final LearningArticle article;

  @override
  ConsumerState<_CourseDetailSheet> createState() => _CourseDetailSheetState();
}

class _CourseDetailSheetState extends ConsumerState<_CourseDetailSheet> {
  int _activeLessonIndex = 0;

  void _openQuiz(BuildContext context) {
    if (widget.article.quiz == null) return;
    HapticFeedback.lightImpact();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _CourseQuizDialog(article: widget.article),
    );
  }

  void _viewCertificate(BuildContext context, CourseCertificate certificate) {
    HapticFeedback.lightImpact();
    showDialog<void>(
      context: context,
      builder: (context) => _CertificateCardDialog(certificate: certificate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final textColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final cardBg = isDark ? const Color(0xFF181818) : MindBridgeTheme.paper;

    final downloadedIds = ref.watch(downloadedCoursesProvider);
    final isDownloaded = downloadedIds.contains(widget.article.id);
    final certificates = ref.watch(courseCertificatesProvider);
    final certificate = certificates[widget.article.id];
    final attemptsMap = ref.watch(courseAttemptsProvider);
    final attempts = attemptsMap[widget.article.id] ?? [];

    final hasQuiz = widget.article.quiz != null;
    final maxAttempts = widget.article.quiz?.maxAttempts ?? 3;
    final attemptsRemaining = (maxAttempts - attempts.length).clamp(0, maxAttempts);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .86,
      maxChildSize: .96,
      builder: (context, controller) => ListView(
        key: const Key('course_detail_list_view'),
        controller: controller,
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 40),
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SectionLabel(widget.article.category),
              const Spacer(),
              Text(
                '⏱ ${widget.article.estimatedMinutes} min course',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Semantics(
            header: true,
            child: Text(
              widget.article.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Text(widget.article.summary, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          // Offline download action button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(downloadedCoursesProvider.notifier).toggle(widget.article.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isDownloaded
                              ? 'Removed course from offline storage'
                              : 'Saved offline! You can access this without internet.',
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    isDownloaded ? Icons.download_done_rounded : Icons.download_outlined,
                    color: isDownloaded ? MindBridgeTheme.forest : textColor,
                    size: 18,
                  ),
                  label: Text(
                    isDownloaded ? 'Downloaded for Offline' : 'Download for Offline Use',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isDownloaded ? MindBridgeTheme.forest : textColor,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDownloaded ? MindBridgeTheme.forest : borderColor,
                      width: MindBridgeTheme.borderWidth,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Sections from original article for compatibility
          ...widget.article.sections.map(
            (section) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(section, style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
          const SizedBox(height: 10),
          _ArticleMetadata(article: widget.article),
          const SizedBox(height: 24),
          // Structured Modular Lessons
          if (widget.article.lessons.isNotEmpty) ...[
            Text(
              'COURSE LESSONS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.1,
                color: isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.article.lessons.length, (index) {
                  final isSelected = _activeLessonIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text('Lesson ${index + 1}'),
                      selected: isSelected,
                      selectedColor: MindBridgeTheme.forest,
                      backgroundColor: isDark ? const Color(0xFF222222) : MindBridgeTheme.paper,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: isSelected ? MindBridgeTheme.paper : textColor,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: borderColor, width: 1.4),
                      ),
                      onSelected: (_) => setState(() => _activeLessonIndex = index),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
                boxShadow: MindBridgeTheme.neoShadowSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EDE5),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: borderColor, width: 1.2),
                        ),
                        child: Text(
                          'LESSON ${_activeLessonIndex + 1}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: MindBridgeTheme.forest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.article.lessons[_activeLessonIndex].title,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.article.lessons[_activeLessonIndex].content,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: isDark ? const Color(0xFFDDDDDD) : MindBridgeTheme.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E261E) : const Color(0xFFF4F8F3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MindBridgeTheme.forest, width: 1.2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: MindBridgeTheme.forest, size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Key Clinical Takeaways',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: MindBridgeTheme.forest,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...widget.article.lessons[_activeLessonIndex].keyTakeaways.map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontWeight: FontWeight.w900, color: MindBridgeTheme.forest)),
                                Expanded(
                                  child: Text(
                                    t,
                                    style: TextStyle(
                                      fontSize: 11,
                                      height: 1.35,
                                      color: isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          // End-of-Course Assessment (Quiz) & Certificate Card
          if (hasQuiz) ...[
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: certificate != null
                    ? (isDark ? const Color(0xFF1B2E1E) : const Color(0xFFEDF7ED))
                    : cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: certificate != null ? MindBridgeTheme.forest : borderColor,
                  width: MindBridgeTheme.borderWidth,
                ),
                boxShadow: MindBridgeTheme.neoShadowSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        certificate != null ? Icons.verified : Icons.quiz,
                        color: certificate != null ? MindBridgeTheme.forest : MindBridgeTheme.clay,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          certificate != null
                              ? 'Official Certificate Earned'
                              : 'End-of-Course Certification Quiz',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    certificate != null
                        ? 'You passed with ${certificate.finalScorePercent}% and earned your verified certificate of completion!'
                        : 'Pass score: 70% · Max attempts: $maxAttempts · Tests key concepts from WHO/NIMH guidelines.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
                    ),
                  ),
                  if (attempts.isNotEmpty && certificate == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Past attempts: ${attempts.map((a) => "${a.scorePercent}%").join(", ")} (Attempts left: $attemptsRemaining)',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MindBridgeTheme.clay),
                    ),
                  ],
                  const SizedBox(height: 14),
                  if (certificate != null)
                    ElevatedButton.icon(
                      onPressed: () => _viewCertificate(context, certificate),
                      icon: const Icon(Icons.workspace_premium, color: MindBridgeTheme.paper, size: 18),
                      label: const Text('View Certificate of Completion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MindBridgeTheme.forest,
                        foregroundColor: MindBridgeTheme.paper,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  else if (attemptsRemaining > 0)
                    ElevatedButton.icon(
                      onPressed: () => _openQuiz(context),
                      icon: const Icon(Icons.play_arrow_rounded, color: MindBridgeTheme.paper),
                      label: Text(attempts.isEmpty ? 'Take Quiz for Certificate' : 'Retake Quiz ($attemptsRemaining left)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MindBridgeTheme.ink,
                        foregroundColor: MindBridgeTheme.paper,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade400, width: 1.2),
                      ),
                      child: const Text(
                        'Maximum attempts reached (3/3). Please review the lessons above carefully before trying again later.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          const SafetyNote(compact: true),
        ],
      ),
    );
  }
}

class _CourseQuizDialog extends ConsumerStatefulWidget {
  const _CourseQuizDialog({required this.article});

  final LearningArticle article;

  @override
  ConsumerState<_CourseQuizDialog> createState() => _CourseQuizDialogState();
}

class _CourseQuizDialogState extends ConsumerState<_CourseQuizDialog> {
  int _questionIndex = 0;
  final Map<int, int> _selectedAnswers = {};
  bool _submitted = false;

  void _submitQuiz() {
    final quiz = widget.article.quiz!;
    int correctCount = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      if (_selectedAnswers[i] == quiz.questions[i].correctIndex) {
        correctCount++;
      }
    }
    final scorePercent = ((correctCount / quiz.questions.length) * 100).round();
    final passed = scorePercent >= quiz.passingScorePercent;

    final existingAttempts =
        ref.read(courseAttemptsProvider)[widget.article.id] ?? [];
    final attemptNumber = existingAttempts.length + 1;

    final attempt = QuizAttemptRecord(
      courseId: widget.article.id,
      scorePercent: scorePercent,
      passed: passed,
      timestamp: DateTime.now(),
      attemptNumber: attemptNumber,
    );

    ref.read(courseAttemptsProvider.notifier).recordAttempt(attempt);

    if (passed) {
      final certId =
          'MB-CERT-${widget.article.id.toUpperCase()}-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch % 10000}';
      final certificate = CourseCertificate(
        certificateId: certId,
        courseId: widget.article.id,
        courseTitle: widget.article.title,
        recipientName: 'MindBridge Learner',
        finalScorePercent: scorePercent,
        issuedAt: DateTime.now(),
      );
      ref.read(courseCertificatesProvider.notifier).issueCertificate(certificate);
    }

    setState(() => _submitted = true);
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final textColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final cardBg = isDark ? const Color(0xFF161616) : MindBridgeTheme.paper;

    final quiz = widget.article.quiz!;
    final questions = quiz.questions;

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _submitted ? _buildResultView(context, isDark, borderColor, textColor) : _buildQuestionsView(context, questions, isDark, borderColor, textColor),
        ),
      ),
    );
  }

  Widget _buildQuestionsView(
    BuildContext context,
    List<QuizQuestion> questions,
    bool isDark,
    Color borderColor,
    Color textColor,
  ) {
    final question = questions[_questionIndex];
    final selectedChoice = _selectedAnswers[_questionIndex];
    final isLastQuestion = _questionIndex == questions.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDE5),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: Text(
                'QUESTION ${_questionIndex + 1} OF ${questions.length}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: MindBridgeTheme.forest),
              ),
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.close, color: textColor, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          question.question,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor, height: 1.3),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.builder(
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              final isChosen = selectedChoice == index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedAnswers[_questionIndex] = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isChosen
                          ? (isDark ? const Color(0xFF263326) : const Color(0xFFEBF3E8))
                          : (isDark ? const Color(0xFF202020) : MindBridgeTheme.milk),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isChosen ? MindBridgeTheme.forest : borderColor,
                        width: isChosen ? 2.0 : 1.4,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isChosen ? MindBridgeTheme.forest : Colors.transparent,
                            border: Border.all(color: isChosen ? MindBridgeTheme.forest : borderColor, width: 1.6),
                          ),
                          child: isChosen
                              ? const Icon(Icons.check, size: 14, color: MindBridgeTheme.paper)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.options[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isChosen ? FontWeight.w700 : FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_questionIndex > 0)
              OutlinedButton(
                onPressed: () => setState(() => _questionIndex--),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Back'),
              )
            else
              const SizedBox.shrink(),
            ElevatedButton(
              onPressed: selectedChoice == null
                  ? null
                  : () {
                      if (isLastQuestion) {
                        _submitQuiz();
                      } else {
                        setState(() => _questionIndex++);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: MindBridgeTheme.ink,
                foregroundColor: MindBridgeTheme.paper,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(isLastQuestion ? 'Submit Quiz' : 'Next Question'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResultView(
    BuildContext context,
    bool isDark,
    Color borderColor,
    Color textColor,
  ) {
    final quiz = widget.article.quiz!;
    int correctCount = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      if (_selectedAnswers[i] == quiz.questions[i].correctIndex) {
        correctCount++;
      }
    }
    final scorePercent = ((correctCount / quiz.questions.length) * 100).round();
    final passed = scorePercent >= quiz.passingScorePercent;
    final certificates = ref.watch(courseCertificatesProvider);
    final cert = certificates[widget.article.id];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: passed ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
            shape: BoxShape.circle,
            border: Border.all(color: passed ? MindBridgeTheme.forest : Colors.red, width: 2),
          ),
          child: Icon(
            passed ? Icons.workspace_premium : Icons.sentiment_dissatisfied,
            color: passed ? MindBridgeTheme.forest : Colors.red,
            size: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          passed ? 'Course Passed & Certified!' : 'Quiz Needs Review',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'Your Score: $scorePercent% ($correctCount/${quiz.questions.length} correct)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: passed ? MindBridgeTheme.forest : Colors.red,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          passed
              ? 'Great work! You reached the required 70% passing threshold based on WHO & NIMH guidelines.'
              : 'You scored below the 70% required threshold. Take a moment to review the course lessons and try again.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted),
        ),
        const SizedBox(height: 16),
        if (passed && cert != null) ...[
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog<void>(
                context: context,
                builder: (context) => _CertificateCardDialog(certificate: cert),
              );
            },
            icon: const Icon(Icons.workspace_premium, color: MindBridgeTheme.paper, size: 18),
            label: const Text('View Your Certificate'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MindBridgeTheme.forest,
              foregroundColor: MindBridgeTheme.paper,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 8),
        ],
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class _CertificateCardDialog extends StatelessWidget {
  const _CertificateCardDialog({required this.certificate});

  final CourseCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final cardBg = isDark ? const Color(0xFF141414) : MindBridgeTheme.paper;
    final textColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;

    final dateFormatted =
        '${certificate.issuedAt.year}-${certificate.issuedAt.month.toString().padLeft(2, '0')}-${certificate.issuedAt.day.toString().padLeft(2, '0')}';

    return Dialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E261E) : const Color(0xFFF9F7F1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: MindBridgeTheme.forest, width: 2),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.workspace_premium, color: MindBridgeTheme.forest, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'MINDBRIDGE ACADEMY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: MindBridgeTheme.forest,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'CERTIFICATE OF COMPLETION',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'This certifies that',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      certificate.recipientName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'has successfully completed the accredited curriculum and passed the clinical assessment for:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      certificate.courseTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: MindBridgeTheme.forest,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: MindBridgeTheme.forest, thickness: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('SCORE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: MindBridgeTheme.muted)),
                            Text('${certificate.finalScorePercent}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textColor)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('DATE ISSUED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: MindBridgeTheme.muted)),
                            Text(dateFormatted, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: textColor)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          const Text('VERIFICATION ID', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: MindBridgeTheme.muted)),
                          const SizedBox(height: 2),
                          Text(
                            certificate.certificateId,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: textColor, letterSpacing: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CertificatesListSheet extends ConsumerWidget {
  const _CertificatesListSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final textColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final cardBg = isDark ? const Color(0xFF141414) : MindBridgeTheme.paper;

    final certificatesMap = ref.watch(courseCertificatesProvider);
    final certificates = certificatesMap.values.toList();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: .7,
      maxChildSize: .9,
      builder: (context, controller) => ListView(
        key: const Key('certificates_list_view'),
        controller: controller,
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 30),
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionLabel('ACCREDITED CREDENTIALS'),
          const SizedBox(height: 8),
          Text(
            'My Certificates',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Official certificates earned by mastering accredited mental health courses (>= 70% score). Stored locally for offline verification.',
            style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted),
          ),
          const SizedBox(height: 18),
          if (certificates.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
                boxShadow: MindBridgeTheme.neoShadowSmall,
              ),
              child: Column(
                children: [
                  const Icon(Icons.workspace_premium_outlined, color: MindBridgeTheme.muted, size: 36),
                  const SizedBox(height: 10),
                  Text('No Certificates Earned Yet', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Complete any course and pass the end-of-course quiz with 70% or higher to earn an official certificate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted),
                  ),
                ],
              ),
            )
          else
            ...certificates.map(
              (cert) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E281E) : const Color(0xFFF4F9F2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: MindBridgeTheme.forest, width: 1.6),
                    boxShadow: MindBridgeTheme.neoShadowSmall,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: MindBridgeTheme.forest, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cert.courseTitle,
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Score: ${cert.finalScorePercent}% · ID: ${cert.certificateId}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: MindBridgeTheme.forest),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility_outlined, color: MindBridgeTheme.forest, size: 20),
                        onPressed: () {
                          showDialog<void>(
                            context: context,
                            builder: (context) => _CertificateCardDialog(certificate: cert),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
