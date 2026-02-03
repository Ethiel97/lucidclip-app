abstract class AccessibilityRepository {
  Future<bool> checkPermission();
  Future<bool> requestPermission();
}
