// lib/features/entitlement/presentation/upgrade/upgrade_prompt_cubit.dart

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';

@lazySingleton
class UpgradePromptCubit extends HydratedCubit<UpgradePromptState> {
  UpgradePromptCubit() : super(const UpgradePromptState());

  void request(ProFeature feature, {ProFeatureRequestSource? source}) {
    emit(UpgradePromptState(requestedFeature: feature, source: source));
  }

  void clearState() => emit(const UpgradePromptState());

  @disposeMethod
  @override
  Future<void> close() {
    return super.close();
  }

  @override
  UpgradePromptState? fromJson(Map<String, dynamic> json) {
    try {
      return UpgradePromptState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UpgradePromptState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
