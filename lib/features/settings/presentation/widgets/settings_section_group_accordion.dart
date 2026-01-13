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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
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
                  duration: const Duration(milliseconds: 200),
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowDown01,
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xs),
                    ...widget.children,
                  ],
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
