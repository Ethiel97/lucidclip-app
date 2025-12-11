import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:crypto/crypto.dart';
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
  }) : super(const ClipboardState()) {
    _loadData();
    _startWatchingClipboard();
  }

  Future<void> _loadData() async {
    await Future.wait([
      loadClipboardItems(),
      loadClipboardHistory(),
      loadTags(),
      _loadLocalClipboardItems(),
    ]);
  }

  final BaseClipboardManager clipboardManager;
  final ClipboardRepository clipboardRepository;
  final LocalClipboardRepository localClipboardRepository;
  StreamSubscription<ClipboardData>? _clipboardSubscription;

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

      final updated = [
        if (!isDuplicate) clipboardData,
        ...currentItems,
      ];

      emit(
        state.copyWith(localClipboardItems: updated),
      );
    });
  }

  ClipboardItem _convertToClipboardItem(ClipboardData clipboardData) {
    final now = DateTime.now();
    final itemType = _mapContentTypeToItemType(clipboardData.type);
    
    return ClipboardItem(
      id: _generateId(),
      content: clipboardData.text ?? '',
      contentHash: clipboardData.contentHash ?? '',
      type: itemType,
      userId: '', // Will be set by auth context
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

  String _generateId() {
    // Generate a unique ID using timestamp and hash
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final randomData = '$timestamp-${DateTime.now().hashCode}';
    final bytes = utf8.encode(randomData);
    final hash = sha256.convert(bytes);
    return '${timestamp}_${hash.toString().substring(0, 16)}';
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
        id: _generateId(),
        clipboardItemId: clipboardItemId,
        action: ClipboardAction.copy,
        userId: '', // Will be set by auth context
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      // Create history record using the clipboard repository
      // Note: This uses upsertClipboardItem as there's no dedicated history creation method
      await clipboardRepository.upsertClipboardItem(
        data: history.toMap(),
      );
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

  Future<void> _loadLocalClipboardItems() async {
    try {
      final items = await localClipboardRepository.getAll();
      // Convert to ClipboardData for display in the UI
      final clipboardDataList = items.map(_convertToClipboardData).toList();
      emit(
        state.copyWith(localClipboardItems: clipboardDataList),
      );
    } catch (e, stackTrace) {
      developer.log(
        'Failed to load clipboard items from local repository',
        error: e,
        stackTrace: stackTrace,
        name: 'ClipboardCubit',
      );
      // Continue with empty list if loading fails
    }
  }

  ClipboardData _convertToClipboardData(ClipboardItem item) {
    final contentType = _mapItemTypeToContentType(item.type);
    
    return ClipboardData(
      type: contentType,
      text: item.content,
      contentHash: item.contentHash,
      timestamp: item.createdAt,
      html: item.htmlContent,
      filePaths: item.filePaths.isNotEmpty ? item.filePaths : null,
    );
  }

  ClipboardContentType _mapItemTypeToContentType(ClipboardItemType type) {
    switch (type) {
      case ClipboardItemType.text:
        return ClipboardContentType.text;
      case ClipboardItemType.image:
        return ClipboardContentType.image;
      case ClipboardItemType.file:
        return ClipboardContentType.file;
      case ClipboardItemType.url:
        return ClipboardContentType.url;
      case ClipboardItemType.html:
        return ClipboardContentType.html;
      case ClipboardItemType.unknown:
        return ClipboardContentType.unknown;
    }
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
    await clipboardManager.dispose();
    return super.close();
  }
}
