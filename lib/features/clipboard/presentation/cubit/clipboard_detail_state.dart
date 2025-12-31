part of 'clipboard_detail_cubit.dart';

class ClipboardDetailState extends Equatable {
  const ClipboardDetailState({this.clipboardItem});

  final ValueWrapper<ClipboardItem>? clipboardItem;

  ClipboardDetailState copyWith({ValueWrapper<ClipboardItem>? clipboardItem}) {
    return ClipboardDetailState(
      clipboardItem: clipboardItem ?? this.clipboardItem,
    );
  }

  @override
  List<Object?> get props => [clipboardItem];

  bool get hasClipboardItem =>
      clipboardItem?.value != null &&
      !clipboardItem!.value!.isEmpty &&
      clipboardItem!.isSuccess;
}
