import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/feedback/feedback_service.dart';
import 'package:wiredash/wiredash.dart';

/// WireDash implementation of FeedbackService.
///
/// This implementation uses WireDash to collect user feedback,
/// bug reports, and feature requests.
///
/// The service is flexible and reusable - it can be called from any
/// widget context to show the feedback UI.
@LazySingleton(as: FeedbackService)
class WiredashFeedbackService implements FeedbackService {
  WiredashFeedbackService({
    @Named('wiredashProjectId') required this.wiredashProjectId,
    @Named('wiredashSecret') required this.wiredashSecret,
  });

  final String wiredashProjectId;
  final String wiredashSecret;
  
  // Store metadata to be applied when showing feedback
  final Map<String, dynamic> _metadata = {};

  @override
  bool get isAvailable =>
      wiredashProjectId.isNotEmpty && wiredashSecret.isNotEmpty;

  @override
  Future<void> show(BuildContext context) async {
    if (!isAvailable) {
      debugPrint('Feedback: WireDash not configured (missing credentials)');
      return;
    }

    try {
      // Get Wiredash instance from context and show feedback
      final wiredash = Wiredash.of(context);
      if (wiredash != null) {
        // Apply any stored metadata
        if (_metadata.isNotEmpty) {
          wiredash.setUserProperties(
            userIdentifier: _metadata['userId'] as String?,
            userEmail: _metadata['userEmail'] as String?,
          );
        }
        
        // Show the feedback UI
        wiredash.show();
      } else {
        debugPrint('Feedback: Wiredash widget not found in context');
      }
    } catch (e) {
      debugPrint('Feedback error showing UI: $e');
    }
  }

  @override
  Future<void> setMetadata(Map<String, dynamic> metadata) async {
    try {
      _metadata.addAll(metadata);
      debugPrint('Feedback: metadata set: $metadata');
    } catch (e) {
      debugPrint('Feedback error setting metadata: $e');
    }
  }

  @override
  Future<void> clearMetadata() async {
    try {
      _metadata.clear();
      debugPrint('Feedback: metadata cleared');
    } catch (e) {
      debugPrint('Feedback error clearing metadata: $e');
    }
  }
}
