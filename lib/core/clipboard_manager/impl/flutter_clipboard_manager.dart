import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:clipboard/clipboard.dart' hide ClipboardContentType;
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/base_clipboard_manager.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/platform/platform.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:pasteboard/pasteboard.dart';

@LazySingleton(as: BaseClipboardManager)
class FlutterClipboardManager extends ClipboardListener
    implements BaseClipboardManager {
  FlutterClipboardManager({required this.sourceAppProvider});

  bool _isChecking = false;
  String? _lastContentHash;
  final _controller = StreamController<ClipboardData>.broadcast();
  final SourceAppProvider sourceAppProvider;

  @override
  @postConstruct
  void initialize() {
    clipboardWatcher.addListener(this);
    _seedLastContent();
    _startListening();
  }

  @override
  Future<void> onClipboardChanged() async {
    if (_isChecking) return;
    await _checkClipboardChange();
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

  void _startListening() {
    clipboardWatcher.start();
  }

  Future<void> _checkClipboardChange() async {
    if (_isChecking) return;
    _isChecking = true;

    try {
      final content = await getClipboardContent();

      if (content == null) {
        return;
      }

      final currentHash = content.contentHash ?? content.computedContentHash;

      if (currentHash != _lastContentHash) {
        _lastContentHash = currentHash;
        _controller.add(content);
      }
    } catch (e, stack) {
      log(
        'Error checking clipboard change',
        error: e,
        name: 'FlutterClipboardManager',
        stackTrace: stack,
      );
    } finally {
      _isChecking = false;
    }
  }

  @override
  Future<ClipboardData?> getClipboardContent() async {
    final timestamp = DateTime.now().toUtc();
    ClipboardData? data;

    final files = await Pasteboard.files();
    if (files.isNotEmpty) {
      final file = files.firstWhere((f) => f.isNotEmpty, orElse: () => '');
      if (file.isNotEmpty) {
        data = ClipboardData(
          type: ClipboardContentType.file,
          filePath: file,
          text: file,
          timestamp: timestamp,
        );
      }
    }

    if (data == null) {
      final image = await Pasteboard.image;
      if (image != null && image.isNotEmpty) {
        data = ClipboardData(
          type: ClipboardContentType.image,
          imageBytes: Uint8List.fromList(image),
          timestamp: timestamp,
        );
      }
    }

    if (data == null) {
      final html = await Pasteboard.html;
      if (html != null && html.isNotEmpty) {
        data = ClipboardData(
          type: ClipboardContentType.html,
          text: html,
          html: html,
          timestamp: timestamp,
        );
      }
    }

    if (data == null) {
      final text = await Pasteboard.text;
      if (text != null && text.isNotEmpty) {
        data = ClipboardData(
          type: _detectContentType(text),
          text: text,
          timestamp: timestamp,
        );
      }
    }

    if (data == null) return null;

    var metadata = const <String, dynamic>{};
    try {
      final sourceApp = await sourceAppProvider.getFrontmostApp().timeout(
        const Duration(milliseconds: sourceAppProviderTimeoutMs),
      );
      if (sourceApp != null) {
        metadata = {
          'source_app': SourceAppModel.fromEntity(sourceApp).toJsonWithIcon(),
        };
      }
    } catch (e, stack) {
      log(
        'Error getting source app: $e at $stack',
        name: 'FlutterClipboardManager.getClipboardContent',
        error: e,
        stackTrace: stack,
      );
    }

    final withHash = data.copyWith(contentHash: data.computedContentHash);
    return withHash.copyWith(metadata: metadata);
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
    await clipboardWatcher.stop();
    clipboardWatcher.removeListener(this);

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
