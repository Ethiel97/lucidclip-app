// lib/features/entitlement/presentation/upgrade/upgrade_prompt_state.dart

import 'package:equatable/equatable.dart';
import 'package:lucid_clip/features/entitlement/subfeatures/upgrade/upgrade.dart';

class UpgradePromptState extends Equatable {
  const UpgradePromptState({this.requestedFeature, this.source});

  factory UpgradePromptState.fromJson(Map<String, dynamic> json) {
    return UpgradePromptState(
      requestedFeature: json['requestedFeature'] != null
          ? ProFeature.values.firstWhere(
              (e) => e.toString() == json['requestedFeature'],
              orElse: () => ProFeature.pinItems,
            )
          : null,
      source: json['source'] != null
          ? ProFeatureRequestSource.values.firstWhere(
              (e) => e.toString() == json['source'],
              orElse: () => ProFeatureRequestSource.pinButton,
            )
          : null,
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'requestedFeature': requestedFeature?.toString(),
      'source': source?.toString(),
    };
  }

  @override
  List<Object?> get props => [requestedFeature, source];
}
