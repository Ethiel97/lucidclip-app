import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/theme/theme.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';

@RoutePage()
class LucidClipPage extends StatelessWidget {
  const LucidClipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ClipboardCubit>()),
        BlocProvider(create: (_) => getIt<SearchCubit>()),
        // BlocProvider(create: (_) => getIt<SettingsCubit>()),
        BlocProvider(create: (_) => getIt<ClipboardDetailCubit>()),
      ],
      child: const Scaffold(
        body: Row(
          children: [
            Sidebar(),
            VerticalDivider(width: 1, thickness: .05),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.xlg,
                  AppSpacing.lg,
                  AppSpacing.xlg,
                  AppSpacing.lg,
                ),
                child: AutoRouter(),
              ),
            ),
          ],
        ),
      ),
    );

  }
}
