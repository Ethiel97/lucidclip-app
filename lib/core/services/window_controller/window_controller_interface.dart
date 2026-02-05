import 'package:lucid_clip/core/platform/platform.dart';

/// Interface for managing application window visibility and behavior
abstract class WindowController {
  /// Check if the window is currently showing
  bool get isShowing;

  SourceApp? get previousFrontmostApp;

  /// Toggle window visibility (show if hidden, hide if showing)
  Future<void> toggle();

  /// Show the window as an overlay with focus
  ///
  /// This method will:
  /// - Show and focus the window
  /// - Bring it to the front of all windows
  /// - Temporarily set it as always-on-top
  /// - Restore normal window behavior after a brief delay
  ///

  Future<void> initialize();

  Future<void> bootstrapWindow();

  Future<void> showAsOverlay();

  /// Hide the window
  Future<void> hide();

  /// Show the window normally (without overlay behavior)
  Future<void> show();

  /// Set window to always stay on top
  Future<void> setAlwaysOnTop({bool alwaysOnTop = true});

  /// Set window to be visible on all workspaces/desktops
  Future<void> setVisibleOnAllWorkspaces({bool visible = true});

  /// Focus the window (bring to front without changing visibility)
  Future<void> focus();

  /// Dispose resources
  Future<void> dispose();

  Future<void> quit();
}
