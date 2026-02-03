part of 'accessibility_cubit.dart';

class AccessibilityState extends Equatable {
  const AccessibilityState({
    this.hasPermission = false,
    this.isChecking = false,
    this.showPermissionDialog = false,
  });

  final bool hasPermission;
  final bool isChecking;
  final bool showPermissionDialog;

  AccessibilityState copyWith({
    bool? hasPermission,
    bool? isChecking,
    bool? showPermissionDialog,
  }) {
    return AccessibilityState(
      hasPermission: hasPermission ?? this.hasPermission,
      isChecking: isChecking ?? this.isChecking,
      showPermissionDialog: showPermissionDialog ?? this.showPermissionDialog,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hasPermission': hasPermission,
    };
  }

  factory AccessibilityState.fromJson(Map<String, dynamic> json) {
    return AccessibilityState(
      hasPermission: json['hasPermission'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [hasPermission, isChecking, showPermissionDialog];
}
