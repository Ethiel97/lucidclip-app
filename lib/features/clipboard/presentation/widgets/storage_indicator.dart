import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/theme.dart';

class StorageIndicator extends StatelessWidget {
  const StorageIndicator({required this.used, required this.total, super.key});

  final int used;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = used / total;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface2.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        spacing: AppSpacing.xxs,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$used / $total items',
            style: AppTextStyle.bodyXSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 6,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(color: Colors.white.withValues(alpha: 0.04)),
                      FractionallySizedBox(
                        widthFactor: ratio.clamp(0.0, 1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.primarySoft,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
