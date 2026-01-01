import 'package:lucid_clip/core/utils/generic_mapper.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

/// Mapper utilities between domain entities and data models
/// for the clipboard feature.
///
/// Provides conversions used by repositories and by state serialization.
class ClipboardMapper {
  // --- ClipboardItem ---
  static ClipboardItemModel itemToModel(ClipboardItem e) {
    return ClipboardItemModel(
      content: e.content,
      contentHash: e.contentHash,
      createdAt: e.createdAt,
      filePaths: e.filePaths,
      htmlContent: e.htmlContent,
      id: e.id,
      imageBytes: e.imageBytes,
      isPinned: e.isPinned,
      isSnippet: e.isSnippet,
      metadata: e.metadata,
      type: ClipboardItemTypeModel.values[e.type.index],
      updatedAt: e.updatedAt,
      userId: e.userId,
    );
  }

  static ClipboardItem itemFromModel(ClipboardItemModel m) => m.toEntity();

  static List<Map<String, dynamic>>? itemsToJson(List<ClipboardItem>? items) =>
      toJsonList<ClipboardItem>(items, (e) => itemToModel(e).toJson());

  static List<ClipboardItem>? itemsFromJson(List<dynamic>? json) =>
      fromJsonList<ClipboardItem>(
        json,
        (m) => ClipboardItemModel.fromJson(m).toEntity(),
      );

  // --- ClipboardHistory ---
  static ClipboardHistoryModel historyToModel(ClipboardHistory h) {
    return ClipboardHistoryModel(
      action: ClipboardActionModel.values[h.action.index],
      clipboardItemId: h.clipboardItemId,
      createdAt: h.createdAt,
      id: h.id,
      updatedAt: h.updatedAt,
      userId: h.userId,
    );
  }

  static ClipboardHistory historyFromModel(ClipboardHistoryModel m) =>
      m.toEntity();

  static List<Map<String, dynamic>>? historyToJson(
    List<ClipboardHistory>? history,
  ) =>
      toJsonList<ClipboardHistory>(history, (h) => historyToModel(h).toJson());

  static List<ClipboardHistory>? historyFromJson(List<dynamic>? json) =>
      fromJsonList<ClipboardHistory>(
        json,
        (m) => ClipboardHistoryModel.fromJson(m).toEntity(),
      );

  // --- ClipboardItemTag ---
  static ClipboardItemTagModel clipboardItemTagToModel(ClipboardItemTag t) {
    return ClipboardItemTagModel(
      clipboardItemId: t.clipboardItemId,
      createdAt: t.createdAt,
      tagId: t.tagId,
      updatedAt: t.updatedAt,
    );
  }

  static ClipboardItemTag clipboardItemFromModel(ClipboardItemTagModel m) =>
      m.toEntity();

  static List<Map<String, dynamic>>? clipboardItemTagsToJson(
    List<ClipboardItemTag>? tags,
  ) =>
      toJsonList<ClipboardItemTag>(
        tags,
        (t) => clipboardItemTagToModel(t).toJson(),
      );

  static List<ClipboardItemTag>? clipboardItemTagsFromJson(
    List<dynamic>? json,
  ) =>
      fromJsonList<ClipboardItemTag>(
        json,
        (m) => ClipboardItemTagModel.fromJson(m).toEntity(),
      );

  // --- Tag ---
  static TagModel tagToModel(Tag t) {
    return TagModel(
      color: t.color,
      createdAt: t.createdAt,
      id: t.id,
      name: t.name,
      updatedAt: t.updatedAt,
      userId: t.userId,
    );
  }

  static Tag tagFromModel(TagModel m) => m.toEntity();

  static List<Map<String, dynamic>>? tagsToJson(List<Tag>? tags) =>
      toJsonList<Tag>(tags, (t) => tagToModel(t).toJson());

  static List<Tag>? tagsFromJson(List<dynamic>? json) => fromJsonList<Tag>(
        json,
        (m) => TagModel.fromJson(m).toEntity(),
      );
}
