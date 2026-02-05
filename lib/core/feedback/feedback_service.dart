import 'package:flutter/widgets.dart';

/// Abstract feedback service interface for collecting user feedback.
///
/// Implementations should:
/// - Provide a way to show feedback UI
/// - Support custom metadata
/// - Handle feedback submission
abstract class FeedbackService {
  /// Show the feedback UI to the user
  /// Requires a BuildContext to show the feedback widget
  Future<void> show(BuildContext context);

  /// Set custom metadata for feedback context
  Future<void> setMetadata(Map<String, dynamic> metadata);

  /// Clear all metadata
  Future<void> clearMetadata();

  /// Check if feedback is available/configured
  bool get isAvailable;
}
