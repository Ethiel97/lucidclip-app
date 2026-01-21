// lib/features/entitlement/presentation/upgrade/upgrade_prompt_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/features/entitlement/entitlement.dart';

@lazySingleton
class UpgradePromptCubit extends Cubit<UpgradePromptState> {
  UpgradePromptCubit() : super(const UpgradePromptState());

  void request(ProFeature feature, {ProFeatureRequestSource? source}) {
    emit(UpgradePromptState(requestedFeature: feature, source: source));
  }

  void clear() => emit(const UpgradePromptState());
}
