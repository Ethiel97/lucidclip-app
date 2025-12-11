import 'dart:async';

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
  }

  final BaseClipboardManager clipboardManager;
  final ClipboardRepository clipboardRepository;
  StreamSubscription<ClipboardData>? _clipboardSubscription;

  void _startWatchingClipboard() {
    _clipboardSubscription = clipboardManager.watchClipboard().listen((clipboardData) {
      emit(state.copyWith(currentClipboardData: clipboardData));

      final currentItems = state.localClipboardItems;

      final isDuplicate = currentItems.any(
        (item) => item.contentHash == clipboardData.contentHash,
      );

      final updated = [
        if (!isDuplicate) clipboardData,
        ...currentItems,
      ];

      emit(
        state.copyWith(localClipboardItems: updated),
      );
    });
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
