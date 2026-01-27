import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lucid_clip/features/account/presentation/view/account_view.dart';

@RoutePage()
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) => const AccountView();
}
