part of 'clipboard_cubit.dart';

class ClipboardState extends Equatable {
  const ClipboardState({
    this.clipboardHistory = const ValueWrapper(value: []),
    this.clipboardItems = const ValueWrapper(value: []),
    this.clipboardItemTags = const ValueWrapper(value: []),
    this.excludeAppResult = const ValueWrapper(),
    this.includeAppResult = const ValueWrapper(),
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
        value: SourceAppModel.fromJson(
          json['excludeAppResult'] as Map<String, dynamic>? ?? {},
        ).toEntity(),
      ),
      includeAppResult: ValueWrapper(
        value: SourceAppModel.fromJson(
          json['includeAppResult'] as Map<String, dynamic>? ?? {},
        ).toEntity(),
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
  final ValueWrapper<SourceApp> excludeAppResult;
  final ValueWrapper<SourceApp> includeAppResult;

  // final List<ClipboardData> localClipboardItems;
  final ValueWrapper<Tags> tags;

  ClipboardState copyWith({
    ValueWrapper<ClipboardHistories>? clipboardHistory,
    ValueWrapper<ClipboardItems>? clipboardItems,
    ValueWrapper<ClipboardItemTags>? clipboardItemTags,
    ValueWrapper<SourceApp>? excludeAppResult,
    ValueWrapper<SourceApp>? includeAppResult,
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
      'excludeAppResult': excludeAppResult.value != null
          ? SourceAppModel.fromEntity(excludeAppResult.value!).toJson()
          : null,
      'includeAppResult': includeAppResult.value != null
          ? SourceAppModel.fromEntity(includeAppResult.value!).toJson()
          : null,
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
