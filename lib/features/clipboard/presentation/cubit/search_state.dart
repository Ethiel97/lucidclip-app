part of 'search_cubit.dart';

class SearchState extends Equatable {
  const SearchState({required this.query, required this.searchResults});

  final String query;

  final ValueWrapper<ClipboardItems> searchResults;

  SearchState copyWith({
    String? query,
    ValueWrapper<ClipboardItems>? searchResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      searchResults: searchResults ?? this.searchResults,
    );
  }

  bool get isSearchMode => query.isNotEmpty;

  ClipboardItems get unPinnedItems => (searchResults.value ?? [])
      .where((item) => !item.isPinned)
      .toList(growable: false);

  ClipboardItems get pinnedItems => (searchResults.value ?? [])
      .where((item) => item.isPinned)
      .toList(growable: false);

  @override
  List<Object?> get props => [query, searchResults];
}
