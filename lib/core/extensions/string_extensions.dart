extension StringExtensions on String {
  /// Capitalizes the first letter of the string.
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Checks if the string is a valid email format.
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isNullOrEmpty => isEmpty;

  bool get isUrl {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?' // Optional protocol
      r'((([a-zA-Z0-9\-_]+\.)+[a-zA-Z]{2,})|' // Domain name
      'localhost|' // OR localhost
      r'(\d{1,3}\.){3}\d{1,3})' // OR IP (v4) address
      r'(:\d+)?(\/[^\s]*)?$', // Optional port and path
    );
    return urlRegex.hasMatch(this);
  }

  bool get isCodeSnippet {
    final codeSnippetRegex = RegExp(
      r'(```[\s\S]*?```|~~~[\s\S]*?~~~|`[^`]+`|<code>[\s\S]*?<\/code>|<pre>[\s\S]*?<\/pre>)',
    );
    return codeSnippetRegex.hasMatch(this);
  }

  /// Reverses the string.
  String reverse() {
    return split('').reversed.join();
  }
}
