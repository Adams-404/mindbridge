import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  static const moods = [
    ('Bright', '☀', 'A little lighter', 5),
    ('Calm', '◒', 'Steady for now', 4),
    ('Worried', '⌁', 'A lot on my mind', 3),
    ('Sad', '○', 'Things feel heavy', 2),
    ('Anxious', '〰', 'Feeling unsettled', 2),
    ('Overwhelmed', '⋯', 'More than I can hold', 1),
  ];

  static const factorList = [
    ('💤 Sleep', 'Sleep'),
    ('💼 Work / Study', 'Work / Study'),
    ('👥 Relationships', 'Relationships'),
    ('🏃 Body & Health', 'Body & Health'),
    ('🌧️ Stressors', 'Stressors'),
    ('🧘 Quiet time', 'Quiet time'),
  ];

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _noteController = TextEditingController();
  final Set<String> _selectedFactors = {};
  String? _pendingMood;
  String? _pendingSymbol;
  int _pendingScore = 3;
  bool _justSaved = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _selectMood(String mood, String symbol, int score) {
    HapticFeedback.selectionClick();
    setState(() {
      _pendingMood = mood;
      _pendingSymbol = symbol;
      _pendingScore = score;
      _selectedFactors.clear();
      _noteController.clear();
      _justSaved = false;
    });
  }

  void _saveCheckIn() {
    if (_pendingMood == null) return;
    HapticFeedback.mediumImpact();
    ref.read(checkInHistoryProvider.notifier).addCheckIn(
      mood: _pendingMood!,
      symbol: _pendingSymbol ?? '◒',
      score: _pendingScore,
      note: _noteController.text.trim(),
      factors: _selectedFactors.toList(),
    );
    ref.read(moodSelectionProvider.notifier).state = _pendingMood;
    setState(() {
      _justSaved = true;
    });
  }

  void _resetSelection() {
    HapticFeedback.lightImpact();
    ref.read(moodSelectionProvider.notifier).state = null;
    setState(() {
      _pendingMood = null;
      _pendingSymbol = null;
      _justSaved = false;
      _selectedFactors.clear();
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final isHausa = language == AppLanguage.hausa;
    final selected = ref.watch(moodSelectionProvider);
    final history = ref.watch(checkInHistoryProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 84, 20, 110),
      children: [
        PageHeading(
          eyebrow: isHausa ? 'LOKACI DON KAI' : 'A MOMENT FOR YOU',
          title: isHausa ? 'Yaya kake ji\na yau?' : 'How are you\nfeeling today?',
          subtitle: isHausa
              ? 'Babu amsa daidai. Zabi abin da ya fi kusa da yadda kake ji, ko ajiye wannan zuwa wani lokaci.'
              : 'There is no right answer. Choose what feels closest, or leave this for another time.',
        ),
        const SizedBox(height: 22),
        if (selected == 'Skipped') ...[
          // Skipped state
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? MindBridgeTheme.darkCard : const Color(0xFFE8EDE5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: MindBridgeTheme.borderWidth,
              ),
              boxShadow: isDark ? MindBridgeTheme.neoShadowDark : MindBridgeTheme.neoShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF262626) : MindBridgeTheme.paper,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                      width: 1.6,
                    ),
                  ),
                  child: Icon(Icons.spa_outlined, size: 28, color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest),
                ),
                const SizedBox(height: 18),
                Text(
                  'That’s completely okay.',
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'You do not have to check in to use MindBridge.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: _resetSelection,
                  child: const Text('Back to choices'),
                ),
              ],
            ),
          ),
        ] else if (_justSaved || (selected != null && _pendingMood == null)) ...[
          // Saved confirmation state
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: isDark ? MindBridgeTheme.darkCard : const Color(0xFFE8EDE5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: MindBridgeTheme.borderWidth,
              ),
              boxShadow: isDark ? MindBridgeTheme.neoShadowDark : MindBridgeTheme.neoShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF262626) : MindBridgeTheme.paper,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                          width: 1.6,
                        ),
                      ),
                      child: Text(
                        _pendingSymbol ?? '✓',
                        style: const TextStyle(fontSize: 22, color: MindBridgeTheme.clay, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thank you for pausing.',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Logged as ${_pendingMood ?? selected}. Safely stored on your device.',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'You chose: ${_pendingMood ?? selected}. This reflection is not a diagnosis or a measure of your mental health.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    FilledButton.icon(
                      onPressed: _resetSelection,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Check in again'),
                    ),
                    OutlinedButton(
                      onPressed: _resetSelection,
                      child: const Text('Back to choices'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ] else if (_pendingMood != null) ...[
          // Mood selected: Customize factors and note before saving
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: MindBridgeTheme.borderWidth,
              ),
              boxShadow: isDark ? MindBridgeTheme.neoShadowDark : MindBridgeTheme.neoShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2B201A) : const Color(0xFFF0E3D9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isDark ? MindBridgeTheme.clay : MindBridgeTheme.ink,
                          width: 1.4,
                        ),
                      ),
                      child: Text(
                        _pendingSymbol!,
                        style: const TextStyle(fontSize: 22, color: MindBridgeTheme.clay, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Feeling $_pendingMood',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'What factors are influencing this moment?',
                            style: TextStyle(fontSize: 11, color: MindBridgeTheme.muted),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => setState(() => _pendingMood = null),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CheckInScreen.factorList.map((factor) {
                    final isSelected = _selectedFactors.contains(factor.$2);
                    return FilterChip(
                      label: Text(
                        factor.$1,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected
                              ? (isDark ? Colors.black : MindBridgeTheme.paper)
                              : (isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink),
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                      backgroundColor: isDark ? const Color(0xFF262626) : MindBridgeTheme.milk,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                          width: 1.2,
                        ),
                      ),
                      showCheckmark: false,
                      onSelected: (selected) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          if (selected) {
                            _selectedFactors.add(factor.$2);
                          } else {
                            _selectedFactors.remove(factor.$2);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Add an optional private note (stays on your phone)...',
                    hintStyle: const TextStyle(fontSize: 12, color: MindBridgeTheme.muted),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF141414) : MindBridgeTheme.milk,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                        width: 1.2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _saveCheckIn,
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: const Text('Save Reflection'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () => setState(() => _pendingMood = null),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ] else ...[
          // Default Mood Selector List
          ...CheckInScreen.moods.map((mood) => Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                  width: MindBridgeTheme.borderWidth,
                ),
                boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => _selectMood(mood.$1, mood.$2, mood.$4),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2B201A) : const Color(0xFFF0E3D9),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? MindBridgeTheme.clay : MindBridgeTheme.ink,
                              width: 1.4,
                            ),
                          ),
                          child: Text(
                            mood.$2,
                            style: const TextStyle(fontSize: 20, color: MindBridgeTheme.clay, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mood.$1,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                mood.$3,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
          const SizedBox(height: 6),
          Center(
            child: TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(moodSelectionProvider.notifier).state = 'Skipped';
              },
              child: Text(
                'Skip this check-in',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 28),
        // Stats & Trend Chart Section
        Row(
          children: [
            const SectionLabel('TRENDS & HISTORY'),
            const Spacer(),
            if (history.isNotEmpty)
              Text(
                '${history.length} logged',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MindBridgeTheme.muted),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (history.isEmpty)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: MindBridgeTheme.borderWidth,
              ),
              boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
            ),
            child: Row(
              children: [
                const Icon(Icons.show_chart_rounded, size: 28, color: MindBridgeTheme.clay),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No check-ins logged yet',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Your daily reflections will build a private mood graph here over time.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        else ...[
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _CheckInStatBox(
                  label: 'TOTAL LOGGED',
                  value: '${history.length}',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CheckInStatBox(
                  label: 'TODAY',
                  value: '${history.where((e) => _isToday(e.timestamp)).length}',
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _CheckInStatBox(
                  label: 'TOP MOOD',
                  value: _getTopMood(history),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 7-Entry / 7-Day Trend Chart
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                width: MindBridgeTheme.borderWidth,
              ),
              boxShadow: isDark ? MindBridgeTheme.neoShadowDark : MindBridgeTheme.neoShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_graph_rounded, color: MindBridgeTheme.clay, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Mood Trajectory',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Recent entries',
                      style: TextStyle(fontSize: 11, color: MindBridgeTheme.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _MoodGraphPainter(
                      entries: history.take(7).toList().reversed.toList(),
                      isDark: isDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Recent Check-in Entries List
          ...history.take(4).map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                  width: 1.2,
                ),
                boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF2B201A) : const Color(0xFFF0E3D9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? MindBridgeTheme.clay : MindBridgeTheme.ink,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      entry.symbol,
                      style: const TextStyle(fontSize: 16, color: MindBridgeTheme.clay, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              entry.mood,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatDate(entry.timestamp),
                              style: const TextStyle(fontSize: 10, color: MindBridgeTheme.muted),
                            ),
                          ],
                        ),
                        if (entry.factors.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            entry.factors.join(' · '),
                            style: TextStyle(fontSize: 11, color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.forest),
                          ),
                        ],
                        if (entry.note.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '"${entry.note}"',
                            style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: MindBridgeTheme.muted),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: MindBridgeTheme.muted),
                    tooltip: 'Delete entry',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(checkInHistoryProvider.notifier).deleteCheckIn(entry.id);
                    },
                  ),
                ],
              ),
            ),
          )),
        ],
        const SizedBox(height: 24),
        SafetyNote(compact: true, text: AppStrings.safetyNoteText(language)),
        const SizedBox(height: 12),
        const Text(
          'Your choice is kept in memory while the app is open. It is not written to storage or sent anywhere.',
          style: TextStyle(fontSize: 10, color: MindBridgeTheme.muted, height: 1.5),
        ),
      ],
    );
  }

  static bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  static String _getTopMood(List<CheckInEntry> entries) {
    if (entries.isEmpty) return '—';
    final counts = <String, int>{};
    for (final e in entries) {
      counts[e.mood] = (counts[e.mood] ?? 0) + 1;
    }
    String top = entries.first.mood;
    int max = 0;
    counts.forEach((k, v) {
      if (v > max) {
        max = v;
        top = k;
      }
    });
    return top;
  }

  static String _formatDate(DateTime dt) {
    if (_isToday(dt)) {
      final hour = dt.hour.toString().padLeft(2, '0');
      final min = dt.minute.toString().padLeft(2, '0');
      return 'Today $hour:$min';
    }
    return '${dt.month}/${dt.day}';
  }
}

class _CheckInStatBox extends StatelessWidget {
  const _CheckInStatBox({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
          width: 1.2,
        ),
        boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: MindBridgeTheme.muted, letterSpacing: 0.8),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodGraphPainter extends CustomPainter {
  const _MoodGraphPainter({
    required this.entries,
    required this.isDark,
  });

  final List<CheckInEntry> entries;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink;
    final gridLinePaint = Paint()
      ..color = isDark ? const Color(0xFF2E2E2E) : const Color(0xFFDED9CD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw reference horizontal grid lines (scores 1, 3, 5)
    for (int s = 1; s <= 5; s += 2) {
      final y = size.height - ((s - 1) / 4.0) * (size.height - 24) - 12;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridLinePaint);
    }

    if (entries.isEmpty) return;

    final linePaint = Paint()
      ..color = MindBridgeTheme.clay
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    final pointBorderPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final pointFillPaint = Paint()
      ..color = isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper
      ..style = PaintingStyle.fill;

    final points = <Offset>[];
    final stepX = entries.length <= 1 ? size.width * 0.5 : size.width / (entries.length - 1);

    for (int i = 0; i < entries.length; i++) {
      final score = entries[i].score.clamp(1, 5);
      final x = entries.length <= 1 ? size.width * 0.5 : i * stepX;
      final y = size.height - ((score - 1) / 4.0) * (size.height - 24) - 12;
      points.add(Offset(x, y));
    }

    // Connect line
    if (points.length > 1) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      canvas.drawPath(path, linePaint);
    }

    // Draw points and symbols
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      canvas.drawCircle(p, 6.0, pointFillPaint);
      canvas.drawCircle(p, 6.0, pointBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MoodGraphPainter oldDelegate) =>
      oldDelegate.entries != entries || oldDelegate.isDark != isDark;
}
