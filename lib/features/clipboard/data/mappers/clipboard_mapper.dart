import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/utils/utils.dart';
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
      deletedAt: e.deletedAt,
      filePath: e.filePath,
      htmlContent: e.htmlContent,
      id: e.id,
      imageBytes: e.imageBytes,
      isPinned: e.isPinned,
      isSnippet: e.isSnippet,
      metadata: e.metadata,
      type: ClipboardItemTypeModel.values[e.type.index],
      updatedAt: e.updatedAt,
      userId: e.userId,
      syncStatus: SyncStatusModel.values[e.syncStatus.index],
      usageCount: e.usageCount,
      lastUsedAt: e.lastUsedAt,
      version: e.version,
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
  static ClipboardOutboxModel historyToModel(ClipboardOutbox h) {
    return ClipboardOutboxModel(
      operationType: ClipboardOperationTypeModel.values[h.operationType.index],
      entityId: h.entityId,
      createdAt: h.createdAt,
      id: h.id,
      userId: h.userId,
      deviceId: h.deviceId,
      lastError: h.lastError,
      payload: h.payload,
      retryCount: h.retryCount,
      sentAt: h.sentAt,
      status: ClipboardOutboxStatusModel.values[h.status.index],
    );
  }

  static ClipboardOutbox historyFromModel(ClipboardOutboxModel m) =>
      m.toEntity();

  static List<Map<String, dynamic>>? historyToJson(
    List<ClipboardOutbox>? history,
  ) => toJsonList<ClipboardOutbox>(history, (h) => historyToModel(h).toJson());

  static List<ClipboardOutbox>? historyFromJson(List<dynamic>? json) =>
      fromJsonList<ClipboardOutbox>(
        json,
        (m) => ClipboardOutboxModel.fromJson(m).toEntity(),
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
  ) => toJsonList<ClipboardItemTag>(
    tags,
    (t) => clipboardItemTagToModel(t).toJson(),
  );

  static List<ClipboardItemTag>? clipboardItemTagsFromJson(
    List<dynamic>? json,
  ) => fromJsonList<ClipboardItemTag>(
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

  static List<Tag>? tagsFromJson(List<dynamic>? json) =>
      fromJsonList<Tag>(json, (m) => TagModel.fromJson(m).toEntity());
}

extension ClipboardDataMapper on ClipboardData {
  ClipboardItem toDomain({required String userId}) {
    final now = DateTime.now().toUtc();
    return ClipboardItem(
      id: IdGenerator.generate(),
      content: text ?? '',
      contentHash: contentHash ?? '',
      type: clipboardItemType,
      userId: userId,
      createdAt: timestamp ?? now,
      updatedAt: now,
      imageBytes: imageBytes,
      filePath: filePath,
      htmlContent: html,
      metadata: metadata ?? {},
      syncStatus: SyncStatus.pending,
    );
  }
}

extension ClipboardItemMapper on ClipboardItem {
  // TODO(Ethiel97): (generate new content hash)
  ClipboardData toInfrastructure() {
    return ClipboardData(
      type: contentType,
      text: content,
      contentHash: contentHash,
      timestamp: createdAt,
      html: htmlContent,
      filePath: filePath,
      imageBytes: imageBytes,
      metadata: metadata,
    );
  }
}
