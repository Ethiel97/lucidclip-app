import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:tinycolor2/tinycolor2.dart';

class AccessibilityPermissionDialog extends StatelessWidget {
  const AccessibilityPermissionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Dialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(AppSpacing.xlg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.toTinyColor().darken().color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedAccess,
                size: 18,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Title
            Text(
              l10n.accessibilityPermissionRequired,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),

            // Description
            Text(
              l10n.accessibilityPermissionDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xlg),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                      context
                          .read<AccessibilityCubit>()
                          .cancelPermissionRequest();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      side: BorderSide(color: colorScheme.outline),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      context.pop();
                      getIt<WindowController>().hide();
                      context.read<AccessibilityCubit>().grantPermission();
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      backgroundColor: colorScheme.primary,
                    ),
                    child: Text(l10n.grantPermission),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
