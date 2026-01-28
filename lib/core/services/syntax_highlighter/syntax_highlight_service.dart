import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark-reasonable.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/services/services.dart';
import 'package:lucid_clip/core/theme/app_spacing.dart';

@LazySingleton(as: SyntaxHighlighter)
class SyntaxHighlightService implements SyntaxHighlighter {
  const SyntaxHighlightService();

  @override
  Future<void> initialize() async {}

  @override
  Widget highlight({
    required String code,
    String? language,
    Brightness theme = Brightness.dark,
  }) {
    try {
      final detectedLang = language ?? detectLanguage(code) ?? 'dart';

      final highlightTheme = (theme == Brightness.dark)
          ? atomOneDarkReasonableTheme
          : githubTheme;

      final highlighted = HighlightView(
        code,
        language: detectedLang,
        theme: highlightTheme,
        padding: const EdgeInsets.all(AppSpacing.xs),
        textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      );

      return highlighted;
    } catch (e) {
      log(
        'SyntaxHighlightService.highlight: Failed to highlight code. Error: $e',
        name: 'SyntaxHighlightService',
      );
      // Fallback to plain text if highlighting fails
      return SelectableText(
        code,
        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
      );
    }
  }

  @override
  bool isCode(String content) {
    if (content.isEmpty || content.length < 50) return false;

    // Check for common code patterns
    final codeIndicators = [
      // Common code structures
      RegExp(r'\bfunction\s+\w+\s*\('),
      RegExp(r'\bclass\s+\w+'),
      RegExp(r'\bdef\s+\w+\s*\('),
      RegExp(r'\bpublic\s+(?:static\s+)?(?:void|int|String)'),
      RegExp(r'\bprivate\s+(?:static\s+)?(?:void|int|String)'),
      RegExp(r'\bconst\s+\w+\s*='),
      RegExp(r'\blet\s+\w+\s*='),
      RegExp(r'\bvar\s+\w+\s*='),
      RegExp(r'\bimport\s+[\w.]+'),
      // Use a triple-quoted raw string so both ' and " can appear safely.
      RegExp(r'''\bfrom\s+["']+[\w./]+["']+'''),
      RegExp(r'''\brequire\s*\(["']'''),
      RegExp(r'^\s*#include\s*<'),
      RegExp(r'^\s*package\s+\w+'),

      // Common syntax patterns
      RegExp('=>'),
      RegExp(r'\{[^}]*\}'),
      RegExp(r'\[[^\]]*\]'),
      RegExp(r';\s*$', multiLine: true),

      // JSON pattern
      RegExp(r'^\s*\{[\s\S]*"\w+"[\s\S]*:[\s\S]*\}'),

      // XML/HTML pattern
      RegExp('<[a-zA-Z][^>]*>'),
    ];

    var matchCount = 0;
    for (final pattern in codeIndicators) {
      if (pattern.hasMatch(content)) {
        matchCount++;
      }
    }

    // If we have 2 or more indicators, consider it code
    if (matchCount >= 2) return true;

    // Check line structure - code typically has specific indentation patterns
    final lines = content.split('\n');
    if (lines.length > 3) {
      var indentedLines = 0;
      var linesWithSpecialChars = 0;

      for (final line in lines) {
        if (line.startsWith('  ') || line.startsWith('\t')) {
          indentedLines++;
        }
        if (line.contains('{') ||
            line.contains('}') ||
            line.contains(';') ||
            (line.contains('(') && line.contains(')'))) {
          linesWithSpecialChars++;
        }
      }

      // If more than 30% of lines are indented and have special chars
      if (indentedLines > lines.length * 0.2 &&
          linesWithSpecialChars > lines.length * 0.2) {
        return true;
      }
    }

    return false;
  }

  @override
  String? detectLanguage(String code) {
    // Simple heuristic-based language detection

    // Dart
    if (code.contains("import 'package:") ||
        (code.contains('class') && code.contains('extends')) ||
        code.contains('void main(') ||
        code.contains('@override')) {
      return 'dart';
    }

    // JavaScript/TypeScript
    if ((code.contains('const ') && code.contains('=>')) ||
        code.contains('function ') ||
        code.contains('console.log') ||
        code.contains('require(') ||
        code.contains('export ')) {
      if (code.contains(': string') ||
          code.contains(': number') ||
          code.contains('interface ')) {
        return 'typescript';
      }
      return 'javascript';
    }

    // Python
    if (code.contains('def ') ||
        (code.contains('import ') && !code.contains("import '")) ||
        code.contains('if __name__ == "__main__"') ||
        code.contains('self.') ||
        code.contains('print(')) {
      return 'python';
    }

    // Java
    if (code.contains('public class') ||
        code.contains('public static void main') ||
        code.contains('import java.')) {
      return 'java';
    }

    // Kotlin
    if (code.contains('fun ') ||
        code.contains('val ') ||
        code.contains('import kotlin.')) {
      return 'kotlin';
    }

    // Swift
    if (code.contains('import UIKit') ||
        (code.contains('func ') && code.contains('->')) ||
        (code.contains('var ') && code.contains(': '))) {
      return 'swift';
    }

    // Go
    if (code.contains('package main') ||
        (code.contains('func ') && code.contains('{')) ||
        code.contains('import (')) {
      return 'go';
    }

    // Rust
    if (code.contains('fn ') ||
        code.contains('let mut') ||
        code.contains('use std::')) {
      return 'rust';
    }

    // C/C++
    if (code.contains('#include <') ||
        code.contains('int main(') ||
        code.contains('std::')) {
      if (code.contains('std::') ||
          (code.contains('class') && code.contains('public:'))) {
        return 'cpp';
      }
      return 'c';
    }

    // C#
    if (code.contains('using System') ||
        code.contains('namespace ') ||
        (code.contains('public class') && code.contains('Main(string[]'))) {
      return 'csharp';
    }

    // JSON
    if (code.trim().startsWith('{') &&
        code.contains('"') &&
        code.contains(':')) {
      return 'json';
    }

    // YAML
    if (code.contains(':\n') || (code.contains(': ') && !code.contains(';'))) {
      return 'yaml';
    }

    // HTML
    if (code.contains('<!DOCTYPE') ||
        code.contains('<html') ||
        code.contains('<div') ||
        code.contains('<p>')) {
      return 'html';
    }

    // XML
    if (code.contains('<?xml') ||
        ((code.contains('<') && code.contains('/>')) &&
            !code.contains('<html'))) {
      return 'xml';
    }

    // CSS
    if ((code.contains('{') && code.contains('}')) &&
        (code.contains('color:') ||
            code.contains('margin:') ||
            code.contains('padding:') ||
            code.contains('font-'))) {
      return 'css';
    }

    // SQL
    if (code.toUpperCase().contains('SELECT ') ||
        code.toUpperCase().contains('INSERT INTO') ||
        code.toUpperCase().contains('UPDATE ') ||
        code.toUpperCase().contains('DELETE FROM')) {
      return 'sql';
    }

    // PHP
    if (code.contains('<?php') ||
        (code.contains('function ') && code.contains(r'$'))) {
      return 'php';
    }

    // Ruby
    if ((code.contains('def ') && code.contains('end')) ||
        code.contains("require '") ||
        (code.contains('class ') && code.contains('< '))) {
      return 'ruby';
    }

    // Shell/Bash
    if (code.startsWith('#!/bin/bash') ||
        code.startsWith('#!/bin/sh') ||
        (code.contains('echo ') && code.contains(r'$'))) {
      return 'bash';
    }

    return null;
  }
}
