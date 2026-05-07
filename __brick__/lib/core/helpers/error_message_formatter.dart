import 'dart:developer';

import '/core/helpers/network_exception.dart';

class ErrorMessageFormatter {
  static String format(Object error, [StackTrace? stackTrace]) {
    if (error is Error) {
      log(error.stackTrace.toString());
    }
    if (error is NetworkException) {
      return error.message;
    }

    final raw = error.toString().trim();
    final source = _extractDecoderSource(stackTrace, raw);

    final formatMatch = RegExp(r"Expected non-null ([^ ]+) for '([^']+)'").firstMatch(raw);
    if (formatMatch != null) {
      final expected = formatMatch.group(1)!;
      final field = formatMatch.group(2)!;
      return _withSource(
        source,
        "Invalid API payload: field '$field' is missing/null, expected $expected.",
      );
    }

    final nullSubtypeMatch = RegExp(r"type 'Null' is not a subtype of type '([^']+)'").firstMatch(raw);
    if (nullSubtypeMatch != null) {
      final expected = nullSubtypeMatch.group(1)!;
      final fieldFromMessage =
          RegExp(r"\['([^']+)'\]").firstMatch(raw)?.group(1) ??
          RegExp(r'\["([^"]+)"\]').firstMatch(raw)?.group(1);
      if (fieldFromMessage != null) {
        return _withSource(
          source,
          "Invalid API payload: field '$fieldFromMessage' is null/missing, expected $expected.",
        );
      }
      return _withSource(
        source,
        "Invalid API payload: a required field is null/missing, expected $expected.",
      );
    }

    return raw.isEmpty ? 'Unknown error' : raw;
  }

  static String _withSource(String? source, String message) {
    if (source == null || source.isEmpty) return message;
    return "$message (while decoding $source)";
  }

  static String? _extractDecoderSource(StackTrace? stackTrace, String fallback) {
    final fromStack = stackTrace == null
        ? null
        : RegExp(r'([A-Za-z0-9_]+)\.fromJson').firstMatch(stackTrace.toString())?.group(1);
    if (fromStack != null) return fromStack;
    return RegExp(r'([A-Za-z0-9_]+)\.fromJson').firstMatch(fallback)?.group(1);
  }
}
