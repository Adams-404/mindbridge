import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import 'theme.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          letterSpacing: 1.3,
          fontWeight: FontWeight.w800,
          color: MindBridgeTheme.forest,
        ),
      );
}

class SafetyNote extends StatelessWidget {
  const SafetyNote({super.key, this.compact = false, this.text});
  final bool compact;
  final String? text;

  @override
  Widget build(BuildContext context) {
    final content = text ??
        'MindBridge shares general information. It does not diagnose conditions or replace care from a qualified health professional.';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(compact ? 13 : 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2620) : const Color(0xFFE9EDE5),
        border: Border.all(
          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
          width: MindBridgeTheme.borderWidth,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest, size: 20),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: compact ? 11 : 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
              ),
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

class NeoCard extends StatelessWidget {
  const NeoCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor = MindBridgeTheme.paper,
    this.borderColor = MindBridgeTheme.ink,
    this.shadow = MindBridgeTheme.neoShadow,
    this.borderRadius = 12.0,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Color borderColor;
  final List<BoxShadow> shadow;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: MindBridgeTheme.borderWidth),
        boxShadow: shadow,
      ),
      child: child,
    );
  }
}

class FloatingTopHeader extends StatelessWidget {
  const FloatingTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
        borderRadius: BorderRadius.circular(MindBridgeTheme.navBorderRadius),
        border: Border.all(
          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
          width: MindBridgeTheme.borderWidth,
        ),
        boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
      ),
      child: Row(
        children: [
          Text(
            'mindbridge',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
              color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
            ),
          ),
          const Text(
            '.',
            style: TextStyle(
              fontSize: 20,
              color: MindBridgeTheme.clay,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class FloatingAiPill extends StatelessWidget {
  const FloatingAiPill({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(MindBridgeTheme.navBorderRadius),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
            borderRadius: BorderRadius.circular(MindBridgeTheme.navBorderRadius),
            border: Border.all(
              color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
              width: MindBridgeTheme.borderWidth,
            ),
            boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: MindBridgeTheme.clay,
              ),
              const SizedBox(width: 6),
              Text(
                'AI',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FloatingBackButton extends StatelessWidget {
  const FloatingBackButton({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(MindBridgeTheme.navBorderRadius),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
            borderRadius: BorderRadius.circular(MindBridgeTheme.navBorderRadius),
            border: Border.all(
              color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
              width: MindBridgeTheme.borderWidth,
            ),
            boxShadow: isDark ? MindBridgeTheme.neoShadowSmallDark : MindBridgeTheme.neoShadowSmall,
          ),
          child: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class FloatingBottomBar extends ConsumerWidget {
  const FloatingBottomBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final isHausa = language == AppLanguage.hausa;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? MindBridgeTheme.darkCard : MindBridgeTheme.paper,
        borderRadius: BorderRadius.circular(MindBridgeTheme.navBorderRadius),
        border: Border.all(
          color: isDark ? MindBridgeTheme.milk : MindBridgeTheme.ink,
          width: MindBridgeTheme.borderWidth,
        ),
        boxShadow: isDark ? MindBridgeTheme.neoShadowDark : MindBridgeTheme.neoShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FloatingNavItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: isHausa ? 'Gida' : 'Home',
            isSelected: selectedIndex == 0,
            activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
            onTap: () => onDestinationSelected(0),
          ),
          _FloatingNavItem(
            icon: Icons.menu_book_outlined,
            selectedIcon: Icons.menu_book_rounded,
            label: isHausa ? 'Koyi' : 'Learn',
            isSelected: selectedIndex == 1,
            activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
            onTap: () => onDestinationSelected(1),
          ),
          _FloatingNavItem(
            icon: Icons.spa_outlined,
            selectedIcon: Icons.spa_rounded,
            label: isHausa ? 'Dubawa' : 'Check-in',
            isSelected: selectedIndex == 2,
            activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
            onTap: () => onDestinationSelected(2),
          ),
          _FloatingNavItem(
            icon: Icons.favorite_border_rounded,
            selectedIcon: Icons.favorite_rounded,
            label: isHausa ? 'Tallafi' : 'Support',
            isSelected: selectedIndex == 3,
            activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
            onTap: () => onDestinationSelected(3),
          ),
          _FloatingNavItem(
            icon: Icons.tune_rounded,
            selectedIcon: Icons.tune,
            label: isHausa ? 'Saituna' : 'Settings',
            tooltip: 'Settings',
            isSelected: selectedIndex == 4,
            activeColor: isDark ? MindBridgeTheme.milk : MindBridgeTheme.forest,
            onTap: () => onDestinationSelected(4),
          ),
        ],
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.activeColor = MindBridgeTheme.forest,
    this.tooltip,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Tooltip(
        message: tooltip ?? label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              onTap();
            },
            borderRadius: BorderRadius.circular(10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? activeColor : Colors.transparent,
                  width: 1.8,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSelected ? selectedIcon : icon,
                    size: 21,
                    color: isSelected ? activeColor : MindBridgeTheme.muted,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? activeColor : MindBridgeTheme.muted,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
