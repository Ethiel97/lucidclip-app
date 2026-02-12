import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/clipboard_manager/clipboard_manager.dart';
import 'package:lucid_clip/core/extensions/extensions.dart';
import 'package:lucid_clip/core/observability/observability_module.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/accessibility/accessibility.dart';
import 'package:lucid_clip/features/clipboard/clipboard.dart';

part 'clipboard_detail_state.dart';

@lazySingleton
class ClipboardDetailCubit extends Cubit<ClipboardDetailState> {
  ClipboardDetailCubit({
    required this.accessibilityRepository,
    required this.clipboardManager,
    required this.deviceIdProvider,
    required this.localClipboardRepository,
    required this.localClipboardOutboxRepository,
    required this.pasteToAppService,
  }) : super(const ClipboardDetailState()) {
    _init();
  }

  final AccessibilityRepository accessibilityRepository;
  final BaseClipboardManager clipboardManager;
  final DeviceIdProvider deviceIdProvider;
  final LocalClipboardRepository localClipboardRepository;
  final LocalClipboardOutboxRepository localClipboardOutboxRepository;
  final PasteToAppService pasteToAppService;

  late final String _deviceId;

  Future<void> _init() async {
    _deviceId = await deviceIdProvider.getInstallationId();
  }

  Future<void> togglePinClipboardItem(ClipboardItem clipboardItem) async {
    final previousItem = state.clipboardItem?.value ?? clipboardItem;
    final isPinned = previousItem.isPinned;
    final optimisticItem = previousItem.copyWith(isPinned: !isPinned);

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

      await _enqueueOutboxOp(
        clipboardItem: optimisticItem,
        operationType: isPinned
            ? ClipboardOperationType.unpin
            : ClipboardOperationType.pin,
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

  Future<void> copyToClipboard(ClipboardItem item) async {
    try {
      await clipboardManager.setClipboardContent(item.toInfrastructure());
    } catch (e, stackTrace) {
      Observability.captureException(
        e,
        stackTrace: stackTrace,
        hint: {'operation': 'copy_to_clipboard'},
      ).unawaited();
    }
  }

  Future<void> handlePasteToApp({
    required String bundleId,
    required ClipboardItem clipboardItem,
  }) async {
    try {
      final hasPermission = await accessibilityRepository.checkPermission();
      if (!hasPermission) {
        await accessibilityRepository.requestPermission();
        return;
      }

      await copyToClipboard(clipboardItem);

      emit(
        state.copyWith(pasteToAppStatus: state.pasteToAppStatus.toLoading()),
      );
      //Wait for clipboard to sync
      await Future<void>.delayed(const Duration(milliseconds: 200));

      await pasteToAppService.pasteToApp(bundleId);

      emit(
        state.copyWith(pasteToAppStatus: state.pasteToAppStatus.toSuccess()),
      );
    } catch (e, stack) {
      emit(state.copyWith(pasteToAppStatus: state.pasteToAppStatus.toError()));

      Observability.captureException(
        e,
        stackTrace: stack,
        hint: {'operation': 'paste_to_app'},
      ).unawaited();

      Observability.breadcrumb(
        'Paste to app failed',
        category: 'clipboard',
        level: ObservabilityLevel.error,
      ).unawaited();
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
    final resolvedHtmlContent = previousItem.type.isHtml
        ? sanitizedContent
        : previousItem.htmlContent;

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

      await _enqueueOutboxOp(
        clipboardItem: updatedItem,
        operationType: ClipboardOperationType.update,
      );
    } catch (e, stack) {
      emit(
        state.copyWith(
          clipboardItem: previousItem.toSuccess(),
          editStatus: null.toError(),
        ),
      );

      Observability.captureException(
        e,
        stackTrace: stack,
        hint: {'operation': 'edit_clipboard_item'},
      ).unawaited();
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

      await _enqueueOutboxOp(
        clipboardItem: previousItem,
        operationType: ClipboardOperationType.delete,
      );
    } catch (e, stack) {
      emit(
        state.copyWith(
          clipboardItem: previousItem.toSuccess(),
          deletionStatus: null.toError(),
        ),
      );

      Observability.captureException(
        e,
        stackTrace: stack,
        hint: {'operation': 'delete_clipboard_item'},
      ).unawaited();
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
    } catch (_) {
      emit(
        state.copyWith(
          clipboardItem: null.toError(),
          editStatus: null.toError(),
        ),
      );
    }
  }

  Future<void> _enqueueOutboxOp({
    required ClipboardItem clipboardItem,
    required ClipboardOperationType operationType,
  }) async {
    try {
      final now = DateTime.now().toUtc();

      final op = ClipboardOutbox(
        id: IdGenerator.generate(),
        deviceId: _deviceId,
        entityId: clipboardItem.id,
        operationType: operationType,
        userId: clipboardItem.userId.isNotEmpty
            ? clipboardItem.userId
            : 'anonymous',

        createdAt: now,
        // Recommandé si ton entity le supporte :
        // payload: jsonEncode({...}),
        // deviceId: ...
      );

      await localClipboardOutboxRepository.enqueue(op);
    } catch (e, stack) {
      Observability.captureException(
        e,
        stackTrace: stack,
        hint: {'operation': 'enqueue_outbox'},
      ).unawaited();
    }
  }

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
