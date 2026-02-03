import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/platform/platform.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/utils/utils.dart';
import 'package:window_manager/window_manager.dart';

/// Implementation of [WindowController] using the window_manager package
///
/// This service manages the application window's visibility and behavior,
/// providing overlay-style showing (similar to Raycast) where the window
/// appears on top of all other windows temporarily.
@LazySingleton(as: WindowController)
class WindowControllerImpl implements WindowController {
  WindowControllerImpl({
    required this.windowManager,
    required this.macosOverlay,
    required this.sourceAppProvider,
  }) {
    initialize();
  }

  bool _isInitialized = false;

  static const positioner = OverlayPositioner();

  final WindowManager windowManager;

  final MacosOverlay macosOverlay;

  final SourceAppProvider sourceAppProvider;

  /// The app that was frontmost before LucidClip was shown
  SourceApp? _previousFrontmostApp;

  final windowOptions = const WindowOptions(
    size: Size(800, 500),
    minimumSize: Size(800, 500),
    center: true,
    title: 'LucidClip',
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );

  bool _isShowing = false;

  /// Get the app that was frontmost before LucidClip was shown
  SourceApp? get previousFrontmostApp => _previousFrontmostApp;

  @override
  bool get isShowing => _isShowing;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    await windowManager.ensureInitialized();
    _isInitialized = true;
  }

  @override
  Future<void> toggle() async {
    try {
      final isVisible = await windowManager.isVisible();

      if (isVisible) {
        await hide();
      } else {
        await showAsOverlay();
      }
    } catch (e, stackTrace) {
      log(
        'Failed to toggle window',
        error: e,
        stackTrace: stackTrace,
        name: 'WindowController',
      );
    }
  }

  @override
  Future<void> showAsOverlay() async {
    try {
      log('Showing window as overlay');

      // Capture the frontmost app before showing LucidClip
      _previousFrontmostApp = await sourceAppProvider.getFrontmostApp();
      log('Previous frontmost app: ${_previousFrontmostApp?.name}');

      _isShowing = true;

      final position = await positioner.computeTopCenterPosition(
        windowSize: windowOptions.size!,
      );

      await windowManager.setPosition(position);
      await windowManager.show();
      // await windowManager.focus();
      await setVisibleOnAllWorkspaces();
      await setAlwaysOnTop();

      log('Window shown as overlay');
    } catch (e, stackTrace) {
      _isShowing = false;
      log(
        'Failed to show window as overlay',
        error: e,
        stackTrace: stackTrace,
        name: 'WindowController',
      );
    }
  }

  @override
  Future<void> hide() async {
    try {
      _isShowing = false;

      // Clear the previous frontmost app when hiding
      _previousFrontmostApp = null;

      await setVisibleOnAllWorkspaces(visible: false);
      await windowManager.hide();

      /* if (Platform.isMacOS) {
        await macosOverlay.setFullscreenOverlay(enabled: false);
      }*/

      log('Window hidden', name: 'WindowController');
    } catch (e, stackTrace) {
      log(
        'Failed to hide window',
        error: e,
        stackTrace: stackTrace,
        name: 'WindowController',
      );
      rethrow;
    }
  }

  @override
  Future<void> show() async {
    try {
      log('Showing window normally');
      _isShowing = true;
      await windowManager.show();
      await windowManager.focus();
      log('Window shown');
    } catch (e, stackTrace) {
      _isShowing = false;
      log(
        'Failed to show window',
        error: e,
        stackTrace: stackTrace,
        name: 'WindowController',
      );
    }
  }

  @override
  Future<void> setAlwaysOnTop({bool alwaysOnTop = true}) async {
    try {
      await windowManager.setAlwaysOnTop(alwaysOnTop);
      log('Always on top set to: $alwaysOnTop');
    } catch (e, stackTrace) {
      log(
        'Failed to set always-on-top',
        error: e,
        stackTrace: stackTrace,
        name: 'WindowController',
      );
    }
  }

  @override
  Future<void> setVisibleOnAllWorkspaces({bool visible = true}) async {
    try {
      await windowManager.setVisibleOnAllWorkspaces(
        visible,
        visibleOnFullScreen: true,
      );
      log('Visible on all workspaces set to: $visible');
    } catch (e, stackTrace) {
      log(
        'Failed to set visible on all workspaces',
        error: e,
        stackTrace: stackTrace,
        name: 'WindowController',
      );
    }
  }

  @override
  Future<void> focus() async {
    try {
      await windowManager.focus();
      log('Window focused');
    } catch (e, stackTrace) {
      log(
        'Failed to focus window',
        error: e,
        stackTrace: stackTrace,
        name: 'WindowController',
      );
    }
  }

  @disposeMethod
  @override
  Future<void> dispose() async {
    log('Disposing WindowController');
    _isShowing = false;
  }

  @override
  Future<void> bootstrapWindow() async {
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setSkipTaskbar(true);
      await windowManager.setAsFrameless();
      await windowManager.setPreventClose(true);
      await windowManager.setHasShadow(true);

      await showAsOverlay();
    });
  }
}
