import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/constants/constants.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/widgets/safe_bloc_listener.dart';
import 'package:lucid_clip/features/onboarding/onboarding.dart';
import 'package:lucid_clip/features/settings/settings.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';
import 'package:toastification/toastification.dart';

class OnboardingListener extends StatelessWidget {
  const OnboardingListener({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) =>
      SafeBlocListener<OnboardingCubit, OnboardingState>(
        listenWhen: (previous, current) =>
            previous.showToggleWindowShortcutTipNow !=
                current.showToggleWindowShortcutTipNow &&
            current.showToggleWindowShortcutTipNow,
        listener: (context, state) {
          final l10n = context.l10n;
          final textTheme = Theme.of(context).textTheme;
          final colorScheme = Theme.of(context).colorScheme;

          final settingsCubit = context.read<SettingsCubit>();

          final userToggleWindowShortcut =
              settingsCubit.state.shortcuts[ShortcutAction.toggleWindow.key] ??
              AppConstants.toggleWindowShortcut;

          toastification.show(
            pauseOnHover: true,
            context: context,
            title: Text(l10n.quickAccess.sentenceCase),
            description: Text(
              l10n.toggleWindowQuickAccess('`$userToggleWindowShortcut`'),
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary),
            ),
            autoCloseDuration: tipAutoCloseDuration,
            alignment: Alignment.topRight,
            style: ToastificationStyle.flat,
          );

          context.read<OnboardingCubit>().markToggleWindowShortcutTipSeen();
        },
        child: child,
      );
}
