import 'package:flutter/material.dart';

class SnackbarContent extends StatelessWidget {
  const SnackbarContent({required this.message, this.title, super.key});

  final String? title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: textTheme.titleMedium),
          const SizedBox(height: 8),
        ],

        Text(message, style: textTheme.bodySmall),
      ],
    );
  }
}
