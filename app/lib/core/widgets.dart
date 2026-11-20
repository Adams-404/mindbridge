import 'package:flutter/material.dart';

import 'theme.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label.toUpperCase(),
        style: const TextStyle(fontSize: 10, letterSpacing: 1.1, fontWeight: FontWeight.w600, color: MindBridgeTheme.forest),
      );
}

class SafetyNote extends StatelessWidget {
  const SafetyNote({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDE5),
        border: Border.all(color: const Color(0xFFC9D4C7)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: MindBridgeTheme.forest, size: 19),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'MindBridge shares general information. It does not diagnose conditions or replace care from a qualified health professional.',
              style: TextStyle(fontSize: compact ? 11 : 12, height: 1.5, color: MindBridgeTheme.ink),
            ),
          ),
        ],
      ),
    );
  }
}

class PageHeading extends StatelessWidget {
  const PageHeading({required this.eyebrow, required this.title, this.subtitle, super.key});
  final String eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(eyebrow),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ],
    );
  }
}
