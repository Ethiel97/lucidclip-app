import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart' hide ClipboardContentType;
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/base_clipboard_manager.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:pasteboard/pasteboard.dart';

@LazySingleton(as: BaseClipboardManager)
class FlutterClipboardManager implements BaseClipboardManager {
  FlutterClipboardManager({required this.sourceAppProvider});

  Timer? _pollingTimer;
  String? _lastContentHash;
  final _controller = StreamController<ClipboardData>.broadcast();
  final SourceAppProvider sourceAppProvider;

  @override
  @postConstruct
  void initialize() {
    _seedLastContent();
    _startPolling();
  }

  Future<void> _seedLastContent() async {
    try {
      final current = await getClipboardContent();
      if (current != null) {
        _lastContentHash = current.contentHash ?? current.computedContentHash;
      }
    } catch (_) {
      // ignore errors during seeding
    }
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      BaseClipboardManager.clipboardManagerPollingInterval,
      (_) => _checkClipboardChange(),
    );
  }

  Future<void> _checkClipboardChange() async {
    try {
      /*if (_isChecking) return;
      _isChecking = true;*/
      final content = await getClipboardContent();
      if (content != null) {
        final currentHash = content.contentHash ?? content.computedContentHash;
        if (currentHash != _lastContentHash) {
          _lastContentHash = currentHash;
          _controller.add(content);
        }
      }
    } catch (e, stack) {
      log(
        'Error checking clipboard change',
        error: e,
        name: 'FlutterClipboardManager',
        stackTrace: stack,
      );
    } finally {
      // _isChecking = false;
    }
  }

  // TODO(Ethiel97): handle multiple files in clipboard
  @override
  Future<ClipboardData?> getClipboardContent() async {
    final sourceApp = await sourceAppProvider.getFrontmostApp();
    final files = await Pasteboard.files();
    final timestamp = DateTime.now().toUtc();

    final metadata = <String, dynamic>{
      if (sourceApp != null)
        'source_app': SourceAppModel.fromEntity(sourceApp).toJsonWithIcon(),
    };

    if (files.isNotEmpty) {
      for (final file in files) {
        if (file.isNotEmpty) {
          final clipboardData = ClipboardData(
            type: ClipboardContentType.file,
            filePath: file,
            text: file,
            timestamp: timestamp,
          );
          return clipboardData.copyWith(
            contentHash: clipboardData.computedContentHash,
            metadata: metadata,
          );
        }
      }
    }

    // 2. Vérifier les images
    final image = await Pasteboard.image;
    if (image != null && image.isNotEmpty) {
      final clipboardData = ClipboardData(
        type: ClipboardContentType.image,
        imageBytes: Uint8List.fromList(image),
        timestamp: timestamp,
      );

      return clipboardData.copyWith(
        contentHash: clipboardData.computedContentHash,
        metadata: metadata,
      );
    }

    // 3. Vérifier le HTML
    final html = await Pasteboard.html;
    if (html != null && html.isNotEmpty) {
      final clipboardData = ClipboardData(
        type: ClipboardContentType.html,
        text: html,
        html: html,
        timestamp: timestamp,
      );
      return clipboardData.copyWith(
        contentHash: clipboardData.computedContentHash,
        metadata: metadata,
      );
    }

    // 4. Vérifier le texte
    final text = await Pasteboard.text;
    if (text != null && text.isNotEmpty) {
      final type = _detectContentType(text);
      final clipboardData = ClipboardData(
        type: type,
        text: text,
        timestamp: timestamp,
      );

      return clipboardData.copyWith(
        contentHash: clipboardData.computedContentHash,
        metadata: metadata,
      );
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
          await Pasteboard.writeImage(bytes);
        }

      case ClipboardContentType.file:
        if (data.filePath != null && data.filePath!.isNotEmpty) {
          await Pasteboard.writeFiles([data.filePath!]);
        }

      case ClipboardContentType.html:
        if (data.html != null) {
          Pasteboard.writeText(data.html!);
        }

      case ClipboardContentType.unknown:
        break;
    }

    _lastContentHash = data.contentHash ?? data.computedContentHash;
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
    _lastContentHash = null;
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
      if (filePath != null) filePath,
    ];
    return ContentHasher.hashOfParts(parts);
  }
}
