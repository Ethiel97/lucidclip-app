import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/features/settings/presentation/widgets/widgets.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.lg),
          child: Text(l10n.settings.sentenceCase),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.settings != current.settings,
        builder: (context, state) {
          return state.settings.maybeWhen(
            orElse: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.errorLoadingSettings.sentenceCase,
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO(Ethiel97): Pull user ID from auth cubit
                      context.read<SettingsCubit>().loadSettings();
                    },
                    child: Text(l10n.retry.sentenceCase),
                  ),
                ],
              ),
            ),
            success: (settings) {
              if (settings == null) {
                return Center(
                  child: Text(l10n.noSettingsAvailable.sentenceCase),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: [
                  // General Section
                  SettingsSectionHeader(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedSettings02,
                    ),
                    title: l10n.general.sentenceCase,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  SettingsSwitchItem(
                    title: l10n.previewLinks.sentenceCase,
                    description: l10n.previewLinksDescription.sentenceCase,
                    value: settings.previewLinks,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updatePreviewLinks(
                        previewLinks: value,
                      );
                    },
                  ),
                  SettingsSwitchItem(
                    title: l10n.previewImages.sentenceCase,
                    description: l10n.previewImagesDescription.sentenceCase,
                    value: settings.previewImages,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updatePreviewImages(
                        previewImages: value,
                      );
                    },
                  ),

                  // Appearance Section
                  const SizedBox(height: AppSpacing.md),
                  SettingsSectionHeader(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedPaintBoard,
                    ),
                    title: l10n.appearance.sentenceCase,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SettingsThemeSelector(
                    currentTheme: settings.theme,
                    onThemeChanged: (theme) {
                      context.read<SettingsCubit>().updateTheme(theme);
                    },
                  ),

                  // Clipboard Section
                  const SizedBox(height: AppSpacing.md),
                  SettingsSectionHeader(
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedClipboard,
                    ),
                    title: l10n.clipboard.sentenceCase,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SettingsSwitchItem(
                    title: l10n.showSourceApp.sentenceCase,
                    description: l10n.showSourceAppDescription.sentenceCase,
                    value: settings.showSourceApp,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updateShowSourceApp(
                        showSourceApp: value,
                      );
                    },
                  ),
                  SettingsSwitchItem(
                    title: l10n.incognitoMode.sentenceCase,
                    description: l10n.incognitoModeDescription.sentenceCase,
                    value: settings.incognitoMode,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updateIncognitoMode(
                        incognitoMode: value,
                      );
                    },
                  ),
                  SettingsSwitchItem(
                    title: l10n.autoSync.sentenceCase,
                    description: l10n.autoSyncDescription.sentenceCase,
                    value: settings.autoSync,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updateAutoSync(
                        autoSync: value,
                      );
                    },
                  ),

                  SettingsDropdownItem<int>(
                    title: l10n.historyLimit.sentenceCase,
                    description: l10n.maxHistoryItemsDescription.sentenceCase,
                    value: settings.maxHistoryItems,
                    items: const [50, 100, 500, 1000],
                    itemLabel: (value) => '$value items',
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsCubit>().updateMaxHistoryItems(
                          value,
                        );
                      }
                    },
                  ),
                  SettingsDropdownItem<int>(
                    title: l10n.retentionDays.sentenceCase,
                    description: l10n.retentionDaysDescription.sentenceCase,
                    value: settings.retentionDays,
                    items: const [1, 7, 14, 30, 60, 90, 180, 365],
                    itemLabel: (value) => '$value days',
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsCubit>().updateRetentionDays(
                          value,
                        );
                      }
                    },
                  ),

                  // Sync Section (if auto sync is enabled)
                  if (settings.autoSync) ...[
                    const SizedBox(height: AppSpacing.md),
                    SettingsSectionHeader(
                      icon: const HugeIcon(
                        icon: HugeIcons.strokeRoundedCloudUpload,
                      ),
                      title: l10n.sync.sentenceCase,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SettingsDropdownItem<int>(
                      title: l10n.autoSyncInterval.sentenceCase,
                      description:
                          l10n.autoSyncIntervalDescription.sentenceCase,
                      value: settings.syncIntervalMinutes,
                      items: const [1, 5, 10, 15, 30, 60],
                      itemLabel: (value) => '$value minutes',
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsCubit>().updateSyncInterval(
                            value,
                          );
                        }
                      },
                    ),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }
}
