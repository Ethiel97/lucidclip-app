import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                  Text('Error: ${errorDetails.message}'),
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
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSection(
                    context,
                    title: 'Appearance',
                    children: [
                      _buildThemeSelector(context, settings.theme),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Sync Settings',
                    children: [
                      _buildSwitchTile(
                        context,
                        title: 'Auto Sync',
                        subtitle: 'Automatically sync clipboard to cloud',
                        value: settings.autoSync,
                        onChanged: (value) {
                          context.read<SettingsCubit>().updateAutoSync(value);
                        },
                      ),
                      if (settings.autoSync) ...[
                        _buildSliderTile(
                          context,
                          title: 'Sync Interval',
                          subtitle: '${settings.syncIntervalMinutes} minutes',
                          value: settings.syncIntervalMinutes.toDouble(),
                          min: 1,
                          max: 60,
                          divisions: 59,
                          onChanged: (value) {
                            context
                                .read<SettingsCubit>()
                                .updateSyncInterval(value.toInt());
                          },
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Clipboard Settings',
                    children: [
                      _buildSliderTile(
                        context,
                        title: 'Max History Items',
                        subtitle: '${settings.maxHistoryItems} items',
                        value: settings.maxHistoryItems.toDouble(),
                        min: 100,
                        max: 10000,
                        divisions: 99,
                        onChanged: (value) {
                          context
                              .read<SettingsCubit>()
                              .updateMaxHistoryItems(value.toInt());
                        },
                      ),
                      _buildSliderTile(
                        context,
                        title: 'Retention Period',
                        subtitle: '${settings.retentionDays} days',
                        value: settings.retentionDays.toDouble(),
                        min: 1,
                        max: 365,
                        divisions: 364,
                        onChanged: (value) {
                          context
                              .read<SettingsCubit>()
                              .updateRetentionDays(value.toInt());
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Display Settings',
                    children: [
                      _buildSwitchTile(
                        context,
                        title: 'Pin on Top',
                        subtitle: 'Keep pinned items at the top',
                        value: settings.pinOnTop,
                        onChanged: (value) {
                          context.read<SettingsCubit>().updatePinOnTop(value);
                        },
                      ),
                      _buildSwitchTile(
                        context,
                        title: 'Show Source App',
                        subtitle: 'Display which app the clipboard item came from',
                        value: settings.showSourceApp,
                        onChanged: (value) {
                          context.read<SettingsCubit>().updateShowSourceApp(value);
                        },
                      ),
                      _buildSwitchTile(
                        context,
                        title: 'Preview Images',
                        subtitle: 'Show image previews in the list',
                        value: settings.previewImages,
                        onChanged: (value) {
                          context.read<SettingsCubit>().updatePreviewImages(value);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSelector(BuildContext context, String currentTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(
                value: 'light',
                label: Text('Light'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment(
                value: 'dark',
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode),
              ),
              ButtonSegment(
                value: 'system',
                label: Text('System'),
                icon: Icon(Icons.settings_suggest),
              ),
            ],
            selected: {currentTheme},
            onSelectionChanged: (Set<String> selected) {
              context.read<SettingsCubit>().updateTheme(selected.first);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  Widget _buildSliderTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
