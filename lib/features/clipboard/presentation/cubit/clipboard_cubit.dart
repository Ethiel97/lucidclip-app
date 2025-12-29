import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/errors/errors.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_state.dart';

@lazySingleton
class ClipboardCubit extends HydratedCubit<ClipboardState> {
  ClipboardCubit({
    required this.clipboardManager,
    required this.clipboardRepository,
    required this.localClipboardRepository,
    required this.localClipboardHistoryRepository,
  }) : super(const ClipboardState()) {
    _loadData();
    _startWatchingClipboard();
  }

  Future<void> _loadData() async {
    await Future.wait([
      loadClipboardItems(),
      loadClipboardHistory(),
      loadTags(),
    ]);
    _startWatchingLocalData();
  }

  final BaseClipboardManager clipboardManager;
  final ClipboardRepository clipboardRepository;
  final LocalClipboardRepository localClipboardRepository;
  final LocalClipboardHistoryRepository localClipboardHistoryRepository;
  StreamSubscription<ClipboardData>? _clipboardSubscription;
  StreamSubscription<List<ClipboardItem>>? _localItemsSubscription;
  StreamSubscription<List<ClipboardHistory>>? _localHistorySubscription;
  
  // Placeholder for userId until auth context is available
  static const String _pendingUserId = '';

  void _startWatchingClipboard() {
    _clipboardSubscription = clipboardManager.watchClipboard().listen((clipboardData) async {
      emit(state.copyWith(currentClipboardData: clipboardData));

      final currentItems = state.localClipboardItems;

      final isDuplicate = currentItems.any(
        (item) => item.contentHash == clipboardData.contentHash,
      );

      if (!isDuplicate) {
        // Convert ClipboardData to ClipboardItem and upsert to local repository
        final clipboardItem = _convertToClipboardItem(clipboardData);
        await _upsertClipboardItem(clipboardItem);
        
        // Create clipboard history record
        await _createClipboardHistory(clipboardItem.id);
      }
      // Note: The state will be updated by the _localItemsSubscription stream
      // when the database emits the updated data, so we don't manually update 
      // localClipboardItems here anymore
    });
  }

  void _startWatchingLocalData() {
    // Watch local clipboard items stream
    _localItemsSubscription = localClipboardRepository.watchAll().listen(
      (items) {
        // Convert ClipboardItems to ClipboardData for display
        final clipboardDataList = items.map(_convertToClipboardData).toList();
        emit(
          state.copyWith(localClipboardItems: clipboardDataList),
        );
      },
      onError: (error, stackTrace) {
        developer.log(
          'Error watching local clipboard items',
          error: error,
          stackTrace: stackTrace,
          name: 'ClipboardCubit',
        );
      },
    );

    // Watch local clipboard history stream
    _localHistorySubscription = localClipboardHistoryRepository.watchAll().listen(
      (histories) {
        // Store histories in state if needed
        developer.log(
          'Received ${histories.length} clipboard history records from stream',
          name: 'ClipboardCubit',
        );
      },
      onError: (error, stackTrace) {
        developer.log(
          'Error watching local clipboard history',
          error: error,
          stackTrace: stackTrace,
          name: 'ClipboardCubit',
        );
      },
    );
  }

  ClipboardItem _convertToClipboardItem(ClipboardData clipboardData) {
    final now = DateTime.now();
    final itemType = _mapContentTypeToItemType(clipboardData.type);
    
    return ClipboardItem(
      id: IdGenerator.generate(),
      content: clipboardData.text ?? '',
      contentHash: clipboardData.contentHash ?? '',
      type: itemType,
      userId: _pendingUserId,
      createdAt: clipboardData.timestamp ?? now,
      updatedAt: now,
      imageUrl: clipboardData.imageBytes != null ? 'local' : null,
      filePaths: clipboardData.filePaths ?? [],
      htmlContent: clipboardData.html,
      isSynced: false,
    );
  }

  ClipboardItemType _mapContentTypeToItemType(ClipboardContentType type) {
    switch (type) {
      case ClipboardContentType.text:
        return ClipboardItemType.text;
      case ClipboardContentType.image:
        return ClipboardItemType.image;
      case ClipboardContentType.file:
        return ClipboardItemType.file;
      case ClipboardContentType.url:
        return ClipboardItemType.url;
      case ClipboardContentType.html:
        return ClipboardItemType.html;
      case ClipboardContentType.unknown:
        return ClipboardItemType.unknown;
    }
  }



  Future<void> _upsertClipboardItem(ClipboardItem item) async {
    try {
      await localClipboardRepository.upsert(item);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to upsert clipboard item to local repository',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
      // The item is still added to the in-memory list
    }
  }

  Future<void> _createClipboardHistory(String clipboardItemId) async {
    try {
      final history = ClipboardHistory(
        id: IdGenerator.generate(),
        clipboardItemId: clipboardItemId,
        action: ClipboardAction.copy,
        userId: _pendingUserId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Store history locally
      await localClipboardHistoryRepository.upsert(history);
    } catch (e, stackTrace) {
      developer.log(
        'Failed to create clipboard history record',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
      // Continue working even if history creation fails
    }
  }

  ClipboardData _convertToClipboardData(ClipboardItem item) {
    return ClipboardData(
      type: item.contentType, // Using the extension
      text: item.content,
      contentHash: item.contentHash,
      timestamp: item.createdAt,
      html: item.htmlContent,
      filePaths: item.filePaths.isNotEmpty ? item.filePaths : null,
    );
  }

  Future<void> loadClipboardItems() async {
    try {
      emit(
        state.copyWith(clipboardItems: state.clipboardItems.toLoading()),
      );
    } on ServerException {
      emit(
        state.copyWith(
          clipboardItems: state.clipboardItems.toError(
            const ErrorDetails(
              message: 'Server error occurred while loading clipboard items.',
            ),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          clipboardItems: state.clipboardItems.toError(
            ErrorDetails(
              message: 'An error occurred while loading clipboard items: $e',
            ),
          ),
        ),
      );
    }
  }

  Future<void> loadClipboardHistory() async {
    try {
      if (state.clipboardHistory.isLoading) {
        return;
      }

      emit(
        state.copyWith(clipboardHistory: state.clipboardHistory.toLoading()),
      );

      final data = await clipboardRepository.fetchClipboardHistory();

      emit(
        state.copyWith(
          clipboardHistory: data.toSuccess(),
        ),
      );
    } on ServerException {
      emit(
        state.copyWith(
          clipboardHistory: state.clipboardHistory.toError(
            const ErrorDetails(
              message: 'Server error occurred while loading clipboard history.',
            ),
          ),
        ),
      );
    }
  }

  // load tags
  Future<void> loadTags() async {
    try {
      if (state.tags.isLoading) {
        return;
      }
      emit(
        state.copyWith(tags: state.tags.toLoading()),
      );

      final data = await clipboardRepository.fetchTags();
      emit(
        state.copyWith(
          tags: data.toSuccess(),
        ),
      );
    } on ServerException {
      emit(
        state.copyWith(
          tags: state.tags.toError(
            const ErrorDetails(
              message: 'Server error occurred while loading tags.',
            ),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          tags: state.tags.toError(
            ErrorDetails(
              message: 'An error occurred while loading tags: $e',
            ),
          ),
        ),
      );
    }
  }

  // load clipboard item tags
  Future<void> loadClipboardItemTags() async {
    try {
      if (state.clipboardItemTags.isLoading) {
        return;
      }
      emit(
        state.copyWith(clipboardItemTags: state.clipboardItemTags.toLoading()),
      );
      final data = await clipboardRepository.fetchClipboardItemTags();
      emit(
        state.copyWith(
          clipboardItemTags: data.toSuccess(),
        ),
      );
    } on ServerException {
      emit(
        state.copyWith(
          clipboardItemTags: state.clipboardItemTags.toError(
            const ErrorDetails(
              message:
                  'Server error occurred while loading clipboard item tags.',
            ),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          clipboardItemTags: state.clipboardItemTags.toError(
            ErrorDetails(
              message:
                  'An error occurred while loading clipboard item tags: $e',
            ),
          ),
        ),
      );
    }
  }

  @override
  ClipboardState? fromJson(Map<String, dynamic> json) {
    try {
      return ClipboardState.fromJson(json);
    } catch (_) {
      return const ClipboardState();
    }
  }

  @override
  Map<String, dynamic>? toJson(ClipboardState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }

  @disposeMethod
  @override
  Future<void> close() async {
    await _clipboardSubscription?.cancel();
    await _localItemsSubscription?.cancel();
    await _localHistorySubscription?.cancel();
    await clipboardManager.dispose();
    return super.close();
  }
}
