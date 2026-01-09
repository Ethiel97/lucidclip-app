import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

@RoutePage()
class IgnoredAppsPage extends StatelessWidget {
  const IgnoredAppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Text(context.l10n.ignoredApps.sentenceCase),
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.settings != current.settings,
        builder: (context, state) {
          final l10n = context.l10n;
          final textTheme = Theme.of(context).textTheme;
          final colorScheme = Theme.of(context).colorScheme;
          final settings = state.settings.value;
          final excluded = settings?.excludedApps ?? [];

          if (settings == null) return const SizedBox.shrink();

          if (excluded.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: AppSpacing.md,
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedIncognito,
                    size: 128,
                  ),
                  Text(
                    l10n.noAppsAreCurrentlyIgnored,

                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: excluded.length,
            itemBuilder: (context, index) {
              final app = excluded[index];

              return Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  spacing: AppSpacing.sm,
                  children: [
                    app.iconWidget,
                    Expanded(
                      child: Text(
                        app.name,
                        style: textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.primary.withValues(
                          alpha: 0.9,
                        ),
                      ),
                      onPressed: () {
                        context.read<ClipboardCubit>().toggleAppExclusion(app);
                      },
                      child: Text(l10n.resumeTracking),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
