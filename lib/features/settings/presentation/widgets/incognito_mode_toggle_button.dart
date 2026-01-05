import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/features/settings/presentation/cubit/cubit.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

// TODO(Ethiel97): SHOULD BE FOR PAID USERS ONLY
class IncognitoModeToggleButton extends StatelessWidget {
  const IncognitoModeToggleButton({super.key});

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
            context.read<SettingsCubit>().updateIncognitoMode(
              incognitoMode: !incognitoMode,
            );
          },
          icon: HugeIcon(
            icon: incognitoMode
                ? HugeIcons.strokeRoundedPlayCircle
                : HugeIcons.strokeRoundedPauseCircle,
            size: 22,
          ),
          label: Text(l10n.incognitoMode.sentenceCase),
        ),
      ),
    );
  }
}
