import 'package:hora/hora.dart';
import 'package:hora/src/plugins/precision.dart';
import 'package:test/test.dart';

void main() {
  group('TimePrecision', () {
    test('toUnit converts to TemporalUnit', () {
      expect(TimePrecision.year.toUnit, TemporalUnit.year);
      expect(TimePrecision.month.toUnit, TemporalUnit.month);
      expect(TimePrecision.day.toUnit, TemporalUnit.day);
      expect(TimePrecision.hour.toUnit, TemporalUnit.hour);
    });

    test('milliseconds returns correct values', () {
      expect(TimePrecision.day.milliseconds, 24 * 60 * 60 * 1000);
      expect(TimePrecision.hour.milliseconds, 60 * 60 * 1000);
      expect(TimePrecision.minute.milliseconds, 60 * 1000);
      expect(TimePrecision.second.milliseconds, 1000);
      expect(TimePrecision.millisecond.milliseconds, 1);
    });
  });

  group('PrecisionExt', () {
    group('isSameAs', () {
      test('year precision', () {
        final h1 = Hora.of(year: 2024);
        final h2 = Hora.of(year: 2024, month: 12, day: 31);
        final h3 = Hora.of(year: 2023);

        expect(h1.isSameAs(h2, precision: TimePrecision.year), isTrue);
        expect(h1.isSameAs(h3, precision: TimePrecision.year), isFalse);
      });

      test('month precision', () {
        final h1 = Hora.of(year: 2024, month: 3);
        final h2 = Hora.of(year: 2024, month: 3, day: 31);
        final h3 = Hora.of(year: 2024, month: 4);

        expect(h1.isSameAs(h2, precision: TimePrecision.month), isTrue);
        expect(h1.isSameAs(h3, precision: TimePrecision.month), isFalse);
      });

      test('day precision', () {
        final h1 = Hora.of(year: 2024, month: 3, day: 15, hour: 9);
        final h2 = Hora.of(year: 2024, month: 3, day: 15, hour: 21);
        final h3 = Hora.of(year: 2024, month: 3, day: 16, hour: 9);

        expect(h1.isSameAs(h2, precision: TimePrecision.day), isTrue);
        expect(h1.isSameAs(h3, precision: TimePrecision.day), isFalse);
      });

      test('hour precision', () {
        final h1 = Hora.of(year: 2024, month: 3, day: 15, hour: 10, minute: 15);
        final h2 = Hora.of(year: 2024, month: 3, day: 15, hour: 10, minute: 45);
        final h3 = Hora.of(year: 2024, month: 3, day: 15, hour: 11, minute: 15);

        expect(h1.isSameAs(h2, precision: TimePrecision.hour), isTrue);
        expect(h1.isSameAs(h3, precision: TimePrecision.hour), isFalse);
      });
    });

    group('isBeforeWithPrecision', () {
      test('compares at precision level', () {
        final h1 = Hora.of(year: 2024, month: 3, day: 15, hour: 23);
        final h2 = Hora.of(year: 2024, month: 3, day: 16, hour: 1);

        expect(
          h1.isBeforeWithPrecision(h2, precision: TimePrecision.day),
          isTrue,
        );
        expect(
          h2.isBeforeWithPrecision(h1, precision: TimePrecision.day),
          isFalse,
        );
      });

      test('week precision remains consistent with isSameAs (ISO)', () {
        final sunday = Hora.of(year: 2024, month: 3, day: 3); // ISO week 9
        final monday = Hora.of(year: 2024, month: 3, day: 4); // ISO week 10

        expect(sunday.isSameAs(monday, precision: TimePrecision.week), isFalse);
        expect(
          sunday.isBeforeWithPrecision(monday, precision: TimePrecision.week),
          isTrue,
        );
      });
    });

    group('isAfterWithPrecision', () {
      test('compares at precision level', () {
        final later = Hora.of(year: 2024, month: 3, day: 16, hour: 1);
        final earlier = Hora.of(year: 2024, month: 3, day: 15, hour: 23);

        expect(
          later.isAfterWithPrecision(earlier, precision: TimePrecision.day),
          isTrue,
        );
        expect(
          earlier.isAfterWithPrecision(later, precision: TimePrecision.day),
          isFalse,
        );
      });
    });

    group('truncateTo', () {
      final h = Hora.of(
        year: 2024,
        month: 3,
        day: 15,
        hour: 14,
        minute: 30,
        second: 45,
      );

      test('truncates to year', () {
        final t = h.truncateTo(TimePrecision.year);
        expect(t.year, 2024);
        expect(t.month, 1);
        expect(t.day, 1);
        expect(t.hour, 0);
      });

      test('truncates to month', () {
        final t = h.truncateTo(TimePrecision.month);
        expect(t.year, 2024);
        expect(t.month, 3);
        expect(t.day, 1);
        expect(t.hour, 0);
      });

      test('truncates to day', () {
        final t = h.truncateTo(TimePrecision.day);
        expect(t.year, 2024);
        expect(t.month, 3);
        expect(t.day, 15);
        expect(t.hour, 0);
      });

      test('truncates to hour', () {
        final t = h.truncateTo(TimePrecision.hour);
        expect(t.hour, 14);
        expect(t.minute, 0);
        expect(t.second, 0);
      });

      test('truncates to minute', () {
        final t = h.truncateTo(TimePrecision.minute);
        expect(t.hour, 14);
        expect(t.minute, 30);
        expect(t.second, 0);
      });

      test('preserves UTC flag when truncating', () {
        final utcHora = Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
          utc: true,
        );

        final truncated = utcHora.truncateTo(TimePrecision.day);
        expect(truncated.isUtc, isTrue);
      });

      test('truncates microseconds at millisecond precision', () {
        final h = Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          hour: 10,
          minute: 20,
          second: 30,
          millisecond: 456,
          microsecond: 789,
        );
        final t = h.truncateTo(TimePrecision.millisecond);
        expect(t.millisecond, 456);
        expect(t.microsecond, 0);
      });

      test('week truncation uses ISO Monday boundary', () {
        final sunday = Hora.of(year: 2024, month: 3, day: 3); // Sunday
        final t = sunday.truncateTo(TimePrecision.week);
        expect(t.year, 2024);
        expect(t.month, 2);
        expect(t.day, 26); // ISO week start for 2024-03-03
        expect(t.weekday, DateTime.monday);
      });
    });

    group('roundTo', () {
      test('floor mode', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14, minute: 45);
        final rounded = h.roundTo(TimePrecision.hour, mode: RoundingMode.floor);
        expect(rounded.hour, 14);
        expect(rounded.minute, 0);
      });

      test('ceil mode', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14, minute: 15);
        final rounded = h.roundTo(TimePrecision.hour, mode: RoundingMode.ceil);
        expect(rounded.hour, 15);
        expect(rounded.minute, 0);
      });

      test('round mode (down)', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14, minute: 29);
        final rounded = h.roundTo(TimePrecision.hour);
        expect(rounded.hour, 14);
      });

      test('round mode (up)', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14, minute: 31);
        final rounded = h.roundTo(TimePrecision.hour);
        expect(rounded.hour, 15);
      });

      test('round millisecond uses microsecond half-up', () {
        final down = Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          second: 1,
          millisecond: 100,
          microsecond: 499,
        );
        final up = Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          second: 1,
          millisecond: 100,
          microsecond: 500,
        );

        expect(down.roundTo(TimePrecision.millisecond).millisecond, 100);
        expect(down.roundTo(TimePrecision.millisecond).microsecond, 0);
        expect(up.roundTo(TimePrecision.millisecond).millisecond, 101);
        expect(up.roundTo(TimePrecision.millisecond).microsecond, 0);
      });

      test('round month uses actual month length midpoint', () {
        final jan = Hora.of(year: 2024, day: 16, hour: 12);
        final feb = Hora.of(year: 2024, month: 2, day: 15, hour: 12);

        // January has 31 days, midpoint is Jan 16 12:00.
        expect(jan.roundTo(TimePrecision.month).month, 2);
        // February 2024 has 29 days, midpoint is Feb 15 12:00.
        expect(feb.roundTo(TimePrecision.month).month, 3);
      });

      test('round year uses actual leap-year midpoint', () {
        final leapMid = Hora.of(year: 2024, month: 7, day: 2); // day 184/366
        final rounded = leapMid.roundTo(TimePrecision.year);
        expect(rounded.year, 2025);
      });
    });

    group('alignTo', () {
      test('aligns to 15-minute intervals', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14, minute: 37);
        final aligned = h.alignTo(15, TimePrecision.minute);
        expect(aligned.minute, 30);
      });

      test('aligns to 6-hour intervals', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14);
        final aligned = h.alignTo(6, TimePrecision.hour);
        expect(aligned.hour, 12);
      });

      test('throws when interval is not positive', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14);
        expect(
          () => h.alignTo(0, TimePrecision.hour),
          throwsArgumentError,
        );
        expect(
          () => h.alignTo(-2, TimePrecision.hour),
          throwsArgumentError,
        );
      });

      test('month precision uses 1-based alignment anchors', () {
        final h = Hora.of(year: 2024, day: 20);
        final aligned = h.alignTo(3, TimePrecision.month);
        expect(aligned.year, 2024);
        expect(aligned.month, 1);
      });

      test('day precision keeps first day in same month bucket', () {
        final h = Hora.of(year: 2024, month: 3, hour: 9);
        final aligned = h.alignTo(7, TimePrecision.day);
        expect(aligned.year, 2024);
        expect(aligned.month, 3);
        expect(aligned.day, 1);
      });
    });

    group('additional precision helpers', () {
      test('diffWithPrecision uses truncated boundaries', () {
        final base = Hora.of(year: 2024, month: 3, day: 15, hour: 23);
        final next = Hora.of(year: 2024, month: 3, day: 16, hour: 1);
        expect(
          base.diffWithPrecision(next, precision: TimePrecision.day),
          -1,
        );
      });

      test('nearestBoundary delegates to roundTo', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, hour: 14, minute: 31);
        final nearest = h.nearestBoundary(TimePrecision.hour);
        expect(nearest.hour, 15);
        expect(nearest.minute, 0);
      });

      test('withPrecision truncates to requested precision', () {
        final h = Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          hour: 14,
          minute: 30,
          second: 45,
        );
        final p = h.withPrecision(TimePrecision.minute);
        expect(p.hour, 14);
        expect(p.minute, 30);
        expect(p.second, 0);
      });

      test('roundTo returns truncate or next boundary for all precisions', () {
        final samples = [
          Hora.of(
            year: 2024,
            day: 31,
            hour: 23,
            minute: 59,
            second: 30,
            millisecond: 500,
            microsecond: 500,
          ),
          Hora.of(
            year: 2025,
            month: 7,
            day: 2,
            hour: 11,
            minute: 22,
            second: 33,
            millisecond: 444,
            microsecond: 555,
            utc: true,
          ),
        ];

        for (final precision in TimePrecision.values) {
          for (final sample in samples) {
            final truncated = sample.truncateTo(precision);
            final rounded = sample.roundTo(precision);
            final next = truncated.add(1, precision.toUnit);

            expect(
              rounded == truncated || rounded == next,
              isTrue,
              reason:
                  'precision=${precision.name} sample=${sample.toIso8601()}',
            );
          }
        }
      });

      test('truncateTo and roundTo are idempotent for all precisions', () {
        final sample = Hora.of(
          year: 2024,
          month: 12,
          day: 31,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: true,
        );

        for (final precision in TimePrecision.values) {
          final truncated = sample.truncateTo(precision);
          final rounded = sample.roundTo(precision);
          expect(
            truncated.truncateTo(precision),
            truncated,
            reason: 'truncate precision=${precision.name}',
          );
          expect(
            rounded.roundTo(precision),
            rounded,
            reason: 'round precision=${precision.name}',
          );
        }
      });
    });
  });

  group('PrecisionIterationExt', () {
    test('every generates sequence', () {
      final start = Hora.of(year: 2024);
      final result = start.every(1, TimePrecision.month, count: 3).toList();

      expect(result.length, 3);
      expect(result[0].month, 1);
      expect(result[1].month, 2);
      expect(result[2].month, 3);
    });

    test('every with until', () {
      final start = Hora.of(year: 2024);
      final end = Hora.of(year: 2024, month: 4);
      final result = start.every(1, TimePrecision.month, until: end).toList();

      expect(result.length, 4);
    });

    test('every throws when interval is not positive', () {
      final start = Hora.of(year: 2024);
      expect(
        () => start.every(0, TimePrecision.day, count: 3).toList(),
        throwsArgumentError,
      );
      expect(
        () => start.every(-1, TimePrecision.day, count: 3).toList(),
        throwsArgumentError,
      );
    });

    test('stepTo generates range', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 3, day: 5);
      final result = start.stepTo(end, precision: TimePrecision.day).toList();

      expect(result.length, 5);
      expect(result.first.day, 1);
      expect(result.last.day, 5);
    });
  });
}
