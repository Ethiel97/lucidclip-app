import 'package:flutter/material.dart';
import 'package:lucid_clip/features/clipboard/presentation/presentation.dart';

class ClipboardPage extends StatelessWidget {
  const ClipboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: ClipboardView(),
          ),
        ],
      ),
    );
  }
}
