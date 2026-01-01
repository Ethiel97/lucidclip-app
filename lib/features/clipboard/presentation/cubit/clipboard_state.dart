part of 'clipboard_cubit.dart';

class ClipboardState extends Equatable {
  const ClipboardState({
    this.clipboardHistory = const ValueWrapper(value: []),
    this.clipboardItems = const ValueWrapper(value: []),
    this.clipboardItemTags = const ValueWrapper(value: []),
    this.currentClipboardData,
    // this.localClipboardItems = const [],
    this.tags = const ValueWrapper(value: []),
  });

  factory ClipboardState.fromJson(Map<String, dynamic> json) {
    return ClipboardState(
      clipboardHistory: ValueWrapper(
        value:
            ClipboardMapper.historyFromJson(
              json['clipboardHistory'] as List<dynamic>?,
            ) ??
            [],
      ),
      clipboardItems: ValueWrapper(
        value:
            ClipboardMapper.itemsFromJson(
              json['clipboardItems'] as List<dynamic>?,
            ) ??
            [],
      ),
      tags: ValueWrapper(
        value:
            ClipboardMapper.tagsFromJson(json['tags'] as List<dynamic>?) ?? [],
      ),
      clipboardItemTags: ValueWrapper(
        value:
            ClipboardMapper.clipboardItemTagsFromJson(
              json['clipboardItemTags'] as List<dynamic>?,
            ) ??
            [],
      ),
    );
  }

  final ValueWrapper<ClipboardHistories> clipboardHistory;
  final ValueWrapper<ClipboardItems> clipboardItems;

  final ClipboardData? currentClipboardData;

  final ValueWrapper<ClipboardItemTags> clipboardItemTags;

  // final List<ClipboardData> localClipboardItems;
  final ValueWrapper<Tags> tags;

  ClipboardState copyWith({
    ValueWrapper<ClipboardHistories>? clipboardHistory,
    ValueWrapper<ClipboardItems>? clipboardItems,
    ClipboardData? currentClipboardData,
    ValueWrapper<ClipboardItemTags>? clipboardItemTags,
    List<ClipboardData>? localClipboardItems,
    ValueWrapper<Tags>? tags,
  }) {
    return ClipboardState(
      clipboardHistory: clipboardHistory ?? this.clipboardHistory,
      clipboardItems: clipboardItems ?? this.clipboardItems,
      currentClipboardData: currentClipboardData ?? this.currentClipboardData,
      clipboardItemTags: clipboardItemTags ?? this.clipboardItemTags,
      // localClipboardItems: localClipboardItems ?? this.localClipboardItems,
      tags: tags ?? this.tags,
    );
  }

  //toJson and fromJson methods for HydratedCubit
  Map<String, dynamic> toJson() {
    return {
      'clipboardHistory': ClipboardMapper.historyToJson(clipboardHistory.value),
      'clipboardItems': ClipboardMapper.itemsToJson(clipboardItems.value),
      'tags': ClipboardMapper.tagsToJson(tags.value),
      'clipboardItemTags': ClipboardMapper.clipboardItemTagsToJson(
        clipboardItemTags.value,
      ),
    };
  }

  ClipboardItems get unPinnedItems => (clipboardItems.value ?? [])
      .where((item) => !item.isPinned)
      .toList(growable: false);

  ClipboardItems get pinnedItems => (clipboardItems.value ?? [])
      .where((item) => item.isPinned)
      .toList(growable: false);

  @override
  List<Object?> get props => [
    clipboardHistory,
    clipboardItems,
    currentClipboardData,
    clipboardItemTags,
    // localClipboardItems,
    tags,
  ];
}
