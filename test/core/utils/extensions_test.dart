import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/core/utils/extensions.dart';

void main() {
  group('DateTimeExtensions', () {
    test('isToday returns true for today', () {
      final today = DateTime.now();
      expect(today.isToday, isTrue);
    });

    test('isToday returns false for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isToday, isFalse);
    });

    test('isYesterday returns true for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isYesterday, isTrue);
    });

    test('isYesterday returns false for today', () {
      final today = DateTime.now();
      expect(today.isYesterday, isFalse);
    });

    test('isThisWeek returns true for date within this week', () {
      final today = DateTime.now();
      expect(today.isThisWeek, isTrue);
    });

    test('toRelativeString returns "Just now" for recent times', () {
      final now = DateTime.now();
      expect(now.toRelativeString(), 'Just now');
    });

    test('toRelativeString returns minutes ago', () {
      final fiveMinAgo = DateTime.now().subtract(const Duration(minutes: 5));
      expect(fiveMinAgo.toRelativeString(), '5 minutes ago');
    });

    test('toRelativeString returns hours ago', () {
      final twoHoursAgo = DateTime.now().subtract(const Duration(hours: 2));
      expect(twoHoursAgo.toRelativeString(), '2 hours ago');
    });

    test('toRelativeString returns Yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.toRelativeString(), 'Yesterday');
    });

    test('toRelativeString returns days ago', () {
      final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));
      expect(threeDaysAgo.toRelativeString(), '3 days ago');
    });

    test('toDateString returns correct format', () {
      final date = DateTime(2024, 1, 15);
      expect(date.toDateString(), 'Jan 15, 2024');
    });
  });

  group('DurationExtensions', () {
    test('toCallDurationString returns mm:ss for short durations', () {
      const duration = Duration(minutes: 5, seconds: 30);
      expect(duration.toCallDurationString(), '05:30');
    });

    test('toCallDurationString returns hh:mm:ss for long durations', () {
      const duration = Duration(hours: 1, minutes: 30, seconds: 45);
      expect(duration.toCallDurationString(), '01:30:45');
    });

    test('toCallDurationString handles zero seconds', () {
      const duration = Duration(minutes: 2);
      expect(duration.toCallDurationString(), '02:00');
    });

    test('toReadableDuration returns readable format for hours', () {
      const duration = Duration(hours: 1, minutes: 30);
      expect(duration.toReadableDuration(), '1h 30m');
    });

    test('toReadableDuration returns readable format for minutes', () {
      const duration = Duration(minutes: 5, seconds: 30);
      expect(duration.toReadableDuration(), '5m 30s');
    });

    test('toReadableDuration returns readable format for seconds', () {
      const duration = Duration(seconds: 45);
      expect(duration.toReadableDuration(), '45s');
    });
  });

  group('StringExtensions', () {
    test('capitalize capitalizes first letter', () {
      expect('hello'.capitalize(), 'Hello');
      expect('WORLD'.capitalize(), 'WORLD');
    });

    test('capitalize handles empty string', () {
      expect(''.capitalize(), '');
    });

    test('capitalize handles single character', () {
      expect('a'.capitalize(), 'A');
    });

    test('getInitials returns correct initials', () {
      expect('John Doe'.getInitials(), 'JD');
      expect('Alice'.getInitials(), 'A');
      expect('John Paul Smith'.getInitials(), 'JP');
    });

    test('getInitials respects maxLength', () {
      expect('John Paul Smith'.getInitials(maxLength: 3), 'JPS');
    });

    test('truncate shortens long strings', () {
      expect('Hello World'.truncate(8), 'Hello...');
      expect('Hi'.truncate(5), 'Hi');
    });

    test('truncate uses custom ellipsis', () {
      expect('Hello World'.truncate(8, ellipsis: '…'), 'Hello W…');
    });
  });
}
