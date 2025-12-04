class ClipboardItemTag {
  ClipboardItemTag({
    required this.clipboardItemId,
    required this.createdAt,
    required this.tagId,
    required this.updatedAt,
  });

  final String clipboardItemId;

  final DateTime createdAt;

  final String tagId;

  final DateTime updatedAt;

  ClipboardItemTag copyWith({
    String? clipboardItemId,
    DateTime? createdAt,
    String? tagId,
    DateTime? updatedAt,
  }) {
    return ClipboardItemTag(
      clipboardItemId: clipboardItemId ?? this.clipboardItemId,
      createdAt: createdAt ?? this.createdAt,
      tagId: tagId ?? this.tagId,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
