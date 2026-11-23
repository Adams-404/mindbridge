import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/localization/app_strings.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  static const _samplePrompts = [
    'What is the difference between stress and anxiety?',
    'How does rhythmic breathing help calm the body?',
    'Menene alamomin damuwa da gajiya?',
    'What can I expect in my first therapy session?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage([String? text]) {
    final query = text ?? _controller.text.trim();
    if (query.isEmpty) return;
    HapticFeedback.mediumImpact();
    _controller.clear();
    ref.read(chatProvider.notifier).sendUserMessage(query);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _openChatHistory(BuildContext context) {
    HapticFeedback.lightImpact();
    ref.read(chatSessionsProvider.notifier).loadSessions();
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : MindBridgeTheme.paper,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(
          color: Theme.of(context).brightness == Brightness.dark
              ? MindBridgeTheme.milk
              : MindBridgeTheme.ink,
          width: MindBridgeTheme.borderWidth,
        ),
      ),
      builder: (context) => const _ChatHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final language = ref.watch(languageProvider);
    final isHausa = language == AppLanguage.hausa;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Colors.black : MindBridgeTheme.paper;
    final borderColor = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink;
    final textColor = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink;
    final mutedColor = isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  FloatingBackButton(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/');
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'MindBridge AI',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Chat history',
                    onPressed: () => _openChatHistory(context),
                    icon: const Icon(Icons.history_rounded),
                  ),
                  IconButton(
                    tooltip: 'New conversation',
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      ref.read(chatProvider.notifier).startNewChat();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Started a new conversation'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_comment_outlined, color: MindBridgeTheme.clay),
                  ),
                  if (chatState.messages.isNotEmpty)
                    IconButton(
                      tooltip: 'Clear conversation',
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ref.read(chatProvider.notifier).clearConversation();
                      },
                      icon: const Icon(Icons.refresh_rounded, color: MindBridgeTheme.clay),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                children: [
                  PageHeading(
                    eyebrow: 'MINDBRIDGE INFORMATION ASSISTANT',
                    title: isHausa
                        ? 'Tambayoyi hanya\nce mai kyau ta farawa.'
                        : 'Questions are\na good place to start.',
                    subtitle: isHausa
                        ? 'Nemi bayani kan lafiyar kwakwalwa da hanyoyin kwantar da hankali a Hausa ko Turanci.'
                        : 'Ask general mental health questions in English or Hausa. Evidence-informed guidance & support.',
                  ),
                  const SizedBox(height: 16),
                  // Companion Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
                      boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'MindBridge AI Companion · Evidence-informed guidance & support',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (chatState.messages.isEmpty) ...[
                    // Introductory Educational Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F1512) : const Color(0xFFE8EDE5),
                        border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isDark ? MindBridgeTheme.neoShadowDark : MindBridgeTheme.neoShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E2822) : MindBridgeTheme.paper,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: borderColor, width: 1.4),
                                ),
                                child: Icon(Icons.auto_awesome_rounded, color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Grounded Psychoeducation',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: textColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'MindBridge AI provides general educational explanations and grounding exercises. It does not diagnose, prescribe, or substitute professional therapy.',
                            style: TextStyle(fontSize: 12, height: 1.5, color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SectionLabel('SUGGESTED EXPLORATIONS'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _samplePrompts.map((prompt) => ActionChip(
                        label: Text(
                          prompt,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor),
                        ),
                        backgroundColor: cardBg,
                        side: BorderSide(color: borderColor, width: 1.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        onPressed: () => _sendMessage(prompt),
                      )).toList(),
                    ),
                    const SizedBox(height: 20),
                    SafetyNote(compact: true, text: AppStrings.safetyNoteText(language)),
                  ] else ...[
                    // Conversation messages
                    ...chatState.messages.map((message) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _MessageBubble(message: message),
                    )),
                    if (chatState.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 14),
                        child: _LoadingAssistantBubble(),
                      ),
                    if (chatState.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2B1818) : const Color(0xFFF0E3D9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: MindBridgeTheme.clay, width: 1.6),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: MindBridgeTheme.clay, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                chatState.errorMessage!,
                                style: TextStyle(fontSize: 11, color: textColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
            // Bottom input bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  top: BorderSide(color: borderColor, width: MindBridgeTheme.borderWidth),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 4,
                      style: TextStyle(color: textColor),
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: isHausa
                            ? 'Yi tambaya a Hausa ko Turanci...'
                            : 'Ask a question in English or Hausa...',
                        hintStyle: TextStyle(fontSize: 13, color: mutedColor),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF141414) : MindBridgeTheme.milk,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor, width: 1.6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest, width: 2.2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor, width: 1.6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: chatState.isLoading
                        ? mutedColor
                        : (isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: chatState.isLoading ? null : () => _sendMessage(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
                          boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
                        ),
                        child: Icon(
                          Icons.send_rounded,
                          color: isDark ? Colors.black : MindBridgeTheme.paper,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUser = message.role == 'user';
    final borderColor = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink;

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 290),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2A20) : MindBridgeTheme.forest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
            boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
          ),
          child: Text(
            message.content,
            style: const TextStyle(fontSize: 13, height: 1.45, fontWeight: FontWeight.w600, color: MindBridgeTheme.paper),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
          boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A2A20) : const Color(0xFFE8EDE5),
                    shape: BoxShape.circle,
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  child: Text(
                    'MB',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'MindBridge AI',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                fontWeight: FontWeight.w500,
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingAssistantBubble extends StatelessWidget {
  const _LoadingAssistantBubble();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? Colors.black : MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
          boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'MindBridge AI is reflecting...',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatHistorySheet extends ConsumerWidget {
  const _ChatHistorySheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(chatSessionsProvider);
    final activeSessionId = ref.watch(chatProvider).sessionId;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink;
    final textColor = isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink;
    final cardBg = isDark ? const Color(0xFF141414) : MindBridgeTheme.paper;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Chat History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  ref.read(chatProvider.notifier).startNewChat();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add_rounded),
                label: const Text('Start New Conversation'),
              ),
              const SizedBox(height: 18),
              if (sessions.isEmpty)
                Expanded(
                  child: Center(
                    child: Text(
                      'No past conversations saved yet.',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isActive = session.id == activeSessionId;

                      return Container(
                        decoration: BoxDecoration(
                          color: isActive
                              ? (isDark ? const Color(0xFF1E2822) : const Color(0xFFE8EDE5))
                              : cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isActive ? MindBridgeTheme.forest : borderColor,
                            width: isActive ? 2.0 : 1.4,
                          ),
                          boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                            title: Text(
                              session.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: textColor,
                              ),
                            ),
                            subtitle: Text(
                              '${session.messages.length} messages · ${MaterialLocalizations.of(context).formatShortDate(session.createdAt)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? MindBridgeTheme.darkMuted : MindBridgeTheme.muted,
                              ),
                            ),
                            trailing: IconButton(
                              tooltip: 'Delete session',
                              icon: const Icon(Icons.delete_outline_rounded, color: MindBridgeTheme.clay),
                              onPressed: () async {
                                HapticFeedback.lightImpact();
                                await ref.read(chatSessionsProvider.notifier).deleteSession(session.id);
                                await ref.read(chatProvider.notifier).deleteSession(session.id);
                              },
                            ),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(chatProvider.notifier).loadSession(session);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
