// lib/features/entitlement/presentation/upgrade/upgrade_prompt_state.dart

import 'package:equatable/equatable.dart';
import 'package:lucid_clip/features/entitlement/subfeatures/upgrade/upgrade.dart';

class UpgradePromptState extends Equatable {
  const UpgradePromptState({this.requestedFeature, this.source});

  final ProFeature? requestedFeature;

  /// Optional: where it came from (e.g. "pin_button", "ignored_apps")
  final ProFeatureRequestSource? source;

  bool get hasRequest => requestedFeature != null;

  UpgradePromptState copyWith({
    ProFeature? requestedFeature,
    ProFeatureRequestSource? source,
    bool clear = false,
  }) {
    if (clear) return const UpgradePromptState();
    return UpgradePromptState(
      requestedFeature: requestedFeature ?? this.requestedFeature,
      source: source ?? this.source,
    );
  }

  @override
  List<Object?> get props => [requestedFeature, source];
}
