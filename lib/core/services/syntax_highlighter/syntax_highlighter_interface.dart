import 'package:flutter/material.dart';

/// Interface for syntax highlighting service
abstract class SyntaxHighlighter {
  /// Highlight code content and return a widget with syntax highlighting
  ///
  /// [code] The code content to highlight
  /// [language] Optional language hint for better detection
  /// [theme] Optional theme for syntax highlighting
  Widget highlight({
    required String code,
    String? language,
    Brightness? theme,
  });

  /// Detect if the given content is likely to be code
  ///
  /// Returns true if the content appears to be code
  bool isCode(String content);

  /// Detect the programming language of the given code
  ///
  /// Returns the detected language or null if unable to detect
  String? detectLanguage(String code);
}
