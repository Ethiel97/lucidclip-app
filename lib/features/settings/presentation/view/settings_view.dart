import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

//TODO(Ethiel97): Add excluded apps management
class SettingsView extends StatefulWidget {
  const SettingsView({required this.section, super.key});

  final String section;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _sectionKeys = {
    SettingsSection.usage.name: GlobalKey(),
    SettingsSection.appearance.name: GlobalKey(),
    SettingsSection.privacy.name: GlobalKey(),
    SettingsSection.shortcuts.name: GlobalKey(),
    SettingsSection.sync.name: GlobalKey(),
    SettingsSection.about.name: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSection(widget.section);
    });
  }

  @override
  void didUpdateWidget(covariant SettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.section != widget.section) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSection(widget.section);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String section) {
    final keyContext = _sectionKeys[section]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

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
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: [
                  // Usage Section
                  SettingsSectionGroupAccordion(
                    key: _sectionKeys[SettingsSection.usage.name],
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedCursorPointer01,
                    ),
                    title: l10n.usage.sentenceCase,
                    children: [
                      _KeyboardShortcutsSection(settings: settings),
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
                    ],
                  ),

                  // Privacy Section
                  SettingsSectionGroupAccordion(
                    key: _sectionKeys[SettingsSection.privacy.name],
                    icon: const HugeIcon(icon: HugeIcons.strokeRoundedShield01),
                    title: l10n.privacy.sentenceCase,
                    children: [
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
                      SettingsNavigationItem(
                        title: l10n.ignoredApps.sentenceCase,
                        description: l10n.ignoredAppsDescription,
                        valueText: settings.excludedApps.isEmpty
                            ? l10n.none.sentenceCase
                            : l10n.appsCount(settings.excludedApps.length),

                        onTap: () {
                          context.router.navigate(const IgnoredAppsRoute());
                        },
                      ),
                    ],
                  ),

                  // Appearance Section
                  SettingsSectionGroupAccordion(
                    initiallyExpanded: false,
                    key: _sectionKeys[SettingsSection.appearance.name],
                    icon: const HugeIcon(
                      icon: HugeIcons.strokeRoundedPaintBoard,
                    ),

                    title: l10n.appearance.sentenceCase,
                    children: [
                      SettingsThemeSelector(
                        currentTheme: settings.theme.toLowerCase(),
                        onThemeChanged: (theme) {
                          context.read<SettingsCubit>().updateTheme(theme);
                        },
                      ),
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
                    ],
                  ),

                  // History Section
                  SettingsSectionGroupAccordion(
                    initiallyExpanded: false,
                    key: _sectionKeys[SettingsSection.history.name],
                    icon: const HugeIcon(icon: HugeIcons.strokeRoundedDatabase),

                    title: l10n.history.sentenceCase,
                    children: [
                      ProGateOverlay(
                        badgeOffset: const Offset(12, -4),
                        child: SettingsDropdownItem<int>(
                          title: l10n.historyLimit.sentenceCase,
                          description:
                              l10n.maxHistoryItemsDescription.sentenceCase,
                          value: settings.maxHistoryItems,
                          items: const [50, 100, 500, 1000],
                          itemLabel: l10n.itemsCount,
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<SettingsCubit>()
                                  .updateMaxHistoryItems(value);
                            }
                          },
                        ),
                      ),

                      //TODO(Ethiel97): Make this a Pro feature
                      ProGateOverlay(
                        badgeOffset: const Offset(12, -4),
                        child: SettingsDropdownItem<int>(
                          title: l10n.retentionDays.sentenceCase,
                          description:
                              l10n.retentionDaysDescription.sentenceCase,
                          value: settings.retentionDays,
                          items: const [1, 7, 14, 30, 60, 90, 180, 365],
                          itemLabel: l10n.daysCount,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsCubit>().updateRetentionDays(
                                value,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  //Sync section
                  SettingsSectionGroupAccordion(
                    initiallyExpanded: false,
                    key: _sectionKeys[SettingsSection.sync.name],
                    icon: const HugeIcon(icon: HugeIcons.strokeRoundedFileSync),

                    title: l10n.sync.sentenceCase,
                    children: [
                      ProGateOverlay(
                        // badgeAlignment: Alignment.topRight,
                        badgeOffset: const Offset(12, -4),
                        child: SettingsSwitchItem(
                          title: l10n.autoSync.sentenceCase,
                          description: l10n.autoSyncDescription.sentenceCase,
                          value: settings.autoSync,
                          onChanged: (value) {
                            context.read<SettingsCubit>().updateAutoSync(
                              autoSync: value,
                            );
                          },
                        ),
                      ),

                      if (settings.autoSync)
                        SettingsDropdownItem<int>(
                          title: l10n.autoSyncInterval.sentenceCase,
                          description:
                              l10n.autoSyncIntervalDescription.sentenceCase,
                          value: settings.syncIntervalMinutes,
                          items: const [1, 5, 10, 15, 30, 60],
                          itemLabel: l10n.minutesCount,
                          onChanged: (value) {
                            if (value != null) {
                              context.read<SettingsCubit>().updateSyncInterval(
                                value,
                              );
                            }
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
}

/// Widget for the keyboard shortcuts section
class _KeyboardShortcutsSection extends StatefulWidget {
  const _KeyboardShortcutsSection({required this.settings});

  final UserSettings settings;

  @override
  State<_KeyboardShortcutsSection> createState() =>
      _KeyboardShortcutsSectionState();
}

class _KeyboardShortcutsSectionState extends State<_KeyboardShortcutsSection> {
  Future<void> _updateHotkey(ShortcutAction action, HotKey? hotkey) async {
    final hotkeyService = getIt<HotkeyManagerService>();
    final shortcuts = Map<String, String>.from(widget.settings.shortcuts);

    try {
      if (hotkey != null) {
        // Register the new hotkey
        await hotkeyService.registerHotkey(action, hotkey);
        shortcuts[action.key] = HotkeyUtils.hotkeyToString(hotkey);
      } else {
        // Unregister the hotkey
        await hotkeyService.unregisterHotkey(action);
        shortcuts.remove(action.key);
      }

      // Update settings
      if (mounted) {
        await context.read<SettingsCubit>().updateShortcuts(shortcuts);
      }
    } catch (e) {
      //revert changes in case of error
    }
  }

  Future<void> _resetToDefault(ShortcutAction action) async {
    HotKey? defaultHotkey;

    switch (action) {
      case ShortcutAction.toggleWindow:
        defaultHotkey = HotKey(
          key: PhysicalKeyboardKey.keyV,
          modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        );
      case ShortcutAction.toggleIncognito:
        defaultHotkey = HotKey(
          key: PhysicalKeyboardKey.keyI,
          modifiers: [HotKeyModifier.control, HotKeyModifier.shift],
        );
      case ShortcutAction.clearClipboard:
      case ShortcutAction.searchClipboard:
        // No default for these actions
        defaultHotkey = null;
    }

    await _updateHotkey(action, defaultHotkey);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        SettingsShortcutItem(
          title: l10n.toggleWindowShortcut,
          description: l10n.toggleWindowShortcutDescription,
          hotkey: HotkeyUtils.parseHotkeyString(
            widget.settings.shortcuts[ShortcutAction.toggleWindow.key],
          ),
          onChanged: (hotkey) =>
              _updateHotkey(ShortcutAction.toggleWindow, hotkey),
          onReset: () => _resetToDefault(ShortcutAction.toggleWindow),
        ),
        SettingsShortcutItem(
          title: l10n.toggleIncognitoShortcut,
          description: l10n.toggleIncognitoShortcutDescription.sentenceCase,
          hotkey: HotkeyUtils.parseHotkeyString(
            widget.settings.shortcuts[ShortcutAction.toggleIncognito.key],
          ),
          onChanged: (hotkey) =>
              _updateHotkey(ShortcutAction.toggleIncognito, hotkey),
          onReset: () => _resetToDefault(ShortcutAction.toggleIncognito),
        ),
      ],
    );
  }
}
