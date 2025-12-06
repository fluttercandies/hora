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
            h1.isBeforeWithPrecision(h2, precision: TimePrecision.day), isTrue,);
        expect(h2.isBeforeWithPrecision(h1, precision: TimePrecision.day),
            isFalse,);
      });
    });

    group('truncateTo', () {
      final h = Hora.of(
          year: 2024, month: 3, day: 15, hour: 14, minute: 30, second: 45,);

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
