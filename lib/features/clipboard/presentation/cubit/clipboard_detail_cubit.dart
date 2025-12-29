import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:lucid_clip/features/clipboard/domain/domain.dart';

part 'clipboard_detail_state.dart';

@lazySingleton
class ClipboardDetailCubit extends Cubit<ClipboardDetailState> {
  ClipboardDetailCubit() : super(const ClipboardDetailState());

  void setClipboardItem(ClipboardItem clipboardItem) {
    emit(state.copyWith(clipboardItem: clipboardItem.toSuccess()));
  }

  void clearSelection() {
    emit(state.copyWith(clipboardItem: null.toInitial()));
  }
}
