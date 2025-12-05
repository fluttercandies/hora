import 'package:hora/hora.dart';
import 'package:test/test.dart';

void main() {
  group('HoraDuration Creation', () {
    test('zero duration', () {
      expect(HoraDuration.zero.isZero, isTrue);
    });

    test('from components', () {
      final d = HoraDuration(
        years: 1,
        months: 2,
        days: 3,
        hours: 4,
        minutes: 5,
        seconds: 6,
      );
      expect(d.years, 1);
      expect(d.months, 2);
      expect(d.days, 3);
      expect(d.hours, 4);
      expect(d.minutes, 5);
      expect(d.seconds, 6);
    });

    test('convenience constructors', () {
      expect(HoraDuration.ofYears(2).years, 2);
      expect(HoraDuration.ofMonths(6).months, 6);
      expect(HoraDuration.ofWeeks(2).weeks, 2);
      expect(HoraDuration.ofDays(10).days, 10);
      expect(HoraDuration.ofHours(24).hours, 24);
      expect(HoraDuration.ofMinutes(60).minutes, 60);
      expect(HoraDuration.ofSeconds(120).seconds, 120);
    });

    test('negative durations', () {
      final d = HoraDuration.ofDays(-5);
      expect(d.isNegative, isTrue);
      expect(d.days, 5);
    });

    test('fromDuration()', () {
      final d = HoraDuration.fromDuration(const Duration(hours: 25));
      expect(d.inHours, 25);
    });

    test('between() two Hora instances', () {
      final start = Hora.of(year: 2023, day: 15);
      final end = Hora.of(year: 2024, month: 3, day: 20);
      final d = HoraDuration.between(start, end);
      expect(d.years, 1);
      expect(d.months, 2);
      expect(d.days, 5);
    });
  });

  group('HoraDuration ISO 8601 Parsing', () {
    test('parse years', () {
      final d = HoraDuration.parse('P2Y');
      expect(d.years, 2);
    });

    test('parse months', () {
      final d = HoraDuration.parse('P6M');
      expect(d.months, 6);
    });

    test('parse weeks', () {
      final d = HoraDuration.parse('P3W');
      expect(d.weeks, 3);
    });

    test('parse days', () {
      final d = HoraDuration.parse('P10D');
      expect(d.days, 10);
    });

    test('parse time components', () {
      final d = HoraDuration.parse('PT4H30M15S');
      expect(d.hours, 4);
      expect(d.minutes, 30);
      expect(d.seconds, 15);
    });

    test('parse full duration', () {
      final d = HoraDuration.parse('P1Y2M3DT4H5M6S');
      expect(d.years, 1);
      expect(d.months, 2);
      expect(d.days, 3);
      expect(d.hours, 4);
      expect(d.minutes, 5);
      expect(d.seconds, 6);
    });

    test('parse negative duration', () {
      final d = HoraDuration.parse('-P1D');
      expect(d.isNegative, isTrue);
      expect(d.days, 1);
    });

    test('tryParse returns null for invalid', () {
      expect(HoraDuration.tryParse('invalid'), isNull);
    });

    test('parse throws for invalid', () {
      expect(() => HoraDuration.parse('invalid'), throwsFormatException);
    });
  });

  group('HoraDuration Calculations', () {
    test('inMonths', () {
      final d = HoraDuration(years: 2, months: 6);
      expect(d.inMonths, 30);
    });

    test('inDays', () {
      final d = HoraDuration(weeks: 2, days: 3);
      expect(d.inDays, 17);
    });

    test('inHours', () {
      final d = HoraDuration(days: 1, hours: 6);
      expect(d.inHours, 30);
    });

    test('inMinutes', () {
      final d = HoraDuration(hours: 2, minutes: 30);
      expect(d.inMinutes, 150);
    });

    test('inSeconds', () {
      final d = HoraDuration(minutes: 2, seconds: 30);
      expect(d.inSeconds, 150);
    });
  });

  group('HoraDuration Arithmetic', () {
    test('addition', () {
      final d1 = HoraDuration(days: 5);
      final d2 = HoraDuration(days: 3);
      final sum = d1 + d2;
      expect(sum.days, 8);
    });

    test('addition with different units', () {
      final d1 = HoraDuration(months: 1);
      final d2 = HoraDuration(days: 15);
      final sum = d1 + d2;
      expect(sum.months, 1);
      expect(sum.days, 15);
    });

    test('subtraction', () {
      final d1 = HoraDuration(days: 10);
      final d2 = HoraDuration(days: 3);
      final diff = d1 - d2;
      expect(diff.days, 7);
      // Normalize if needed
      final normalized = diff.normalize();
      expect(normalized.days, 0);
      expect(normalized.weeks, 1);
    });

    test('multiplication', () {
      final d = HoraDuration(days: 5);
      final result = d * 3;
      expect(result.inDays, 15);
    });

    test('abs()', () {
      final d = HoraDuration(days: 5, isNegative: true);
      expect(d.abs().isNegative, isFalse);
    });

    test('negate()', () {
      final d = HoraDuration(days: 5);
      expect(d.negate().isNegative, isTrue);
    });
  });

  group('HoraDuration Normalization', () {
    test('normalize seconds overflow', () {
      final d = HoraDuration(seconds: 90).normalize();
      expect(d.minutes, 1);
      expect(d.seconds, 30);
    });

    test('normalize minutes overflow', () {
      final d = HoraDuration(minutes: 90).normalize();
      expect(d.hours, 1);
      expect(d.minutes, 30);
    });

    test('normalize hours overflow', () {
      final d = HoraDuration(hours: 25).normalize();
      expect(d.days, 1);
      expect(d.hours, 1);
    });

    test('normalize days overflow', () {
      final d = HoraDuration(days: 10).normalize();
      expect(d.weeks, 1);
      expect(d.days, 3);
    });
  });

  group('HoraDuration Formatting', () {
    test('toIso8601() with years/months', () {
      final d = HoraDuration(years: 1, months: 6);
      expect(d.toIso8601(), 'P1Y6M');
    });

    test('toIso8601() with time', () {
      final d = HoraDuration(hours: 4, minutes: 30, seconds: 15);
      expect(d.toIso8601(), 'PT4H30M15S');
    });

    test('toIso8601() with full duration', () {
      final d = HoraDuration(
        years: 1,
        months: 2,
        days: 3,
        hours: 4,
        minutes: 5,
        seconds: 6,
      );
      expect(d.toIso8601(), 'P1Y2M3DT4H5M6S');
    });

    test('toIso8601() zero duration', () {
      expect(HoraDuration.zero.toIso8601(), 'PT0S');
    });

    test('toIso8601() negative', () {
      final d = HoraDuration(days: 5, isNegative: true);
      expect(d.toIso8601(), '-P5D');
    });

    test('humanize()', () {
      expect(HoraDuration.ofDays(1).humanize(), 'a day');
      expect(HoraDuration.ofDays(5).humanize(), '5 days');
      expect(HoraDuration.ofMonths(1).humanize(), 'a month');
      expect(HoraDuration.ofYears(2).humanize(), '2 years');
    });
  });

  group('HoraDuration Comparison', () {
    test('compareTo()', () {
      final d1 = HoraDuration.ofDays(5);
      final d2 = HoraDuration.ofDays(10);
      expect(d1.compareTo(d2), isNegative);
      expect(d2.compareTo(d1), isPositive);
    });

    test('equality', () {
      final d1 = HoraDuration(days: 5);
      final d2 = HoraDuration(days: 5);
      final d3 = HoraDuration(days: 6);
      expect(d1 == d2, isTrue);
      expect(d1 == d3, isFalse);
    });
  });

  group('HoraDuration Conversion', () {
    test('asDuration()', () {
      final d = HoraDuration(days: 5, hours: 6);
      final dartDuration = d.asDuration();
      expect(dartDuration.inHours, 126);
    });

    test('copyWith()', () {
      final d = HoraDuration(days: 5, hours: 6);
      final modified = d.copyWith(days: 10);
      expect(modified.days, 10);
      expect(modified.hours, 6);
    });
  });
}
