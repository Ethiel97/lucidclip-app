import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

// TODO(Ethiel97): SHOULD BE FOR PAID USERS ONLY
class IncognitoModeToggleButton extends StatelessWidget {
  const IncognitoModeToggleButton({super.key});

  void _showPrivateSessionDialog(BuildContext context) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.startPrivateSession.sentenceCase),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.fifteenMinutes.sentenceCase),
              onTap: () {
                Navigator.of(dialogContext).pop();
                context.read<SettingsCubit>().startPrivateSession(
                      durationMinutes: 15,
                    );
              },
            ),
            ListTile(
              title: Text(l10n.oneHour.sentenceCase),
              onTap: () {
                Navigator.of(dialogContext).pop();
                context.read<SettingsCubit>().startPrivateSession(
                      durationMinutes: 60,
                    );
              },
            ),
            ListTile(
              title: Text(l10n.untilDisabled.sentenceCase),
              onTap: () {
                Navigator.of(dialogContext).pop();
                context.read<SettingsCubit>().startPrivateSession(
                      durationMinutes: null,
                    );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocSelector<SettingsCubit, SettingsState, bool>(
      selector: (state) {
        return state.incognitoMode;
      },
      builder: (context, incognitoMode) => FilledButton(
        onPressed: () {},
        child: FilledButton.icon(
          onPressed: () {
            if (incognitoMode) {
              context.read<SettingsCubit>().updateIncognitoMode(
                    incognitoMode: false,
                  );
            } else {
              _showPrivateSessionDialog(context);
            }
          },
          icon: HugeIcon(
            icon: incognitoMode
                ? HugeIcons.strokeRoundedPlayCircle
                : HugeIcons.strokeRoundedPauseCircle,
            size: 22,
          ),
          label: Text(
            incognitoMode
                ? l10n.resumeTracking.sentenceCase
                : l10n.pauseTracking.sentenceCase,
          ),
        ),
      ),
    );
  }
}
