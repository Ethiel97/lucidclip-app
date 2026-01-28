import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/services/syntax_highlighter/syntax_highlighter.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

extension ClipboardItemIconExtension on ClipboardItem {
  Future<SourceApp?> getSourceAppWithIcon() async {
    final app = sourceApp;
    if (app == null) return null;

    final iconService = getIt<SourceAppIconService>();
    return iconService.enrichWithIcon(app);
  }

  Future<ClipboardItem> withEnrichedSourceApp() async {
    final app = await getSourceAppWithIcon();
    if (app == null) return this;

    final metadata = Map<String, dynamic>.from(this.metadata);

    metadata['source_app'] = SourceAppModel.fromEntity(app).toJsonWithIcon();

    // print("Metadata after enrichment: $metadata");

    return copyWith(metadata: metadata);
  }
}

extension ClipboardItemsIconExtension on List<ClipboardItem> {
  Future<List<ClipboardItem>> withEnrichedSourceApps() async {
    return Future.wait(map((item) => item.withEnrichedSourceApp()));
  }
}

// Cache for code detection results to avoid expensive re-computation
final _codeDetectionCache = <String, bool>{};
final _languageDetectionCache = <String, String?>{};

extension ClipboardItemCodeExtension on ClipboardItem {
  /// Check if the clipboard item content is code
  bool get isCode {
    // Only check text-type items
    if (!type.isText && !type.isUrl) return false;
    
    // Check cache first
    final cacheKey = contentHash;
    if (_codeDetectionCache.containsKey(cacheKey)) {
      return _codeDetectionCache[cacheKey]!;
    }
    
    try {
      final syntaxHighlighter = getIt<SyntaxHighlighter>();
      final result = syntaxHighlighter.isCode(content);
      _codeDetectionCache[cacheKey] = result;
      return result;
    } catch (e) {
      _codeDetectionCache[cacheKey] = false;
      return false;
    }
  }
  
  /// Get the detected programming language of the content
  String? get detectedLanguage {
    if (!isCode) return null;
    
    // Check cache first
    final cacheKey = contentHash;
    if (_languageDetectionCache.containsKey(cacheKey)) {
      return _languageDetectionCache[cacheKey];
    }
    
    try {
      final syntaxHighlighter = getIt<SyntaxHighlighter>();
      final result = syntaxHighlighter.detectLanguage(content);
      _languageDetectionCache[cacheKey] = result;
      return result;
    } catch (e) {
      _languageDetectionCache[cacheKey] = null;
      return null;
    }
  }
}
