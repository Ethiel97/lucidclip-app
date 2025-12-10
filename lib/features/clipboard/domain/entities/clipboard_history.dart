typedef ClipboardHistories = List<ClipboardHistory>;

class ClipboardHistory {
  ClipboardHistory({
    required this.action,
    required this.clipboardItemId,
    required this.createdAt,
    required this.id,
    required this.updatedAt,
    required this.userId,
  });

  final ClipboardAction action;

  final String clipboardItemId;

  final DateTime createdAt;

  final String id;

  final DateTime updatedAt;

  final String userId;

  ClipboardHistory copyWith({
    ClipboardAction? action,
    String? clipboardItemId,
    DateTime? createdAt,
    String? id,
    DateTime? updatedAt,
    String? userId,
  }) {
    return ClipboardHistory(
      action: action ?? this.action,
      clipboardItemId: clipboardItemId ?? this.clipboardItemId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }

  Map<String, String> toMap() {
    return {
      'action': action.name,
      'clipboardItemId': clipboardItemId,
      'createdAt': createdAt.toIso8601String(),
      'id': id,
      'updatedAt': updatedAt.toIso8601String(),
      'userId': userId,
    };
  }
}

enum ClipboardAction {
  copy,
  paste,
  delete,
  edit;

  bool get isCopy => this == ClipboardAction.copy;

  bool get isPaste => this == ClipboardAction.paste;

  bool get isDelete => this == ClipboardAction.delete;

  bool get isEdit => this == ClipboardAction.edit;
}
