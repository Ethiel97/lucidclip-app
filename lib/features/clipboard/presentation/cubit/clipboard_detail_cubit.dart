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
    try {
      final isPinned = clipboardItem.isPinned;
      final updatedItem = clipboardItem.copyWith(isPinned: !isPinned);
      await localClipboardRepository.upsert(updatedItem);

      emit(state.copyWith(togglePinStatus: null.toSuccess()));

      clearSelection();

      await _upsertClipboardHistory(
        clipboardItem: updatedItem,
        action: isPinned ? ClipboardAction.unpin : ClipboardAction.pin,
      );
    } catch (e) {
      emit(state.copyWith(togglePinStatus: null.toError()));
    }
  }

  Future<void> deleteClipboardItem(ClipboardItem clipboardItem) async {
    try {
      await localClipboardRepository.delete(clipboardItem.id);
      emit(state.copyWith(deletionStatus: null.toSuccess()));

      clearSelection();

      await _upsertClipboardHistory(
        clipboardItem: clipboardItem,
        action: ClipboardAction.delete,
      );
    } catch (e) {
      emit(state.copyWith(deletionStatus: null.toError()));
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
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await localClipboardHistoryRepository.upsert(history);
    } catch (e) {
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
