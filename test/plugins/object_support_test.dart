import 'package:hora/hora.dart';
import 'package:hora/src/plugins/object_support.dart';
import 'package:test/test.dart';

void main() {
  group('ObjectSupport', () {
    group('HoraObject.from', () {
      test('creates Hora from complete map', () {
        final h = HoraObject.from({
          'year': 2023,
          'month': 12,
          'day': 25,
          'hour': 10,
          'minute': 30,
          'second': 45,
          'millisecond': 123,
          'microsecond': 456,
        });

        expect(h.year, equals(2023));
        expect(h.month, equals(12));
        expect(h.day, equals(25));
        expect(h.hour, equals(10));
        expect(h.minute, equals(30));
        expect(h.second, equals(45));
        expect(h.millisecond, equals(123));
        expect(h.microsecond, equals(456));
      });

      test('uses current year for missing year', () {
        final h = HoraObject.from({'month': 6, 'day': 15});
        expect(h.year, equals(DateTime.now().year));
      });

      test('uses defaults for missing values', () {
        final h = HoraObject.from({'year': 2023});
        expect(h.month, equals(1));
        expect(h.day, equals(1));
        expect(h.hour, equals(0));
        expect(h.minute, equals(0));
        expect(h.second, equals(0));
      });

      test('supports plural key names', () {
        final h = HoraObject.from({
          'years': 2023,
          'months': 6,
          'days': 15,
          'hours': 10,
          'minutes': 30,
          'seconds': 45,
        });

        expect(h.year, equals(2023));
        expect(h.month, equals(6));
        expect(h.day, equals(15));
        expect(h.hour, equals(10));
        expect(h.minute, equals(30));
        expect(h.second, equals(45));
      });

      test('supports date alias for day', () {
        final h = HoraObject.from({
          'year': 2023,
          'month': 6,
          'date': 15,
        });
        expect(h.day, equals(15));
      });

      test('creates UTC time when specified', () {
        final h = HoraObject.from(
          {
            'year': 2023,
            'month': 6,
            'day': 15,
          },
          utc: true,
        );
        expect(h.isUtc, isTrue);
      });

      test('parses string values', () {
        final h = HoraObject.from({
          'year': '2023',
          'month': '6',
          'day': '15',
        });
        expect(h.year, equals(2023));
        expect(h.month, equals(6));
        expect(h.day, equals(15));
      });

      test('handles integer-compatible num values', () {
        final h = HoraObject.from({
          'year': 2023.0,
          'month': 6.0,
        });
        expect(h.year, equals(2023));
        expect(h.month, equals(6));
      });

      test('rejects non-integer numeric values', () {
        expect(
          () => HoraObject.from({
            'year': 2023,
            'month': 6.5,
          }),
          throwsArgumentError,
        );
      });
    });

    group('HoraObject.tryFrom', () {
      test('returns null for null map', () {
        expect(HoraObject.tryFrom(null), isNull);
      });

      test('returns null for empty map', () {
        expect(HoraObject.tryFrom({}), isNull);
      });

      test('returns Hora for valid map', () {
        final h = HoraObject.tryFrom({'year': 2023});
        expect(h, isNotNull);
        expect(h!.year, equals(2023));
      });

      test('returns null for invalid map values', () {
        expect(
          HoraObject.tryFrom({
            'year': 2023,
            'month': 6.5,
          }),
          isNull,
        );
      });
    });

    group('addObject', () {
      test('adds years', () {
        final h = Hora.of(year: 2020, month: 6, day: 15);
        final h2 = h.addObject({'years': 3});
        expect(h2.year, equals(2023));
      });

      test('adds months', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.addObject({'months': 3});
        expect(h2.month, equals(9));
      });

      test('adds weeks', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.addObject({'weeks': 2});
        expect(h2.day, equals(29));
      });

      test('adds days', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.addObject({'days': 10});
        expect(h2.day, equals(25));
      });

      test('adds hours', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, hour: 10);
        final h2 = h.addObject({'hours': 5});
        expect(h2.hour, equals(15));
      });

      test('adds minutes', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, minute: 30);
        final h2 = h.addObject({'minutes': 15});
        expect(h2.minute, equals(45));
      });

      test('adds seconds', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, second: 30);
        final h2 = h.addObject({'seconds': 15});
        expect(h2.second, equals(45));
      });

      test('adds multiple units at once', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, hour: 10, minute: 30);
        final h2 = h.addObject({
          'days': 5,
          'hours': 2,
          'minutes': 15,
        });
        expect(h2.day, equals(20));
        expect(h2.hour, equals(12));
        expect(h2.minute, equals(45));
      });

      test('adds quarters', () {
        final h = Hora.of(year: 2023, day: 15);
        final h2 = h.addObject({'quarters': 2});
        expect(h2.month, equals(7));
      });

      test('parses string values and canonical keys', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.addObject({
          'DAYS': '5',
          'hours_': '2',
        });
        expect(h2.day, equals(20));
        expect(h2.hour, equals(2));
      });

      test('handles zero values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.addObject({'days': 0, 'hours': 0});
        expect(h2, equals(h));
      });

      test('rejects non-integer numeric values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.addObject({'days': 1.5}),
          throwsArgumentError,
        );
      });

      test('rejects conflicting alias values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.addObject({'day': 1, 'days': 2}),
          throwsArgumentError,
        );
      });

      test('rejects unsupported keys', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.addObject({'dayz': 2}),
          throwsArgumentError,
        );
        expect(
          () => h.addObject({'days': 1, 'month-value': 2}),
          throwsArgumentError,
        );
      });
    });

    group('subtractObject', () {
      test('subtracts years', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.subtractObject({'years': 3});
        expect(h2.year, equals(2020));
      });

      test('subtracts days', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.subtractObject({'days': 10});
        expect(h2.day, equals(5));
      });

      test('subtracts multiple units', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, hour: 10);
        final h2 = h.subtractObject({
          'days': 5,
          'hours': 5,
        });
        expect(h2.day, equals(10));
        expect(h2.hour, equals(5));
      });

      test('subtracts string numeric values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, hour: 10);
        final h2 = h.subtractObject({
          'days': '5',
          'hours': '2',
        });
        expect(h2.day, equals(10));
        expect(h2.hour, equals(8));
      });

      test('rejects unsupported keys', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.subtractObject({'wek': 1}),
          throwsArgumentError,
        );
      });
    });

    group('setObject', () {
      test('sets year', () {
        final h = Hora.of(year: 2020, month: 6, day: 15);
        final h2 = h.setObject({'year': 2023});
        expect(h2.year, equals(2023));
        expect(h2.month, equals(6)); // Unchanged
      });

      test('sets multiple values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, hour: 10, minute: 30);
        final h2 = h.setObject({
          'hour': 0,
          'minute': 0,
          'second': 0,
        });
        expect(h2.hour, equals(0));
        expect(h2.minute, equals(0));
        expect(h2.second, equals(0));
        expect(h2.day, equals(15)); // Unchanged
      });

      test('does not modify unspecified values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15, hour: 10, minute: 30);
        final h2 = h.setObject({'year': 2024});

        expect(h2.year, equals(2024));
        expect(h2.month, equals(6));
        expect(h2.day, equals(15));
        expect(h2.hour, equals(10));
        expect(h2.minute, equals(30));
      });

      test('rejects non-integer numeric values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.setObject({'month': 6.5}),
          throwsArgumentError,
        );
      });

      test('rejects unsupported keys', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.setObject({'weeks': 1}),
          throwsArgumentError,
        );
        expect(
          () => h.setObject({'year': 2024, 'month__value': 8}),
          throwsArgumentError,
        );
      });

      test('rejects out-of-range values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.setObject({'month': 13}),
          throwsArgumentError,
        );
        expect(
          () => h.setObject({'day': 0}),
          throwsArgumentError,
        );
      });
    });

    group('getByKey', () {
      test('returns correct values for all keys', () {
        final h = Hora.of(
          year: 2023,
          month: 6,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );

        expect(h.getByKey('year'), equals(2023));
        expect(h.getByKey('years'), equals(2023));
        expect(h.getByKey('month'), equals(6));
        expect(h.getByKey('months'), equals(6));
        expect(h.getByKey('day'), equals(15));
        expect(h.getByKey('days'), equals(15));
        expect(h.getByKey('date'), equals(15));
        expect(h.getByKey('hour'), equals(10));
        expect(h.getByKey('hours'), equals(10));
        expect(h.getByKey('minute'), equals(30));
        expect(h.getByKey('minutes'), equals(30));
        expect(h.getByKey('second'), equals(45));
        expect(h.getByKey('seconds'), equals(45));
        expect(h.getByKey('millisecond'), equals(123));
        expect(h.getByKey('milliseconds'), equals(123));
        expect(h.getByKey('microsecond'), equals(456));
        expect(h.getByKey('microseconds'), equals(456));
      });

      test('returns weekday', () {
        final h = Hora.of(year: 2023, month: 6, day: 15); // Thursday
        expect(h.getByKey('weekday'), equals(4)); // Thursday = 4
      });

      test('returns quarter', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.getByKey('quarter'), equals(2));
      });

      test('returns dayOfYear', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.getByKey('dayofyear'), equals(166));
      });

      test('throws for unknown key', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(() => h.getByKey('unknown'), throwsArgumentError);
      });

      test('is case-insensitive', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.getByKey('YEAR'), equals(2023));
        expect(h.getByKey('Year'), equals(2023));
      });
    });

    group('getByField', () {
      test('returns values by type-safe field enum', () {
        final h = Hora.of(
          year: 2023,
          month: 6,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );

        expect(h.getByField(HoraGetField.year), equals(2023));
        expect(h.getByField(HoraGetField.month), equals(6));
        expect(h.getByField(HoraGetField.day), equals(15));
        expect(h.getByField(HoraGetField.hour), equals(10));
        expect(h.getByField(HoraGetField.minute), equals(30));
        expect(h.getByField(HoraGetField.second), equals(45));
        expect(h.getByField(HoraGetField.millisecond), equals(123));
        expect(h.getByField(HoraGetField.microsecond), equals(456));
        expect(h.getByField(HoraGetField.weekday), equals(4));
        expect(h.getByField(HoraGetField.quarter), equals(2));
        expect(h.getByField(HoraGetField.dayOfYear), equals(166));
        expect(h.getByField(HoraGetField.isoWeek), equals(h.isoWeek));
        expect(h.getByField(HoraGetField.isoWeekYear), equals(h.isoWeekYear));
      });
    });

    group('setByKey', () {
      test('sets year by key', () {
        final h = Hora.of(year: 2020, month: 6, day: 15);
        final h2 = h.setByKey('year', 2023);
        expect(h2.year, equals(2023));
      });

      test('sets month by key', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        final h2 = h.setByKey('month', 12);
        expect(h2.month, equals(12));
      });

      test('throws for unknown key', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(() => h.setByKey('unknown', 100), throwsArgumentError);
      });

      test('is case-insensitive', () {
        final h = Hora.of(year: 2020, month: 6, day: 15);
        final h2 = h.setByKey('YEAR', 2023);
        expect(h2.year, equals(2023));
      });

      test('rejects out-of-range values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(() => h.setByKey('month', 13), throwsArgumentError);
        expect(() => h.setByKey('day', 0), throwsArgumentError);
      });
    });

    group('setByField', () {
      test('sets component by type-safe field enum', () {
        final h = Hora.of(
          year: 2023,
          month: 6,
          day: 15,
          hour: 10,
          minute: 30,
          second: 45,
          millisecond: 123,
          microsecond: 456,
        );

        final updated = h
            .setByField(HoraSetField.year, 2025)
            .setByField(HoraSetField.month, 8)
            .setByField(HoraSetField.day, 20)
            .setByField(HoraSetField.hour, 9)
            .setByField(HoraSetField.minute, 15)
            .setByField(HoraSetField.second, 5)
            .setByField(HoraSetField.millisecond, 10)
            .setByField(HoraSetField.microsecond, 20);

        expect(updated.year, equals(2025));
        expect(updated.month, equals(8));
        expect(updated.day, equals(20));
        expect(updated.hour, equals(9));
        expect(updated.minute, equals(15));
        expect(updated.second, equals(5));
        expect(updated.millisecond, equals(10));
        expect(updated.microsecond, equals(20));
      });

      test('rejects out-of-range values', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(
          () => h.setByField(HoraSetField.hour, 24),
          throwsArgumentError,
        );
        expect(
          () => h.setByField(HoraSetField.second, 60),
          throwsArgumentError,
        );
      });
    });
  });
}
