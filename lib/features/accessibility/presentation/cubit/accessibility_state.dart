part of 'accessibility_cubit.dart';

class AccessibilityState extends Equatable {
  const AccessibilityState({
    this.hasPermission = false,
    this.isChecking = false,
    this.showPermissionDialog = false,
  });

  factory AccessibilityState.fromJson(Map<String, dynamic> json) =>
      AccessibilityState(
        hasPermission: json['hasPermission'] as bool? ?? false,
      );

  final bool hasPermission;
  final bool isChecking;
  final bool showPermissionDialog;

  AccessibilityState copyWith({
    bool? hasPermission,
    bool? isChecking,
    bool? showPermissionDialog,
  }) => AccessibilityState(
    hasPermission: hasPermission ?? this.hasPermission,
    isChecking: isChecking ?? this.isChecking,
    showPermissionDialog: showPermissionDialog ?? this.showPermissionDialog,
  );

  Map<String, dynamic> toJson() => {'hasPermission': hasPermission};

  @override
  List<Object?> get props => [hasPermission, isChecking, showPermissionDialog];
}
