import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hugeicons/hugeicons.dart';

/// Aggressively cached image widget for clipboard thumbnails
/// Precaches decoded images to avoid main thread blocking during scroll
class CachedClipboardImage extends StatefulWidget {
  const CachedClipboardImage.memory({
    required this.bytes,
    this.width = 50,
    this.height = 50,
    super.key,
  }) : filePath = null,
       isMemory = true;

  const CachedClipboardImage.file({
    required this.filePath,
    this.width = 50,
    this.height = 50,
    super.key,
  }) : bytes = null,
       isMemory = false;

  final Uint8List? bytes;
  final String? filePath;
  final double width;
  final double height;
  final bool isMemory;

  @override
  State<CachedClipboardImage> createState() => _CachedClipboardImageState();
}

class _CachedClipboardImageState extends State<CachedClipboardImage> {
  ui.Image? _cachedImage;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _precacheImage();
  }

  @override
  void didUpdateWidget(CachedClipboardImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.isMemory && widget.bytes != oldWidget.bytes) ||
        (!widget.isMemory && widget.filePath != oldWidget.filePath)) {
      _cachedImage?.dispose();
      _cachedImage = null;
      _precacheImage();
    }
  }

  Future<void> _precacheImage() async {
    if (_isLoading || _cachedImage != null) return;

    setState(() => _isLoading = true);

    try {
      final Uint8List bytes;
      if (widget.isMemory) {
        bytes = widget.bytes!;
      } else {
        bytes = await File(widget.filePath!).readAsBytes();
      }

      final codec = await ui.instantiateImageCodec(
        bytes,
        // targetWidth: (widget.width * 100).toInt(), // 2x for retina
        // targetHeight: (widget.height * 2).toInt(),
      );

      final frame = await codec.getNextFrame();

      if (mounted) {
        setState(() {
          _cachedImage = frame.image;
          _isLoading = false;
        });
      } else {
        frame.image.dispose();
      }

      codec.dispose();
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cachedImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const HugeIcon(icon: HugeIcons.strokeRoundedImageNotFound01),
      );
    }

    if (_cachedImage == null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: RawImage(
        width: widget.width,
        image: _cachedImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
