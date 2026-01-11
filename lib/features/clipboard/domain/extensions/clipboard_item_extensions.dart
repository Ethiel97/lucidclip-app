import 'package:lucid_clip/core/di/di.dart';
import 'package:lucid_clip/core/platform/source_app/source_app.dart';
import 'package:lucid_clip/core/services/services.dart';
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
