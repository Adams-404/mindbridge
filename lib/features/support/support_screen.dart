import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_strings.dart';
import '../../core/providers.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/support_repository.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final directoryMetadata = ref.watch(supportDirectoryMetadataProvider).valueOrNull;
    final noticeText = directoryMetadata?.statusMessage ?? AppStrings.supportDirectoryNotice(language);
    final repo = ref.watch(supportRepositoryProvider);
    final helplines = repo.getCrisisHelplines();
    final prepItems = repo.getAppointmentPrepItems();
    final checkedIds = ref.watch(supportChecklistProvider);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF141414) : MindBridgeTheme.paper;
    final borderColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;
    final textColor = isDark ? MindBridgeTheme.paper : MindBridgeTheme.ink;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 100),
      children: [
        PageHeading(
          eyebrow: AppStrings.supportEyebrow(language),
          title: AppStrings.supportTitle(language),
          subtitle:
              'Learning about your options can be a useful first step. A qualified health professional can help you understand what support may be appropriate.',
        ),
        const SizedBox(height: 22),

        // Directory Status Card (Preserves contract for test/repository_contracts_test.dart)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1B231C) : const Color(0xFFE8EDE5),
            border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
            borderRadius: BorderRadius.circular(14),
            boxShadow: MindBridgeTheme.neoShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: borderColor, width: 1.4),
                ),
                child: const Icon(Icons.people_alt_outlined, size: 26, color: MindBridgeTheme.forest),
              ),
              const SizedBox(height: 14),
              Text(
                AppStrings.supportDirectoryTitle(language),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                noticeText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? const Color(0xFFDDDDDD) : MindBridgeTheme.ink,
                      height: 1.45,
                    ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 1.2),
                ),
                child: const Text(
                  'Directory not yet available',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: MindBridgeTheme.forest),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Emergency Crisis Hotlines Section
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF241515) : const Color(0xFFFDF2F0),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: MindBridgeTheme.clay, width: MindBridgeTheme.borderWidth),
            boxShadow: MindBridgeTheme.neoShadowSmall,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF381C1C) : const Color(0xFFFFE5E0),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: MindBridgeTheme.clay, width: 1.4),
                    ),
                    child: const Icon(Icons.emergency_outlined, color: MindBridgeTheme.clay, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'IMMEDIATE CRISIS & LIFELINES',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1,
                            color: MindBridgeTheme.clay,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '24/7 Verified Emergency Helplines',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'If you or someone you know is in acute distress, experiencing thoughts of self-harm, or in immediate danger, please reach out to a trained crisis counselor immediately. Calls and texts are confidential and toll-free.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.45,
                  color: isDark ? const Color(0xFFCCCCCC) : MindBridgeTheme.muted,
                ),
              ),
              const SizedBox(height: 14),
              ...helplines.map((helpline) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: borderColor, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  helpline.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  helpline.region,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  helpline.description,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark ? const Color(0xFFBBBBBB) : MindBridgeTheme.muted,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      helpline.number,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: MindBridgeTheme.clay,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E281E) : const Color(0xFFE8EDE5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        helpline.availability,
                                        style: const TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: MindBridgeTheme.forest,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 18, color: MindBridgeTheme.clay),
                            tooltip: 'Copy ${helpline.number}',
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Clipboard.setData(ClipboardData(text: helpline.number));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 2),
                                  content: Text('Copied ${helpline.number} to clipboard'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),

        const SizedBox(height: 26),

        // Interactive Appointment Preparation Checklist
        Row(
          children: [
            Expanded(
              child: Text(
                'Preparing for Your Appointment',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${checkedIds.length}/${prepItems.length} prepared',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          'Evidence-based questions to ask a doctor, therapist, or counselor. Tap to check off items as you discuss them.',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 14),

        ...prepItems.map((item) {
          final isChecked = checkedIds.contains(item.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                ref.read(supportChecklistProvider.notifier).toggle(item.id);
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isChecked
                      ? (isDark ? const Color(0xFF1B2E1E) : const Color(0xFFF1F7F0))
                      : cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isChecked ? MindBridgeTheme.forest : borderColor,
                    width: isChecked ? 1.8 : 1.4,
                  ),
                  boxShadow: MindBridgeTheme.neoShadowSmall,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isChecked ? MindBridgeTheme.forest : Colors.transparent,
                        border: Border.all(
                          color: isChecked ? MindBridgeTheme.forest : borderColor,
                          width: 1.6,
                        ),
                      ),
                      child: isChecked
                          ? const Icon(Icons.check, size: 14, color: MindBridgeTheme.paper)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                item.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.9,
                                  color: MindBridgeTheme.forest,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.question,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.35,
                              fontWeight: isChecked ? FontWeight.w700 : FontWeight.w600,
                              decoration: isChecked ? TextDecoration.lineThrough : null,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.rationale,
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.35,
                              color: isDark ? const Color(0xFFAAAAAA) : MindBridgeTheme.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 18),
        SafetyNote(text: AppStrings.safetyNoteText(language)),
        const SizedBox(height: 14),
        const Text(
          'If you or someone else may be in immediate danger, seek urgent in-person help from local emergency services or a trusted person. MindBridge is not monitored and cannot dispatch assistance.',
          style: TextStyle(fontSize: 11, height: 1.6, color: MindBridgeTheme.muted),
        ),
      ],
    );
  }
}
