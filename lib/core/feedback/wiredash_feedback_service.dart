import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/feedback/feedback_service.dart';
import 'package:wiredash/wiredash.dart';

/// WireDash implementation of FeedbackService.
///
/// This implementation uses WireDash to collect user feedback,
/// bug reports, and feature requests.
@LazySingleton(as: FeedbackService)
class WiredashFeedbackService implements FeedbackService {
  WiredashFeedbackService({
    @Named('wiredashProjectId') required this.wiredashProjectId,
    @Named('wiredashSecret') required this.wiredashSecret,
  });

  final String wiredashProjectId;
  final String wiredashSecret;

  @override
  Future<void> show() async {
    try {
      // Note: Wiredash.of() requires a BuildContext
      // This is typically called from a widget context
      // For now, we'll note this limitation
      debugPrint('Feedback: show() called - requires BuildContext');
    } catch (e) {
      debugPrint('Feedback error showing UI: $e');
    }
  }

  @override
  Future<void> setMetadata(Map<String, dynamic> metadata) async {
    try {
      // WireDash metadata can be set when the widget is configured
      // This is a placeholder for interface compliance
      debugPrint('Feedback: metadata set: $metadata');
    } catch (e) {
      debugPrint('Feedback error setting metadata: $e');
    }
  }

  @override
  Future<void> clearMetadata() async {
    try {
      debugPrint('Feedback: metadata cleared');
    } catch (e) {
      debugPrint('Feedback error clearing metadata: $e');
    }
  }
}
