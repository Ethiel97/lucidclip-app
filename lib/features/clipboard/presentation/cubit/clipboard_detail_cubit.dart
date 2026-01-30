import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
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

  Future<void> editClipboardItem({
    required ClipboardItem clipboardItem,
    required String updatedContent,
  }) async {
    final previousItem = state.clipboardItem?.value ?? clipboardItem;
    final sanitizedContent = updatedContent.trim();
    if (sanitizedContent.isEmpty) {
      emit(state.copyWith(editStatus: null.toError()));
      return;
    }

    final now = DateTime.now().toUtc();
    final resolvedType = _resolveClipboardItemType(
      previousItem,
      sanitizedContent,
    );
    final resolvedHtmlContent =
        previousItem.type.isHtml ? sanitizedContent : previousItem.htmlContent;

    final updatedItem = previousItem.copyWith(
      content: sanitizedContent,
      htmlContent: resolvedHtmlContent,
      contentHash: _computeContentHash(
        content: sanitizedContent,
        type: resolvedType,
        htmlContent: resolvedHtmlContent,
        filePath: previousItem.filePath,
        imageBytes: previousItem.imageBytes,
      ),
      type: resolvedType,
      updatedAt: now,
      lastUsedAt: now,
    );

    emit(
      state.copyWith(
        clipboardItem: state.clipboardItem?.value == null
            ? null.toInitial()
            : updatedItem.toSuccess(),
        editStatus: null.toLoading(),
      ),
    );

    try {
      await localClipboardRepository.upsert(updatedItem);
      emit(state.copyWith(editStatus: null.toSuccess()));

      await _upsertClipboardHistory(
        clipboardItem: updatedItem,
        action: ClipboardAction.edit,
      );
    } catch (e, stack) {
      emit(
        state.copyWith(
          clipboardItem: previousItem.toSuccess(),
          editStatus: null.toError(),
        ),
      );
      log('Error editing clipboard item: $e', stackTrace: stack);
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
      emit(
        state.copyWith(
          clipboardItem: clipboardItem.toSuccess(),
          editStatus: null.toInitial(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          clipboardItem: null.toError(),
          editStatus: null.toError(),
        ),
      );
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
    emit(
      state.copyWith(
        clipboardItem: null.toInitial(),
        editStatus: null.toInitial(),
      ),
    );
  }

  ClipboardItemType _resolveClipboardItemType(
    ClipboardItem item,
    String content,
  ) {
    if (item.type.isFile || item.type.isImage) return item.type;
    if (item.type.isHtml) return ClipboardItemType.html;
    return content.isUrl ? ClipboardItemType.url : ClipboardItemType.text;
  }

  String _computeContentHash({
    required ClipboardItemType type,
    required String content,
    String? htmlContent,
    String? filePath,
    List<int>? imageBytes,
  }) {
    return ContentHasher.hashOfParts([
      type.name,
      content,
      htmlContent,
      if (imageBytes != null) imageBytes,
      if (filePath != null) filePath,
    ]);
  }
}
