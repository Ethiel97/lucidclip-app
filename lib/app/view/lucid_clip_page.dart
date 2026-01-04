import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/routes/app_routes.gr.dart';
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
        BlocProvider(create: (_) => getIt<ClipboardDetailCubit>()),
        BlocProvider(create: (_) => getIt<SidebarCubit>()),
      ],
      child: Scaffold(
        body: AutoTabsRouter(
          routes: const [ClipboardRoute(), SnippetsRoute(), SettingsRoute()],
          builder: (context, child) {
            return Row(
              children: [
                const Sidebar(),
                const VerticalDivider(width: 1, thickness: .08),
                Expanded(child: child),
              ],
            );
          },
        ),
      ),
    );
  }
}
