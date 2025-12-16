import 'package:uuid/uuid.dart';

/// Utility class for generating unique identifiers
class IdGenerator {
  static const Uuid _uuid = Uuid();

  /// Generates a unique ID using UUID v4
  static String generate() {
    return _uuid.v4();
  }

  /// Generates a unique ID with a custom prefix
  /// Example: generateWithPrefix('clip') returns 'clip_550e8400-e29b-41d4-a716-446655440000'
  static String generateWithPrefix(String prefix) {
    return '${prefix}_${_uuid.v4()}';
  }
}
