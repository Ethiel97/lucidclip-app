import 'dart:async';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart' hide ClipboardContentType;
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/base_clipboard_manager.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:pasteboard/pasteboard.dart';

@LazySingleton(as: BaseClipboardManager)
class FlutterClipboardManager implements BaseClipboardManager {
  Timer? _pollingTimer;
  String? _lastContent;
  final _controller = StreamController<ClipboardData>.broadcast();

  @override
  Future<void> initialize() async {
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      BaseClipboardManager.clipboardPollingInterval,
      (_) => _checkClipboardChange(),
    );
  }

  Future<void> _checkClipboardChange() async {
    final content = await getClipboardContent();
    if (content != null && content.text != _lastContent) {
      _lastContent = content.text;
      _controller.add(content);
    }
  }

  @override
  Future<ClipboardData?> getClipboardContent() async {
    // 1. Vérifier les fichiers d'abord
    final files = await Pasteboard.files();
    if (files.isNotEmpty) {
      final clipboardData = ClipboardData(
        type: ClipboardContentType.file,
        filePaths: files,
        timestamp: DateTime.now(),
      );
      clipboardData.contentHash = clipboardData.computedContentHash;
      return clipboardData;
    }

    // 2. Vérifier les images
    final image = await Pasteboard.image;
    if (image != null && image.isNotEmpty) {
      final clipboardData = ClipboardData(
        type: ClipboardContentType.image,
        imageBytes: Uint8List.fromList(image),
        timestamp: DateTime.now(),
      );

      clipboardData.contentHash = clipboardData.computedContentHash;
      return clipboardData;
    }

    // 3. Vérifier le HTML
    final html = await Pasteboard.html;
    if (html != null && html.isNotEmpty) {
      final clipboardData = ClipboardData(
        type: ClipboardContentType.html,
        html: html,
        timestamp: DateTime.now(),
      );
      clipboardData.contentHash = clipboardData.computedContentHash;
      return clipboardData;
    }

    // 4. Vérifier le texte
    final text = await Pasteboard.text;
    if (text != null && text.isNotEmpty) {
      final type = _detectContentType(text);
      final clipboardData = ClipboardData(
        type: type,
        text: text,
        timestamp: DateTime.now(),
      );

      clipboardData.contentHash = clipboardData.computedContentHash;
      return clipboardData;
    }

    return null;
  }

  ClipboardContentType _detectContentType(String text) {
    if (text.isUrl) {
      return ClipboardContentType.url;
    }

    return ClipboardContentType.text;
  }

  @override
  Future<void> setClipboardContent(ClipboardData data) async {
    switch (data.type) {
      case ClipboardContentType.text:
      case ClipboardContentType.url:
        if (data.text != null) {
          Pasteboard.writeText(data.text!);
        }

      case ClipboardContentType.image:
        if (data.imageBytes != null) {
          final bytes = Uint8List.fromList(data.imageBytes!);
          await Pasteboard.writeImage(
            bytes,
          );
        }

      case ClipboardContentType.file:
        if (data.filePaths != null && data.filePaths!.isNotEmpty) {
          await Pasteboard.writeFiles(data.filePaths!);
        }

      case ClipboardContentType.html:
        if (data.html != null) {
          Pasteboard.writeText(data.html!);
        }

      case ClipboardContentType.unknown:
        // Ne rien faire pour les types inconnus
        break;
    }

    _lastContent = data.text;
  }

  @override
  Stream<ClipboardData> watchClipboard() => _controller.stream;

  @override
  Future<bool> hasContent() async {
    return FlutterClipboard.hasData();
  }

  @override
  Future<void> clear() async {
    await FlutterClipboard.clear();
    _lastContent = null;
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    _pollingTimer?.cancel();
    await _controller.close();
  }

  @override
  Future<int> getSize() {
    return FlutterClipboard.getDataSize();
  }
}

extension ClipboardDataHashExt on ClipboardData {
  String get computedContentHash {
    final parts = <Object?>[
      type.name,
      text,
      html,
      if (imageBytes != null) imageBytes,
      if (filePaths != null) filePaths,
      timestamp?.toIso8601String(),
    ];
    return ContentHasher.hashOfParts(parts);
  }
}
