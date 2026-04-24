import '../../../shared/models/ai_session.dart';

/// Result of parsing an AI message for correction markers.
class CorrectionParseResult {
  /// Message text with any correction marker stripped.
  final String cleanedText;

  /// Parsed correction, or null if none was present.
  final Correction? correction;

  const CorrectionParseResult({
    required this.cleanedText,
    this.correction,
  });
}

/// Pure, unit-testable helper that extracts `[CORRECTION: ...]` markers from
/// AI response text.
///
/// Expected marker format (always at the very start of the message):
///   `[CORRECTION: "original" → "corrected" | explanation]\n?`
///
/// Rules:
/// - If the marker is present and well-formed, [cleanedText] has it removed
///   and [correction] is populated.
/// - If the marker is absent, the text is returned unchanged and [correction]
///   is null.
/// - A malformed marker (e.g. missing closing `]`) is treated as absent — the
///   method never throws.
class CorrectionParser {
  // Anchored at start of string, multiLine is false so ^ matches string start.
  // Group 1 = original, group 2 = corrected, group 3 = explanation.
  static final RegExp _markerPattern = RegExp(
    r'^\[CORRECTION:\s*"([^"]+)"\s*→\s*"([^"]+)"\s*\|\s*([^\]]+)\]\n?',
    dotAll: true,
  );

  /// Parse [text] and return a [CorrectionParseResult].
  static CorrectionParseResult parse(String text) {
    try {
      final match = _markerPattern.firstMatch(text);
      if (match == null) {
        return CorrectionParseResult(cleanedText: text);
      }

      final original = match.group(1)!.trim();
      final corrected = match.group(2)!.trim();
      final explanation = match.group(3)!.trim();

      final cleaned = text.substring(match.end);

      return CorrectionParseResult(
        cleanedText: cleaned,
        correction: Correction(
          original: original,
          corrected: corrected,
          explanation: explanation,
        ),
      );
    } catch (_) {
      // Never crash — return the text unchanged.
      return CorrectionParseResult(cleanedText: text);
    }
  }

  /// Returns true if [buffer] starts with `[CORRECTION:` (i.e. a marker may
  /// be in progress).  Used during streaming to decide whether to delay TTS.
  static bool bufferMayHaveMarker(String buffer) {
    return buffer.startsWith('[CORRECTION:');
  }

  /// Returns true once an in-progress correction marker is fully closed
  /// (closing `]` found), allowing TTS to start on the remainder.
  static bool markerIsClosed(String buffer) {
    if (!bufferMayHaveMarker(buffer)) return false;
    return buffer.contains(']');
  }
}
