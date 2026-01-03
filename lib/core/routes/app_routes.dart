import 'package:auto_route/auto_route.dart';
import 'package:lucid_clip/core/routes/app_routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: LucidClipRoute.page,
      children: [
        RedirectRoute(path: '', redirectTo: 'clipboard'),
        AutoRoute(path: 'clipboard', page: ClipboardRoute.page),
        AutoRoute(path: 'snippets', page: SnippetsRoute.page),
        AutoRoute(path: 'settings', page: SettingsRoute.page),
      ],
    ),
    // TODO(Ethiel97): Add auth routes
    // AutoRoute(path: '/login', page: LoginRoute.page),
  ];
}
