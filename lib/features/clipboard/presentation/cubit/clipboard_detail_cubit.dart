import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

part 'clipboard_detail_state.dart';

@lazySingleton
class ClipboardDetailCubit extends Cubit<ClipboardDetailState> {
  ClipboardDetailCubit({
    required this.localClipboardRepository,
    required this.localClipboardHistoryRepository,
  }) : super(const ClipboardDetailState());

  final LocalClipboardRepository localClipboardRepository;
  final LocalClipboardHistoryRepository localClipboardHistoryRepository;

  final String _pendingUserId = '';

  Future<void> togglePinClipboardItem(ClipboardItem clipboardItem) async {
    final previousItem = state.clipboardItem?.value ?? clipboardItem;
    final isPinned = previousItem.isPinned;
    final optimisticItem = previousItem.copyWith(isPinned: !isPinned);

    //don't open the detail view if the clipboard item state is null
    emit(
      state.copyWith(
        clipboardItem: state.clipboardItem?.value == null
            ? null.toInitial()
            : optimisticItem.toSuccess(),
        togglePinStatus: null.toLoading(),
      ),
    );
    try {
      await localClipboardRepository.upsert(optimisticItem);
      emit(state.copyWith(togglePinStatus: null.toSuccess()));

      await _upsertClipboardHistory(
        clipboardItem: optimisticItem,
        action: isPinned ? ClipboardAction.unpin : ClipboardAction.pin,
      );
    } catch (e) {
      emit(
        state.copyWith(
          clipboardItem: previousItem.toSuccess(),
          togglePinStatus: null.toError(),
        ),
      );
    }
  }

  Future<void> deleteClipboardItem(ClipboardItem clipboardItem) async {
    final previousItem = state.clipboardItem?.value ?? clipboardItem;

    emit(
      state.copyWith(
        clipboardItem: null.toInitial(),
        deletionStatus: null.toLoading(),
      ),
    );

    try {
      await localClipboardRepository.delete(previousItem.id);

      emit(state.copyWith(deletionStatus: null.toSuccess()));

      await _upsertClipboardHistory(
        clipboardItem: previousItem,
        action: ClipboardAction.delete,
      );
    } catch (e, stack) {
      emit(
        state.copyWith(
          clipboardItem: previousItem.toSuccess(),
          deletionStatus: null.toError(),
        ),
      );

      log('Error deleting clipboard item: $e', stackTrace: stack);
    }
  }

  void setClipboardItem(ClipboardItem clipboardItem) {
    try {
      emit(state.copyWith(clipboardItem: clipboardItem.toSuccess()));
    } catch (e) {
      emit(state.copyWith(clipboardItem: null.toError()));
    }
  }

  Future<void> _upsertClipboardHistory({
    required ClipboardItem clipboardItem,
    required ClipboardAction action,
  }) async {
    try {
      final history = ClipboardHistory(
        id: IdGenerator.generate(),
        clipboardItemId: clipboardItem.id,
        action: action,
        userId: _pendingUserId,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );
      await localClipboardHistoryRepository.upsert(history);
    } catch (e, stack) {
      log('Error upserting clipboard history: $e', stackTrace: stack);
      // Handle error if necessary
    }
  }

  // Clear the selected clipboard item
  // This can be used when navigating away from the detail view
  // will trigger the closing of the detail view in the UI
  void clearSelection() {
    emit(state.copyWith(clipboardItem: null.toInitial()));
  }
}
