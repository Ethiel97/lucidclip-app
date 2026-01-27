import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';

class SettingsSectionGroupAccordion extends StatefulWidget {
  const SettingsSectionGroupAccordion({
    required this.children,
    required this.icon,
    required this.title,
    this.initiallyExpanded = true,
    super.key,
  });

  final String title;
  final Widget icon;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  State<SettingsSectionGroupAccordion> createState() =>
      _SettingsSectionGroupAccordionState();
}

class _SettingsSectionGroupAccordionState
    extends State<SettingsSectionGroupAccordion> {
  late bool _isExpanded;

  @override
  void didUpdateWidget(covariant SettingsSectionGroupAccordion oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: SettingsSectionHeader(
                      icon: widget.icon,
                      title: widget.title,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: const HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            reverseDuration: const Duration(milliseconds: 100),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (child, animation) =>
                SizeTransition(sizeFactor: animation, child: child),
            child: _isExpanded
                ? Column(
                    key: const ValueKey('expanded'),
                    spacing: AppSpacing.sm,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [...widget.children],
                  )
                : const SizedBox.shrink(key: ValueKey('collapsed')),
          ),
        ],
      ),
    );
  }
}
