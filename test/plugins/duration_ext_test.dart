import 'package:hora/hora.dart';
import 'package:hora/src/plugins/duration_ext.dart';
import 'package:test/test.dart';

void main() {
  group('HoraDurationExtUtils', () {
    group('format', () {
      test('formats HH:mm:ss', () {
        final d = HoraDuration(hours: 2, minutes: 30, seconds: 45);
        expect(d.format('HH:mm:ss'), '02:30:45');
      });

      test('formats with day and hour tokens', () {
        final d = HoraDuration(days: 3, hours: 5);
        // format replaces tokens D and H (but note: s in 'days' will be replaced by seconds value)
        expect(d.format('D-H'), '3-5');
      });
    });

    group('humanize', () {
      test('humanizes seconds', () {
        expect(HoraDuration(seconds: 30).humanize(), contains('second'));
      });

      test('humanizes minutes', () {
        expect(HoraDuration(minutes: 5).humanize(), contains('minute'));
      });

      test('humanizes hours', () {
        expect(HoraDuration(hours: 3).humanize(), contains('hour'));
      });

      test('humanizes days', () {
        expect(HoraDuration(days: 7).humanize(), contains('day'));
      });

      test('humanizes zero duration', () {
        // Core humanize() returns 'a few seconds' for zero duration
        expect(HoraDuration().humanize(), isNotEmpty);
      });

      test('precise=false returns at most two largest units', () {
        final value = HoraDuration(days: 1, hours: 2, minutes: 3, seconds: 4);
        expect(HoraDurationExtUtils(value).humanize(), '1 day and 2 hours');
      });

      test('precise=true includes all available units', () {
        final value = HoraDuration(
          days: 1,
          hours: 2,
          minutes: 3,
          seconds: 4,
          milliseconds: 5,
          microseconds: 6,
        );
        expect(
          HoraDurationExtUtils(value).humanize(precise: true),
          '1 day, 2 hours, 3 minutes, 4 seconds, 5 milliseconds, and 6 microseconds',
        );
      });

      test('humanize preserves negative sign', () {
        final value = HoraDuration(hours: 2, minutes: 30, isNegative: true);
        expect(
          HoraDurationExtUtils(value).humanize(),
          '-2 hours and 30 minutes',
        );
      });

      test('humanize falls back to sub-second units when needed', () {
        expect(
          HoraDurationExtUtils(HoraDuration(milliseconds: 120)).humanize(),
          '120 milliseconds',
        );
        expect(
          HoraDurationExtUtils(HoraDuration(microseconds: 42)).humanize(),
          '42 microseconds',
        );
      });
    });

    group('toIso8601 (from HoraDuration)', () {
      test('formats as ISO 8601 duration', () {
        final d = HoraDuration(days: 1, hours: 2, minutes: 30, seconds: 45);
        final iso = d.toIso8601();
        expect(iso, startsWith('P'));
        expect(iso, contains('T'));
      });

      test('formats zero duration', () {
        final d = HoraDuration();
        expect(d.toIso8601(), 'PT0S');
      });
    });

    group('totalHours', () {
      test('calculates total hours', () {
        final d = HoraDuration(days: 1, hours: 12);
        expect(d.totalHours, closeTo(36, 0.1));
      });

      test('preserves negative sign', () {
        final d = HoraDuration(hours: 2, isNegative: true);
        expect(d.totalHours, closeTo(-2, 0.1));
      });

      test('includes calendar units approximately', () {
        final d = HoraDuration(years: 1, months: 1, days: 1);
        final expected = (365.25 + 30.4375 + 1) * 24;
        expect(d.totalHours, closeTo(expected, 1e-9));
      });
    });

    group('totalMinutes', () {
      test('calculates total minutes', () {
        final d = HoraDuration(hours: 2, minutes: 30);
        expect(d.totalMinutes, closeTo(150, 0.1));
      });

      test('includes milliseconds and microseconds', () {
        final d =
            HoraDuration(seconds: 1, milliseconds: 500, microseconds: 250);
        expect(d.totalMinutes, closeTo(1.50025 / 60, 1e-12));
      });
    });

    group('toDartDuration', () {
      test('preserves microseconds for fixed units', () {
        final d = HoraDuration(seconds: 1, microseconds: 1);
        expect(
          HoraDurationExtUtils(d).toDartDuration().inMicroseconds,
          1000001,
        );
      });

      test('uses approximate conversion for calendar units', () {
        final d = HoraDuration(months: 1);
        final converted = HoraDurationExtUtils(d).toDartDuration();
        expect(converted.inMicroseconds, d.asDuration().inMicroseconds);
      });

      test('preserves negative sign in conversion', () {
        final d = HoraDuration(minutes: 2, isNegative: true);
        expect(HoraDurationExtUtils(d).toDartDuration().isNegative, isTrue);
      });
    });

    group('operators', () {
      test('adds durations', () {
        final d1 = HoraDuration(hours: 1);
        final d2 = HoraDuration(hours: 2);
        final result = d1 + d2;
        expect(result.hours, 3);
      });

      test('subtracts durations', () {
        final d1 = HoraDuration(hours: 3);
        final d2 = HoraDuration(hours: 1);
        final result = d1 - d2;
        expect(result.hours, 2);
      });

      test('multiplies duration', () {
        final d = HoraDuration(hours: 2);
        final result = d * 3;
        expect(result.hours, 6);
      });
    });
  });

  group('HoraDurationFactory', () {
    test('parse ISO 8601 (using core HoraDuration.parse)', () {
      final d = HoraDuration.parse('PT1H30M');
      expect(d.hours, 1);
      expect(d.minutes, 30);
    });

    test('parse with days', () {
      final d = HoraDuration.parse('P1DT2H');
      expect(d.days, 1);
      expect(d.hours, 2);
    });

    test('tryParse returns null for invalid', () {
      expect(HoraDuration.tryParse('invalid'), isNull);
    });

    test('fromHours', () {
      final d = HoraDurationFactory.fromHours(2.5);
      expect(d.totalHours, closeTo(2.5, 0.01));
    });

    test('fromHours with negative value keeps normalized positive fields', () {
      final d = HoraDurationFactory.fromHours(-2.5);
      expect(d.isNegative, isTrue);
      expect(d.hours, 2);
      expect(d.minutes, 30);
    });

    test('fromMinutes', () {
      final d = HoraDurationFactory.fromMinutes(90);
      expect(d.totalMinutes, closeTo(90, 0.1));
    });

    test('fromSeconds normalizes millisecond carry at precision boundary', () {
      final d = HoraDurationFactory.fromSeconds(59.9999);
      expect(d.minutes, 1);
      expect(d.seconds, 0);
      expect(d.milliseconds, 0);
      expect(d.totalSeconds, closeTo(60, 0.001));
    });

    test('fromMinutes keeps negative sign and normalizes carry', () {
      final d = HoraDurationFactory.fromMinutes(-1.999999);
      expect(d.isNegative, isTrue);
      expect(d.minutes, 2);
      expect(d.seconds, 0);
      expect(d.milliseconds, 0);
      expect(d.totalMinutes, closeTo(-2, 0.001));
    });

    test('fromHours normalizes near-boundary precision', () {
      final almostTwoHours = 1 + (59 / 60) + (59.9999 / 3600);
      final d = HoraDurationFactory.fromHours(almostTwoHours);
      expect(d.hours, 2);
      expect(d.minutes, 0);
      expect(d.seconds, 0);
      expect(d.milliseconds, 0);
      expect(d.totalHours, closeTo(2, 0.001));
    });

    test('fromDays normalizes remainder carry to day unit', () {
      final almostTwoDays = 1 + (23 + (59 / 60) + (59.9999 / 3600)) / 24;
      final d = HoraDurationFactory.fromDays(almostTwoDays);
      expect(d.days, 2);
      expect(d.hours, 0);
      expect(d.minutes, 0);
      expect(d.seconds, 0);
    });

    test('fromHours rejects NaN and Infinity', () {
      expect(
        () => HoraDurationFactory.fromHours(double.nan),
        throwsArgumentError,
      );
      expect(
        () => HoraDurationFactory.fromHours(double.infinity),
        throwsArgumentError,
      );
      expect(
        () => HoraDurationFactory.fromHours(double.negativeInfinity),
        throwsArgumentError,
      );
    });

    test('fromMinutes rejects NaN and Infinity', () {
      expect(
        () => HoraDurationFactory.fromMinutes(double.nan),
        throwsArgumentError,
      );
      expect(
        () => HoraDurationFactory.fromMinutes(double.infinity),
        throwsArgumentError,
      );
    });

    test('fromSeconds rejects NaN and Infinity', () {
      expect(
        () => HoraDurationFactory.fromSeconds(double.nan),
        throwsArgumentError,
      );
      expect(
        () => HoraDurationFactory.fromSeconds(double.negativeInfinity),
        throwsArgumentError,
      );
    });

    test('fromDays rejects NaN and Infinity', () {
      expect(
        () => HoraDurationFactory.fromDays(double.nan),
        throwsArgumentError,
      );
      expect(
        () => HoraDurationFactory.fromDays(double.infinity),
        throwsArgumentError,
      );
    });
  });

  group('HoraDurationOpExt', () {
    test('addHoraDuration to Hora', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final d = HoraDuration(days: 5);
      final result = h.addHoraDuration(d);
      expect(result.day, 20);
    });

    test('subtractHoraDuration from Hora', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final d = HoraDuration(days: 5);
      final result = h.subtractHoraDuration(d);
      expect(result.day, 10);
    });

    test('horaDurationTo', () {
      final h1 = Hora.of(year: 2024, month: 3, day: 15);
      final h2 = Hora.of(year: 2024, month: 3, day: 20);
      final d = h1.horaDurationTo(h2);
      expect(d.totalDays, closeTo(5, 0.1));
    });

    test('addHoraDuration handles microseconds', () {
      final h = Hora.of(year: 2024, month: 3, day: 15, microsecond: 100);
      final d = HoraDuration(microseconds: 250);
      final result = h.addHoraDuration(d);
      expect(result.microsecond, 350);
    });

    test('addHoraDuration handles mixed calendar and fixed units on boundary',
        () {
      final h = Hora.of(
        year: 2024,
        day: 31,
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 900,
        microsecond: 900,
      );
      final d = HoraDuration(
        months: 1,
        days: 1,
        hours: 1,
        minutes: 1,
        seconds: 1,
        milliseconds: 200,
        microseconds: 200,
      );

      final result = h.addHoraDuration(d);
      expect(result.year, 2024);
      expect(result.month, 3);
      expect(result.day, 2);
      expect(result.hour, 1);
      expect(result.minute, 1);
      expect(result.second, 1);
      expect(result.millisecond, 101);
      expect(result.microsecond, 100);
    });

    test('subtractHoraDuration with negative duration equals add', () {
      final h = Hora.of(year: 2024, month: 3, day: 15, hour: 10);
      final d = HoraDuration(days: 2, hours: 3, isNegative: true);

      final result = h.subtractHoraDuration(d);
      expect(result.year, 2024);
      expect(result.month, 3);
      expect(result.day, 17);
      expect(result.hour, 13);
    });

    test('rejects duration with negative component values', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final invalid = HoraDuration(days: -1);

      expect(() => h.addHoraDuration(invalid), throwsArgumentError);
      expect(() => h.subtractHoraDuration(invalid), throwsArgumentError);
    });
  });

  group('DurationToHora extension (from core)', () {
    test('toHoraDuration', () {
      // This extension is defined in extensions.dart
      final dartDuration = Duration(hours: 2, minutes: 30);
      final horaDuration = dartDuration.toHoraDuration();
      expect(horaDuration.totalMinutes, closeTo(150, 0.1));
    });
  });
}
