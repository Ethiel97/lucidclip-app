abstract class TrayManagerService {
  Future<void> initialize();

  void startWatchingClipboard();

  Future<void> updateTrayMenu();

  void dispose();
}
