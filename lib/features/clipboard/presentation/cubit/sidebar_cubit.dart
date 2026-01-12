import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SidebarCubit extends HydratedCubit<bool> {
  SidebarCubit() : super(true);

  void toggle() => emit(!state);

  void expand() => emit(true);

  void collapse() => emit(false);

  @override
  bool? fromJson(Map<String, dynamic> json) {
    return json['isExpanded'] as bool?;
  }

  @override
  Map<String, dynamic>? toJson(bool state) {
    return {'isExpanded': state};
  }

  @disposeMethod
  @override
  Future<void> close() {
    return super.close();
  }
}
