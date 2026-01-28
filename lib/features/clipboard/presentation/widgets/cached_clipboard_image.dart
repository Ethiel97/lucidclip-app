import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CachedClipboardImage extends StatelessWidget {
  const CachedClipboardImage.memory({
    required this.bytes,
    this.width,
    this.height,
    super.key,
  }) : filePath = null;

  const CachedClipboardImage.file({
    required this.filePath,
    this.width = 50,
    this.height = 50,
    super.key,
  }) : bytes = null;

  final Uint8List? bytes;
  final String? filePath;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final provider = bytes != null
        ? MemoryImage(bytes!)
        : FileImage(File(filePath!)) as ImageProvider;

    precacheImage(provider, context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image(
        image: provider,
        width: width,
        height: height,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.low,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => SizedBox(
          width: width,
          height: height,
          child: const HugeIcon(icon: HugeIcons.strokeRoundedImageNotFound01),
        ),
      ),
    );
  }
}
