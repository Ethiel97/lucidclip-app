import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/core/widgets/widgets.dart';
import 'package:lucid_clip/l10n/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:recase/recase.dart';
import 'package:tinycolor2/tinycolor2.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppDialog extends StatefulWidget {
  const AboutAppDialog({super.key});

  @override
  State<AboutAppDialog> createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<AboutAppDialog> {
  PackageInfo? _packageInfo;
  bool _isLoading = true;

  String _versionInfo = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_versionInfo.isEmpty && _packageInfo != null) {
      setState(() {
        _versionInfo = context.l10n.versionInfo(
          _packageInfo!.version,
          _packageInfo!.buildNumber,
        );
      });
    }
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = info;
          _isLoading = false;
          _versionInfo = context.l10n.versionInfo(
            _packageInfo!.version,
            _packageInfo!.buildNumber,
          );
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.couldNotOpenLink(urlString)),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.errorOpeningLink.sentenceCase),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentYear = DateTime.now().year.toString();

    return Dialog(
      backgroundColor: colorScheme.surface,
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 480),
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(AppSpacing.xlg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer
                      .toTinyColor()
                      .darken(5)
                      .color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                  size: 32,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Title
              Text(
                l10n.aboutLucidClip,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),

              // Tagline
              Text(
                l10n.appTagLine,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),

              // Version Info
              if (_isLoading)
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (_packageInfo != null)
                CopyableContent(
                  value: _versionInfo,
                  title: l10n.appBuildInfo,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.versionInfo(
                        _packageInfo!.version,
                        _packageInfo!.buildNumber,
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              // Links
              _LinkButton(
                icon: HugeIcons.strokeRoundedGlobe,
                label: l10n.website,
                onTap: () => _launchUrl('https://lucidclip.app'),
              ),
              const SizedBox(height: AppSpacing.sm),
              _LinkButton(
                icon: HugeIcons.strokeRoundedShield01,
                label: l10n.privacyPolicy,
                onTap: () => _launchUrl('https://lucidclip.app/privacy'),
              ),
              const SizedBox(height: AppSpacing.md),

              // Copyright
              Text(
                l10n.copyright(currentYear),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xlg),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.pop(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    backgroundColor: colorScheme.primary,
                  ),
                  child: Text(l10n.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final List<List<dynamic>> icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            HugeIcon(icon: icon, size: 18, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            HugeIcon(
              icon: HugeIcons.strokeRoundedArrowRight01,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
