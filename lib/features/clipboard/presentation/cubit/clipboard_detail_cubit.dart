import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

part 'clipboard_detail_state.dart';

@lazySingleton
class ClipboardDetailCubit extends Cubit<ClipboardDetailState> {
  ClipboardDetailCubit({required this.localClipboardRepository})
    : super(const ClipboardDetailState());

  final LocalClipboardRepository localClipboardRepository;

  Future<void> togglePinClipboardItem(ClipboardItem clipboardItem) async {
    try {
      final isPinned = clipboardItem.isPinned;
      final updatedItem = clipboardItem.copyWith(isPinned: !isPinned);
      await localClipboardRepository.upsert(updatedItem);

      emit(state.copyWith(togglePinStatus: null.toSuccess()));

      clearSelection();
    } catch (e) {
      emit(state.copyWith(togglePinStatus: null.toError()));
    }
  }

  Future<void> deleteClipboardItem(ClipboardItem clipboardItem) async {
    try {
      await localClipboardRepository.delete(clipboardItem.id);
      emit(state.copyWith(deletionStatus: null.toSuccess()));

      clearSelection();
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

  // Clear the selected clipboard item
  // This can be used when navigating away from the detail view
  // will trigger the closing of the detail view in the UI
  void clearSelection() {
    emit(state.copyWith(clipboardItem: null.toInitial()));
  }
}
