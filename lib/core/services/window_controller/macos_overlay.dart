abstract class MacosOverlay {
  Future<void> activateApp();

  Future<void> setFullscreenOverlay({bool enabled = true});
}
