import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/features/settings/presentation/widgets/widgets.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.bg,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return state.settings.when(
            initial: () => const Center(
              child: Text('Initializing settings...'),
            ),
            loading: (oldValue) => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (errorDetails, oldValue) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${errorDetails.message}',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingsCubit>().loadSettings(null);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            success: (settings) {
              if (settings == null) {
                return const Center(child: Text('No settings available'));
              }

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: [
                  // General Section
                  const SettingsSectionHeader(
                    icon: HugeIcons.strokeRoundedSettings02,
                    title: 'General',
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Note: These settings use existing properties as placeholders
                  // TODO: Add dedicated properties for launch_at_startup, show_in_menu_bar, sound_effects
                  SettingsSwitchItem(
                    title: 'Launch at startup',
                    description: 'Automatically start Clipboard OS when you log in',
                    value: settings.pinOnTop,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updatePinOnTop(value);
                    },
                  ),
                  SettingsSwitchItem(
                    title: 'Show in menu bar',
                    description: 'Display clipboard icon in the macOS menu bar',
                    value: settings.showSourceApp,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updateShowSourceApp(value);
                    },
                  ),
                  SettingsSwitchItem(
                    title: 'Sound effects',
                    description: 'Play sounds for clipboard actions',
                    value: settings.previewImages,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updatePreviewImages(value);
                    },
                  ),

                  // Appearance Section
                  const SizedBox(height: AppSpacing.md),
                  const SettingsSectionHeader(
                    icon: HugeIcons.strokeRoundedPaintBoard,
                    title: 'Appearance',
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
                  const SettingsSectionHeader(
                    icon: HugeIcons.strokeRoundedClipboard,
                    title: 'Clipboard',
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SettingsDropdownItem<int>(
                    title: 'History limit',
                    description: 'Maximum number of items to keep',
                    value: settings.maxHistoryItems,
                    items: const [100, 500, 1000, 2500, 5000, 10000],
                    itemLabel: (value) => '$value items',
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsCubit>().updateMaxHistoryItems(value);
                      }
                    },
                  ),
                  SettingsDropdownItem<int>(
                    title: 'Auto-delete after',
                    description: 'Clear old clipboard items automatically',
                    value: settings.retentionDays,
                    items: const [7, 14, 30, 60, 90, 180, 365],
                    itemLabel: (value) => '$value days',
                    onChanged: (value) {
                      if (value != null) {
                        context.read<SettingsCubit>().updateRetentionDays(value);
                      }
                    },
                  ),
                  // Note: Password filtering uses autoSync as placeholder
                  // TODO: Add dedicated property for ignore_passwords
                  SettingsSwitchItem(
                    title: 'Ignore copied passwords',
                    description: "Don't save password manager data",
                    value: settings.autoSync,
                    onChanged: (value) {
                      context.read<SettingsCubit>().updateAutoSync(value);
                    },
                  ),

                  // Sync Section (if auto sync is enabled)
                  if (settings.autoSync) ...[
                    const SizedBox(height: AppSpacing.md),
                    const SettingsSectionHeader(
                      icon: HugeIcons.strokeRoundedCloudUpload,
                      title: 'Sync',
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SettingsDropdownItem<int>(
                      title: 'Sync interval',
                      description: 'How often to sync with cloud',
                      value: settings.syncIntervalMinutes,
                      items: const [1, 5, 10, 15, 30, 60],
                      itemLabel: (value) => '$value minutes',
                      onChanged: (value) {
                        if (value != null) {
                          context.read<SettingsCubit>().updateSyncInterval(value);
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

