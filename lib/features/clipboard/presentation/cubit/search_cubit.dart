import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

part 'search_state.dart';

@lazySingleton
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required this.localClipboardRepository})
    : super(
        SearchState(query: '', searchResults: <ClipboardItem>[].toInitial()),
      ) {
    _loadLocalClipboardItems();
  }

  late StreamSubscription<ClipboardItems>? _localItemsSubscription;
  final LocalClipboardRepository localClipboardRepository;

  ClipboardItems _allItems = [];

  Future<void> _loadLocalClipboardItems() async {
    _localItemsSubscription = localClipboardRepository.watchAll().listen(
      (items) {
        _allItems = items;
        if (state.isSearchMode) {
          _applyFilter(state.query);
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        emit(
          state.copyWith(
            searchResults: <ClipboardItems>[].toError(
              ErrorDetails(
                message: 'Error watching local clipboard items',
                stackTrace: stackTrace,
              ),
            ),
          ),
        );
        developer.log(
          'Error watching local clipboard items',
          error: error,
          stackTrace: stackTrace,
          name: 'ClipboardCubit',
        );
      },
    );
  }

  void _applyFilter(String q) {
    final norm = q.toLowerCase();
    final filtered = _allItems.where((m) {
      final contentMatch = m.content.toLowerCase().contains(norm);
      final typeMatch = m.type.name.toLowerCase().contains(norm);
      final fileMatch = m.filePaths.any((p) => p.toLowerCase().contains(norm));
      final metaMatch = m.metadata.values.any(
        (v) => v.toString().toLowerCase().contains(norm),
      );
      return contentMatch || typeMatch || fileMatch || metaMatch;
    }).toList();
    emit(state.copyWith(searchResults: filtered.toSuccess()));
  }

  void clear() {
    emit(
      state.copyWith(query: '', searchResults: <ClipboardItem>[].toInitial()),
    );
  }

  void search(String query) {
    final trimmedQuery = query.trim();
    emit(state.copyWith(query: query, searchResults: null.toLoading()));
    _applyFilter(trimmedQuery);
  }

  @override
  Future<void> close() {
    _localItemsSubscription?.cancel();
    return super.close();
  }
}
