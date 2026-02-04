import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/analytics/analytics_module.dart';
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
    _initialize();
  }

  final LocalClipboardRepository localClipboardRepository;
  final LocalSettingsRepository localSettingsRepository;
  final AuthRepository authRepository;

  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserSettings?>? _userSettingsSubscription;
  StreamSubscription<ClipboardItems>? _localItemsSubscription;

  ClipboardItems _allItems = [];
  String _currentUserId = 'guest';
  UserSettings? _userSettings;

  int get _effectiveMaxHistoryItems =>
      _userSettings?.maxHistoryItems ?? MaxHistorySize.size30.value;

  Future<void> _initialize() async {
    _startAuthWatcher();
  }

  void _startAuthWatcher() {
    _authSubscription?.cancel();
    _authSubscription = authRepository.authStateChanges.listen(
      (user) {
        final nextUserId = user?.id ?? 'guest';
        if (nextUserId == _currentUserId && _userSettingsSubscription != null) {
          return;
        }

        _currentUserId = nextUserId;
        _startSettingsWatcherForUser(_currentUserId);
      },
      onError: (Object error, StackTrace stackTrace) {
        developer.log(
          'Auth watcher error',
          error: error,
          stackTrace: stackTrace,
          name: 'SearchCubit',
        );
      },
    );
  }

  void _startSettingsWatcherForUser(String userId) {
    _userSettingsSubscription?.cancel();
    _userSettingsSubscription = localSettingsRepository
        .watchSettings(userId)
        .listen(
          (settings) {
            final previousMax = _userSettings?.maxHistoryItems;
            _userSettings = settings;
            _ensureLocalItemsSubscription(previousMax: previousMax);
          },
          onError: (Object error, StackTrace stackTrace) {
            developer.log(
              'Settings watcher error',
              error: error,
              stackTrace: stackTrace,
              name: 'SearchCubit',
            );
            _ensureLocalItemsSubscription(previousMax: null);
          },
        );
  }

  void _ensureLocalItemsSubscription({required int? previousMax}) {
    final nextMax = _effectiveMaxHistoryItems;
    if (previousMax == nextMax && _localItemsSubscription != null) return;
    _subscribeLocalItems(limit: nextMax);
  }

  void _subscribeLocalItems({required int limit}) {
    _localItemsSubscription?.cancel();
    _localItemsSubscription = localClipboardRepository
        .watchAll(limit: limit)
        .listen(
          (items) {
            _allItems = items;
            if (state.isSearchMode) _applyFilter(state.query);
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
              name: 'SearchCubit',
            );
          },
        );
  }

  void _applyFilter(String query) {
    final normalizedQuery = query.trim().toLowerCase();

    if (normalizedQuery.isEmpty) {
      emit(state.copyWith(searchResults: _allItems.toSuccess()));
      return;
    }

    final hasTypeFilter = !state.filterType.isUnknown;

    final filtered = _allItems.where((item) {
      final typeMatch = !hasTypeFilter || item.type == state.filterType;

      final contentMatch = item.content.toLowerCase().contains(normalizedQuery);

      final fileMatch =
          item.filePath?.toLowerCase().contains(normalizedQuery) ?? false;

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
    emit(state.copyWith(query: trimmedQuery, searchResults: null.toLoading()));
    _applyFilter(trimmedQuery);
    
    // Track search event (only when there's a non-empty query)
    if (trimmedQuery.isNotEmpty) {
      Analytics.track(AnalyticsEvent.searchUsed);
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await _userSettingsSubscription?.cancel();
    await _localItemsSubscription?.cancel();
    return super.close();
  }
}
