import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/settings.dart';
import 'package:lucid_clip/l10n/l10n.dart';

class RetentionWarningBadge extends StatelessWidget {
  const RetentionWarningBadge({
    required this.item,
    this.mode = RetentionDisplayMode.badgeOnly,
    super.key,
  });

  final ClipboardItem item;
  final RetentionDisplayMode mode;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final retentionDaySettings = context.select(
      (SettingsCubit cubit) => cubit.state.retentionDays,
    );

    final retentionPolicy = RetentionWarningPolicy(
      now: DateTime.now,
      retentionDuration: RetentionDuration.fromDays(retentionDaySettings),
    );

    final retentionWarning = retentionPolicy.evaluate(item: item, mode: mode);

    return retentionWarning.resolveBadge(
      l10n: context.l10n,
      colorScheme: colorScheme,
    );
  }
}
