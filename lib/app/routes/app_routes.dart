import 'package:auto_route/auto_route.dart';
import 'package:lucid_clip/app/app.dart';
import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/features/auth/presentation/presentation.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter() {
    _authenticationGuard = AuthenticationGuard(
      isAuthenticated: () async {
        final authCubit = getIt<AuthCubit>();
        return authCubit.state.isAuthenticated;
      },
    );
  }

  late final AuthenticationGuard _authenticationGuard;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/login', page: LoginRoute.page),
    AutoRoute(
      path: '/',
      page: LucidClipRoute.page,
      children: [
        RedirectRoute(path: '', redirectTo: 'clipboard'),
        AutoRoute(path: 'clipboard', page: ClipboardRoute.page),
        AutoRoute(
          path: 'snippets',
          page: SnippetsRoute.page,
          guards: [_authenticationGuard],
        ),
        AutoRoute(
          path: 'account',
          page: AccountRoute.page,
          guards: [_authenticationGuard],
        ),
        AutoRoute(
          path: 'settings',
          page: SettingsRouterRoute.page,
          children: [
            AutoRoute(path: '', page: SettingsRoute.page),
            AutoRoute(
              path: 'ignored-apps',
              page: IgnoredAppsRoute.page,
              guards: [_authenticationGuard],
            ),
          ],
        ),
      ],
    ),
    AutoRoute(path: '/clipboard/edit', page: ClipboardEditRoute.page),
  ];
}
