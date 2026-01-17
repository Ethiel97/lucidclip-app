import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lucid_clip/features/auth/presentation/presentation.dart';

/// Login page with BLoC provider
@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}
