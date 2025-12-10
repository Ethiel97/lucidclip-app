part of 'clipboard_cubit.dart';

class ClipboardState extends Equatable {
  const ClipboardState({
    this.clipboardHistory = const ValueWrapper(value: []),
    this.clipboardItems = const ValueWrapper(value: []),
    this.clipboardItemTags = const ValueWrapper(value: []),
    this.currentClipboardData,
    this.tags = const ValueWrapper(value: []),
  });

  factory ClipboardState.fromJson(Map<String, dynamic> json) {
    return ClipboardState(
      clipboardHistory: ValueWrapper(
        value: ClipboardMapper.historyFromJson(
              json['clipboardHistory'] as List<dynamic>?,
            ) ??
            [],
      ),
      clipboardItems: ValueWrapper(
        value: ClipboardMapper.itemsFromJson(
              json['clipboardItems'] as List<dynamic>?,
            ) ??
            [],
      ),
      tags: ValueWrapper(
        value: ClipboardMapper.tagsFromJson(
              json['tags'] as List<dynamic>?,
            ) ??
            [],
      ),
      clipboardItemTags: ValueWrapper(
        value: ClipboardMapper.clipboardItemTagsFromJson(
              json['clipboardItemTags'] as List<dynamic>?,
            ) ??
            [],
      ),
    );
  }

  final ValueWrapper<ClipboardHistories> clipboardHistory;
  final ValueWrapper<ClipboardItems> clipboardItems;

  final ClipboardData? currentClipboardData;
  final ValueWrapper<Tags> tags;

  final ValueWrapper<ClipboardItemTags> clipboardItemTags;

  ClipboardState copyWith({
    ValueWrapper<ClipboardHistories>? clipboardHistory,
    ValueWrapper<ClipboardItems>? clipboardItems,
    ClipboardData? currentClipboardData,
    ValueWrapper<Tags>? tags,
    ValueWrapper<ClipboardItemTags>? clipboardItemTags,
  }) {
    return ClipboardState(
      clipboardHistory: clipboardHistory ?? this.clipboardHistory,
      clipboardItems: clipboardItems ?? this.clipboardItems,
      currentClipboardData: currentClipboardData ?? this.currentClipboardData,
      tags: tags ?? this.tags,
      clipboardItemTags: clipboardItemTags ?? this.clipboardItemTags,
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

  @override
  List<Object?> get props => [
        clipboardHistory,
        clipboardItems,
        currentClipboardData,
        tags,
        clipboardItemTags,
      ];
}
