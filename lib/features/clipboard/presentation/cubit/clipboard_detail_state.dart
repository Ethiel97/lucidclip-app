part of 'clipboard_detail_cubit.dart';

class ClipboardDetailState extends Equatable {
  const ClipboardDetailState({
    this.clipboardItem,
    this.deletionStatus,
    this.togglePinStatus,
  });

  final ValueWrapper<ClipboardItem>? clipboardItem;
  final ValueWrapper<void>? deletionStatus;
  final ValueWrapper<void>? togglePinStatus;

  ClipboardDetailState copyWith({
    ValueWrapper<ClipboardItem>? clipboardItem,
    ValueWrapper<void>? deletionStatus,
    ValueWrapper<void>? togglePinStatus,
  }) {
    return ClipboardDetailState(
      clipboardItem: clipboardItem ?? this.clipboardItem,
      deletionStatus: deletionStatus ?? this.deletionStatus,
      togglePinStatus: togglePinStatus ?? this.togglePinStatus,
    );
  }

  @override
  List<Object?> get props => [clipboardItem, deletionStatus, togglePinStatus];

  bool get hasClipboardItem =>
      clipboardItem?.value != null &&
      !clipboardItem!.value!.isEmpty &&
      clipboardItem!.isSuccess;
}
