import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/routes/app_routes.gr.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';

import 'package:lucid_clip/l10n/l10n.dart';
import 'package:recase/recase.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: AppSpacing.md,
      children: [
        const Expanded(child: SearchField()),
        const ClipboardItemTypeFilter(),
        const IncognitoModeToggleButton(),
        FilledButton.icon(
          onPressed: () {
            // context.router.root.
            // navigate to login page using named route with auto_route
            context.router.root.pushPath(LoginRoute.name);
          },
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedDatabaseSync),
          label: Text(l10n.sync.sentenceCase),
        ),
      ],
    );
  }
}
