part of 'search_cubit.dart';

typedef FilterType = ClipboardItemType;

class SearchState extends Equatable {
  const SearchState({
    required this.query,
    required this.searchResults,
    this.filterType = FilterType.unknown,
  });

  final String query;
  final FilterType filterType;

  final ValueWrapper<ClipboardItems> searchResults;

  SearchState copyWith({
    FilterType? filterType,
    String? query,
    ValueWrapper<ClipboardItems>? searchResults,
  }) {
    return SearchState(
      filterType: filterType ?? this.filterType,
      query: query ?? this.query,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  bool get isSearchMode => query.isNotEmpty || !filterType.isUnknown;

  ClipboardItems get unPinnedItems => (searchResults.value ?? [])
      .where((item) => !item.isPinned)
      .toList(growable: false);

  ClipboardItems get pinnedItems => (searchResults.value ?? [])
      .where((item) => item.isPinned)
      .toList(growable: false);

  @override
  List<Object?> get props => [filterType, query, searchResults];
}
