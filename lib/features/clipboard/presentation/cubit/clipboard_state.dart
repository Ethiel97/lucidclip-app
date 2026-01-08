part of 'clipboard_cubit.dart';

class ClipboardState extends Equatable {
  const ClipboardState({
    this.clipboardHistory = const ValueWrapper(value: []),
    this.clipboardItems = const ValueWrapper(value: []),
    this.clipboardItemTags = const ValueWrapper(value: []),
    this.excludeAppResult = const ValueWrapper(value: ''),
    this.includeAppResult = const ValueWrapper(value: ''),
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
      excludeAppResult: ValueWrapper(
        value: json['excludeAppResult'] as String? ?? '',
      ),
      includeAppResult: ValueWrapper(
        value: json['includeAppResult'] as String? ?? '',
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

  final ValueWrapper<ClipboardItemTags> clipboardItemTags;
  final ValueWrapper<String> excludeAppResult;
  final ValueWrapper<String> includeAppResult;

  // final List<ClipboardData> localClipboardItems;
  final ValueWrapper<Tags> tags;

  ClipboardState copyWith({
    ValueWrapper<ClipboardHistories>? clipboardHistory,
    ValueWrapper<ClipboardItems>? clipboardItems,
    ValueWrapper<ClipboardItemTags>? clipboardItemTags,
    ValueWrapper<String>? excludeAppResult,
    ValueWrapper<String>? includeAppResult,
    List<ClipboardData>? localClipboardItems,
    ValueWrapper<Tags>? tags,
  }) {
    return ClipboardState(
      clipboardHistory: clipboardHistory ?? this.clipboardHistory,
      clipboardItems: clipboardItems ?? this.clipboardItems,
      clipboardItemTags: clipboardItemTags ?? this.clipboardItemTags,
      // localClipboardItems: localClipboardItems ?? this.localClipboardItems,
      excludeAppResult: excludeAppResult ?? this.excludeAppResult,
      includeAppResult: includeAppResult ?? this.includeAppResult,
      tags: tags ?? this.tags,
    );
  }

  //toJson and fromJson methods for HydratedCubit
  Map<String, dynamic> toJson() {
    return {
      'clipboardHistory': ClipboardMapper.historyToJson(clipboardHistory.value),
      'clipboardItems': ClipboardMapper.itemsToJson(clipboardItems.value),
      'excludeAppResult': excludeAppResult.value,
      'includeAppResult': includeAppResult.value,
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

  int get totalItemsCount => clipboardItems.value?.length ?? 0;

  @override
  List<Object?> get props => [
    clipboardHistory,
    clipboardItems,
    clipboardItemTags,
    excludeAppResult,
    includeAppResult,
    // localClipboardItems,
    tags,
  ];
}
