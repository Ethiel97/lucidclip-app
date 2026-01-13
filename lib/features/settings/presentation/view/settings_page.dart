import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:lucid_clip/features/settings/presentation/presentation.dart';

enum SettingsSection { usage, appearance, sync, clipboard, shortcuts, about }

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, @queryParam this.section = 'usage'});

  final String section;

  @override
  Widget build(BuildContext context) => SettingsView(section: section);
}
