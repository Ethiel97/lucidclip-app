import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/auth/auth.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';
import 'package:lucid_clip/features/settings/domain/domain.dart';

part 'search_state.dart';

@lazySingleton
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.authRepository,
    required this.localClipboardRepository,
    required this.localSettingsRepository,
  }) : super(
         SearchState(query: '', searchResults: <ClipboardItem>[].toInitial()),
       ) {
    _loadLocalClipboardItems();
    _initializeAuthListener();
  }

  //subscriptions
  StreamSubscription<UserSettings?>? _userSettingsSubscription;
  StreamSubscription<ClipboardItems>? _localItemsSubscription;
  StreamSubscription<User?>? _authSubscription;

  // repositories
  final LocalClipboardRepository localClipboardRepository;
  final LocalSettingsRepository localSettingsRepository;
  final AuthRepository authRepository;

  ClipboardItems _allItems = [];
  String _currentUserId = 'guest';

  UserSettings? _userSettings;

  void _initializeAuthListener() {
    _authSubscription?.cancel();
    _authSubscription = authRepository.authStateChanges.listen((user) {
      _currentUserId = user?.id ?? 'guest';

      _watchSettings();
    });
  }

  void _watchSettings() {
    _userSettingsSubscription?.cancel();
    _userSettingsSubscription = localSettingsRepository
        .watchSettings(_currentUserId)
        .listen((s) {
          developer.log(
            'Watching settings: $s from clipboard cubit',
            name: 'ClipboardCubit',
          );
          _userSettings = s;
        });
  }

  Future<void> _loadLocalClipboardItems() async {
    await _localItemsSubscription?.cancel();
    _localItemsSubscription = localClipboardRepository
        .watchAll(
          limit: _userSettings?.maxHistoryItems ?? MaxHistorySize.size30.value,
        )
        .listen(
          (items) {
            _allItems = items;
            if (state.isSearchMode) {
              _applyFilter(state.query);
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            emit(
              state.copyWith(
                searchResults: <ClipboardItem>[].toError(
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

  void _applyFilter(String query) {
    final normalizedQuery = query.toLowerCase();
    final hasTypeFilter = !state.filterType.isUnknown;

    final filtered = _allItems.where((item) {
      final contentMatch = item.content.toLowerCase().contains(normalizedQuery);

      var typeMatch = true;

      if (hasTypeFilter) {
        typeMatch = item.type == state.filterType;
      }

      final fileMatch = item.filePath?.contains(normalizedQuery) ?? false;
      final metaMatch = item.metadata.values.any(
        (v) => v.toString().toLowerCase().contains(normalizedQuery),
      );
      return typeMatch && (contentMatch || fileMatch || metaMatch);
    }).toList();

    emit(state.copyWith(searchResults: filtered.toSuccess()));
  }

  void setFilterType(FilterType filterType) {
    emit(state.copyWith(filterType: filterType));
    _applyFilter(state.query);
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
