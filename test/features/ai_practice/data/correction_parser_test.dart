import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/features/ai_practice/data/correction_parser.dart';

void main() {
  group('CorrectionParser.parse', () {
    test('returns cleaned text and correction when marker is present', () {
      const input =
          '[CORRECTION: "I go to store yesterday" → "I went to the store yesterday" | Use past tense for completed actions]\n'
          'That\'s a great story!';

      final result = CorrectionParser.parse(input);

      expect(result.cleanedText, 'That\'s a great story!');
      expect(result.correction, isNotNull);
      expect(result.correction!.original, 'I go to store yesterday');
      expect(result.correction!.corrected, 'I went to the store yesterday');
      expect(
        result.correction!.explanation,
        'Use past tense for completed actions',
      );
    });

    test('returns unchanged text and null correction when no marker present',
        () {
      const input = 'Nice to meet you! How are you today?';
      final result = CorrectionParser.parse(input);

      expect(result.cleanedText, input);
      expect(result.correction, isNull);
    });

    test(
        'returns unchanged text and null correction for malformed marker '
        '(no closing bracket)', () {
      const input =
          '[CORRECTION: "More better" → "Much better" | missing closing bracket';
      final result = CorrectionParser.parse(input);

      expect(result.cleanedText, input);
      expect(result.correction, isNull);
    });

    test('handles marker with no trailing newline', () {
      const input =
          '[CORRECTION: "he go" → "he goes" | Subject-verb agreement]Great.';

      final result = CorrectionParser.parse(input);

      expect(result.cleanedText, 'Great.');
      expect(result.correction, isNotNull);
      expect(result.correction!.original, 'he go');
      expect(result.correction!.corrected, 'he goes');
      expect(result.correction!.explanation, 'Subject-verb agreement');
    });

    test('handles empty input', () {
      final result = CorrectionParser.parse('');
      expect(result.cleanedText, '');
      expect(result.correction, isNull);
    });

    test('handles marker with extra whitespace around arrow and pipe', () {
      const input =
          '[CORRECTION:  "more better"  →  "much better"  |  Use "much" not "more" with comparatives  ]\nOkay!';

      final result = CorrectionParser.parse(input);

      expect(result.cleanedText, 'Okay!');
      expect(result.correction, isNotNull);
      expect(result.correction!.original, 'more better');
      expect(result.correction!.corrected, 'much better');
      expect(
        result.correction!.explanation,
        'Use "much" not "more" with comparatives',
      );
    });

    test('marker not at start of string is treated as no match', () {
      const input =
          'Some preamble. [CORRECTION: "foo" → "bar" | explanation]\nRest.';
      final result = CorrectionParser.parse(input);

      expect(result.cleanedText, input);
      expect(result.correction, isNull);
    });
  });

  group('CorrectionParser.bufferMayHaveMarker', () {
    test('returns true when buffer starts with [CORRECTION:', () {
      expect(
        CorrectionParser.bufferMayHaveMarker('[CORRECTION: "foo"'),
        isTrue,
      );
    });

    test('returns false when buffer does not start with [CORRECTION:', () {
      expect(CorrectionParser.bufferMayHaveMarker('Hello there'), isFalse);
    });
  });

  group('CorrectionParser.markerIsClosed', () {
    test('returns true when buffer contains closing ]', () {
      expect(
        CorrectionParser.markerIsClosed(
          '[CORRECTION: "foo" → "bar" | expl]',
        ),
        isTrue,
      );
    });

    test('returns false when no closing ] found', () {
      expect(
        CorrectionParser.markerIsClosed('[CORRECTION: "foo" → "bar"'),
        isFalse,
      );
    });

    test('returns false when buffer does not start with [CORRECTION:', () {
      expect(CorrectionParser.markerIsClosed('Hello]'), isFalse);
    });
  });
}
