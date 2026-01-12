import 'package:auto_route/auto_route.dart';
import 'package:lucid_clip/app/app.dart';

class AuthenticationGuard extends AutoRouteGuard {
  /// {@macro AuthenticationGuard}
  /// This guard checks if the user is authenticated
  /// before allowing access to certain routes.
  AuthenticationGuard({required this.isAuthenticated});

  /// A function that checks whether the user is authenticated.
  final Future<bool> Function() isAuthenticated;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    if (await isAuthenticated()) {
      // If the user is authenticated, continue to the requested route.
      resolver.next();
    } else {
      // If the user is not authenticated, redirect to the login page.
      await router.navigate(const LoginRoute());
    }
  }
}
