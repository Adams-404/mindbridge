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

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final language = ref.watch(languageProvider);
    final isHausa = language == AppLanguage.hausa;

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
                        : 'Ask general mental health questions in English or Hausa. Powered by Qwen 3.8 27B on Groq.',
                  ),
                  const SizedBox(height: 16),
                  // Model & Safety Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: MindBridgeTheme.paper,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
                      boxShadow: MindBridgeTheme.neoShadowSmall,
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
                        const Expanded(
                          child: Text(
                            'Active Model: Qwen 3.8 27B (Groq) · High-speed inference',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MindBridgeTheme.ink),
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
                        color: const Color(0xFFE8EDE5),
                        border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: MindBridgeTheme.neoShadow,
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
                                  color: MindBridgeTheme.paper,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: MindBridgeTheme.ink, width: 1.4),
                                ),
                                child: const Icon(Icons.auto_awesome_rounded, color: MindBridgeTheme.forest, size: 20),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Grounded Psychoeducation',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: MindBridgeTheme.ink),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'MindBridge AI provides general educational explanations and grounding exercises. It does not diagnose, prescribe, or substitute professional therapy.',
                            style: TextStyle(fontSize: 12, height: 1.5, color: MindBridgeTheme.ink),
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
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: MindBridgeTheme.ink),
                        ),
                        backgroundColor: MindBridgeTheme.paper,
                        side: const BorderSide(color: MindBridgeTheme.ink, width: 1.4),
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
                          color: const Color(0xFFF0E3D9),
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
                                style: const TextStyle(fontSize: 11, color: MindBridgeTheme.ink),
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
              decoration: const BoxDecoration(
                color: MindBridgeTheme.paper,
                border: Border(
                  top: BorderSide(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
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
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: isHausa
                            ? 'Yi tambaya a Hausa ko Turanci...'
                            : 'Ask a question in English or Hausa...',
                        hintStyle: const TextStyle(fontSize: 13, color: MindBridgeTheme.muted),
                        filled: true,
                        fillColor: MindBridgeTheme.milk,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MindBridgeTheme.ink, width: 1.6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MindBridgeTheme.forest, width: 2.2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: MindBridgeTheme.ink, width: 1.6),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: chatState.isLoading ? MindBridgeTheme.muted : MindBridgeTheme.forest,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: chatState.isLoading ? null : () => _sendMessage(),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
                          boxShadow: MindBridgeTheme.neoShadowSmall,
                        ),
                        child: const Icon(Icons.send_rounded, color: MindBridgeTheme.paper, size: 20),
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
    final isUser = message.role == 'user';

    if (isUser) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 290),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: MindBridgeTheme.forest,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
            boxShadow: MindBridgeTheme.neoShadowSmall,
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
          color: MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
          boxShadow: MindBridgeTheme.neoShadowSmall,
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
                    color: const Color(0xFFE8EDE5),
                    shape: BoxShape.circle,
                    border: Border.all(color: MindBridgeTheme.ink, width: 1.2),
                  ),
                  child: const Text('MB', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: MindBridgeTheme.forest)),
                ),
                const SizedBox(width: 8),
                const Text(
                  'MindBridge AI',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: MindBridgeTheme.forest),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              message.content,
              style: const TextStyle(fontSize: 13, height: 1.55, fontWeight: FontWeight.w500, color: MindBridgeTheme.ink),
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: MindBridgeTheme.paper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: MindBridgeTheme.ink, width: MindBridgeTheme.borderWidth),
          boxShadow: MindBridgeTheme.neoShadowSmall,
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: MindBridgeTheme.forest),
            ),
            SizedBox(width: 10),
            Text(
              'MindBridge AI is reflecting...',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: MindBridgeTheme.muted),
            ),
          ],
        ),
      ),
    );
  }
}
