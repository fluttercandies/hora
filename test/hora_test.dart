import 'package:hora/hora.dart';
import 'package:test/test.dart';

void main() {
  group('Hora Creation', () {
    test('now() creates current time', () {
      final now = Hora.now();
      final dartNow = DateTime.now();
      expect(now.year, dartNow.year);
      expect(now.month, dartNow.month);
      expect(now.day, dartNow.day);
    });

    test('nowUtc() creates current UTC time', () {
      final now = Hora.nowUtc();
      expect(now.isUtc, isTrue);
    });

    test('of() creates specific date', () {
      final h = Hora.of(year: 2023, month: 12, day: 25, hour: 10, minute: 30);
      expect(h.year, 2023);
      expect(h.month, 12);
      expect(h.day, 25);
      expect(h.hour, 10);
      expect(h.minute, 30);
      expect(h.second, 0);
    });

    test('unix() creates from seconds timestamp', () {
      final h = Hora.unix(1703462400); // 2023-12-25 00:00:00 UTC
      expect(h.toUtc().year, 2023);
      expect(h.toUtc().month, 12);
      expect(h.toUtc().day, 25);
    });

    test('unixMillis() creates from milliseconds timestamp', () {
      final h = Hora.unixMillis(1703462400000);
      expect(h.unix, 1703462400);
    });

    test('unixMicros() creates from microseconds timestamp', () {
      final h = Hora.unixMicros(1703462400000000);
      expect(h.toUtc().year, 2023);
      expect(h.toUtc().month, 12);
      expect(h.toUtc().day, 25);
    });

    test('fromDateTime() preserves DateTime fields', () {
      final dt = DateTime.utc(2024, 6, 1, 12, 34, 56, 789, 123);
      final h = Hora.fromDateTime(dt);
      expect(h.isUtc, isTrue);
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 1);
      expect(h.hour, 12);
      expect(h.minute, 34);
      expect(h.second, 56);
      expect(h.millisecond, 789);
      expect(h.microsecond, 123);
    });

    test('fromTimestamp() supports explicit precision', () {
      final sec = Hora.fromTimestamp(
        1703462400,
        unit: UnixTimestampUnit.seconds,
      ).toUtc();
      final ms = Hora.fromTimestamp(
        1703462400000,
        unit: UnixTimestampUnit.milliseconds,
      ).toUtc();
      final us = Hora.fromTimestamp(
        1703462400000000,
        unit: UnixTimestampUnit.microseconds,
      ).toUtc();

      expect(sec.year, 2023);
      expect(sec.month, 12);
      expect(sec.day, 25);
      expect(ms.year, sec.year);
      expect(us.day, sec.day);
    });

    test('from() supports DateTime and Hora source', () {
      final dt = DateTime(2024, 1, 2, 3, 4, 5);
      final fromDateTime = Hora.from(dt);
      expect(fromDateTime.year, 2024);
      expect(fromDateTime.month, 1);
      expect(fromDateTime.day, 2);

      final fromHora = Hora.from(fromDateTime, utc: true);
      expect(fromHora.isUtc, isTrue);
      expect(fromHora.year, 2024);
    });

    test('from() auto-detects unix timestamp precision', () {
      final sec = Hora.from(1703462400).toUtc();
      final sec11 = Hora.from(17034624000).toUtc();
      final ms = Hora.from(1703462400000).toUtc();
      final us = Hora.from(1703462400000000).toUtc();

      expect(sec.year, 2023);
      expect(sec.month, 12);
      expect(sec.day, 25);
      expect(sec11.year, 2509);
      expect(ms.year, sec.year);
      expect(ms.month, sec.month);
      expect(ms.day, sec.day);
      expect(us.year, sec.year);
      expect(us.month, sec.month);
      expect(us.day, sec.day);
    });

    test('from() rejects fractional unix timestamps', () {
      expect(() => Hora.from(1703462400.5), throwsArgumentError);
    });

    test('from() supports map input', () {
      final fromMap = Hora.from({
        'year': 2024,
        'month': 7,
        'day': 8,
        'hour': 9,
      });
      expect(fromMap.year, 2024);
      expect(fromMap.month, 7);
      expect(fromMap.day, 8);
      expect(fromMap.hour, 9);

      final fromTimestampMap = Hora.from({'timestamp': 1703462400});
      expect(fromTimestampMap.toUtc().day, 25);
    });

    test('fromMap() supports date string with time overrides', () {
      final h = Hora.fromMap({
        'date': '2024-06-15',
        'hour': 9,
        'minute': 30,
      });
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 15);
      expect(h.hour, 9);
      expect(h.minute, 30);
    });

    test('fromMap() uses date as baseline and applies component overrides', () {
      final h = Hora.fromMap({
        'date': '2024-01-31',
        'month': 2,
      });
      expect(h.year, 2024);
      expect(h.month, 2);
      expect(h.day, 29);
    });

    test('fromMap() respects utc flag in map', () {
      final h = Hora.fromMap({
        'year': 2024,
        'month': 1,
        'day': 1,
        'utc': true,
      });
      expect(h.isUtc, isTrue);
    });

    test('fromMap() with utc=true keeps naive date components', () {
      final h = Hora.fromMap({
        'date': '2024-06-15 09:30:00',
        'utc': true,
      });
      expect(h.isUtc, isTrue);
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 15);
      expect(h.hour, 9);
      expect(h.minute, 30);
    });

    test('fromMap() with utc=true preserves zoned instant', () {
      final h = Hora.fromMap({
        'date': '2024-06-15T10:00:00+08:00',
        'utc': true,
      });
      expect(h.isUtc, isTrue);
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 15);
      expect(h.hour, 2);
      expect(h.minute, 0);
    });

    test('fromMap() accepts mixed key styles', () {
      final h = Hora.fromMap({
        'UNIX_MILLIS': 1703462400000,
        'is_utc': true,
      });
      expect(h.isUtc, isTrue);
      expect(h.year, 2023);
      expect(h.month, 12);
      expect(h.day, 25);
    });

    test('fromMap() accepts canonical-duplicate keys with same meaning', () {
      final h = Hora.fromMap({
        'unix_millis': '1703462400000',
        'unixMillis': 1703462400000,
        'isUtc': 1,
        'is_utc': true,
      });
      expect(h.isUtc, isTrue);
      expect(h.year, 2023);
      expect(h.month, 12);
      expect(h.day, 25);
    });

    test('fromMap() accepts identical alias values', () {
      final h = Hora.fromMap({
        'year': 2024,
        'years': '2024',
        'month': 6,
        'months': 6,
        'date': '2024-06-10',
        'iso': ' 2024-06-10 ',
      });
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 10);
    });

    test('fromMap() accepts equivalent date keys across types', () {
      final h = Hora.fromMap({
        'DATE': '2024-06-10T00:00:00Z',
        'date': DateTime.utc(2024, 6, 10),
        'utc': true,
      });
      expect(h.isUtc, isTrue);
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 10);
    });

    test('fromMap() accepts equivalent date keys across timezones', () {
      final h = Hora.fromMap({
        'date': '2024-06-10T08:00:00+08:00',
        'DATE': '2024-06-10T00:00:00Z',
        'utc': true,
      });
      expect(h.isUtc, isTrue);
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 10);
      expect(h.hour, 0);
      expect(h.minute, 0);
    });

    test('fromMap() rejects mixed timestamp and component fields', () {
      expect(
        () => Hora.fromMap({
          'timestamp': 1703462400,
          'year': 2024,
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects canonical-duplicate keys with conflicting values',
        () {
      expect(
        () => Hora.fromMap({
          'unix_millis': 1703462400000,
          'unixMillis': 1703462400001,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'isUtc': true,
          'is_utc': false,
          'timestamp': 1703462400,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'DATE': '2024-06-10',
          'date': DateTime(2024, 6, 11),
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'month': 'not-a-number',
          'Month': 6,
          'year': 2024,
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects mixed timestamp and date fields', () {
      expect(
        () => Hora.fromMap({
          'timestamp': 1703462400,
          'date': '2024-01-01',
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects multiple timestamp sources', () {
      expect(
        () => Hora.fromMap({
          'unix': 1703462400,
          'timestamp': 1703462400,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'unix': 1703462400,
          'unix_millis': 1703462400000,
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects conflicting alias values', () {
      expect(
        () => Hora.fromMap({
          'year': 2024,
          'years': 2025,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'utc': true,
          'is_utc': false,
          'year': 2024,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'date': '2024-01-01',
          'iso': '2024-01-02',
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects unsupported keys', () {
      expect(
        () => Hora.fromMap({
          'yeer': 2024,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'year': 2024,
          'mnth': 6,
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects invalid date source values', () {
      expect(
        () => Hora.fromMap({
          'date': 'invalid-date',
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'date': 1703462400,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'date': Hora.parse('invalid'),
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects non-integer numeric components', () {
      expect(
        () => Hora.fromMap({
          'year': 2024,
          'month': 6.5,
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() rejects invalid utc values', () {
      expect(
        () => Hora.fromMap({
          'year': 2024,
          'utc': 'maybe',
        }),
        throwsArgumentError,
      );
    });

    test('fromMap() accepts numeric utc values 0/1 only', () {
      final utc = Hora.fromMap({
        'year': 2024,
        'utc': 1,
      });
      final local = Hora.fromMap({
        'year': 2024,
        'utc': 0,
      });
      expect(utc.isUtc, isTrue);
      expect(local.isUtc, isFalse);
    });

    test('fromMap() rejects out-of-range date/time components', () {
      expect(
        () => Hora.fromMap({
          'year': 2024,
          'month': 13,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'year': 2024,
          'month': 2,
          'day': 30,
        }),
        throwsArgumentError,
      );
      expect(
        () => Hora.fromMap({
          'year': 2024,
          'hour': 24,
        }),
        throwsArgumentError,
      );
    });

    test('parse() handles ISO 8601 strings', () {
      final h = Hora.parse('2023-12-25T10:30:00Z');
      expect(h.isValid, isTrue);
      expect(h.year, 2023);
      expect(h.month, 12);
      expect(h.day, 25);
    });

    test('parse() handles invalid strings', () {
      final h = Hora.parse('invalid');
      expect(h.isValid, isFalse);
    });

    test('tryParse() returns null for invalid strings', () {
      expect(Hora.tryParse('invalid'), isNull);
      expect(Hora.tryParse('2023-12-25'), isNotNull);
    });

    test('parse() strict mode disables smart fallback formats', () {
      final smart = Hora.parse('2023/12/25');
      final strict = Hora.parse('2023/12/25', mode: HoraParseMode.strict);
      expect(smart.isValid, isTrue);
      expect(strict.isValid, isFalse);
    });

    test('tryFrom() returns null for unsupported or invalid input', () {
      expect(Hora.tryFrom(null), isNull);
      expect(Hora.tryFrom(Object()), isNull);
      expect(Hora.tryFrom('not-a-date'), isNull);
      expect(Hora.tryFrom({'year': 2024, 'month': 6.5}), isNull);
      expect(Hora.tryFrom({'date': 'invalid-date'}), isNull);
    });

    test('from() rejects non-string map keys', () {
      expect(
        () => Hora.from({1: 2024}),
        throwsArgumentError,
      );
    });

    test('fromTimestamp(auto) matches explicit unit at detection boundaries',
        () {
      const cases = <({int value, UnixTimestampUnit expectedUnit})>[
        (
          value: -100000000000000,
          expectedUnit: UnixTimestampUnit.microseconds,
        ),
        (value: -99999999999999, expectedUnit: UnixTimestampUnit.milliseconds),
        (value: -100000000000, expectedUnit: UnixTimestampUnit.milliseconds),
        (value: -99999999999, expectedUnit: UnixTimestampUnit.seconds),
        (value: 0, expectedUnit: UnixTimestampUnit.seconds),
        (value: 99999999999, expectedUnit: UnixTimestampUnit.seconds),
        (value: 100000000000, expectedUnit: UnixTimestampUnit.milliseconds),
        (value: 99999999999999, expectedUnit: UnixTimestampUnit.milliseconds),
        (
          value: 100000000000000,
          expectedUnit: UnixTimestampUnit.microseconds,
        ),
      ];

      for (final c in cases) {
        final auto = Hora.fromTimestamp(
          c.value,
        ).toUtc();
        final explicit = Hora.fromTimestamp(
          c.value,
          unit: c.expectedUnit,
        ).toUtc();
        final fromMixed = Hora.from(c.value).toUtc();

        expect(
          auto.unixMicros,
          explicit.unixMicros,
          reason: 'value=${c.value} expected=${c.expectedUnit.name}',
        );
        expect(
          fromMixed.unixMicros,
          explicit.unixMicros,
          reason: 'Hora.from value=${c.value}',
        );
      }
    });

    test('fromMap() normalizes timestamp aliases with punctuation/case', () {
      const micros = 1703462400000000;
      const keys = [
        'unixMicros',
        'UNIX_MICROS',
        'unix-micros',
        'unix micros',
        'timestamp_microseconds',
      ];

      for (final key in keys) {
        final h = Hora.fromMap({
          key: micros.toString(),
          'IS_UTC': 1,
        });
        expect(h.isUtc, isTrue, reason: 'key=$key');
        expect(h.unixMicros, micros, reason: 'key=$key');
      }
    });

    test('toMap()/fromMap() round-trips deterministic edge samples', () {
      final samples = [
        Hora.of(
          year: 2000,
          month: 2,
          day: 29,
          hour: 12,
          minute: 34,
          second: 56,
          millisecond: 789,
          microsecond: 123,
        ),
        Hora.of(
          year: 2024,
          month: 12,
          day: 31,
          hour: 23,
          minute: 59,
          second: 59,
          millisecond: 999,
          microsecond: 999,
          utc: true,
        ),
        Hora.of(year: 1970, utc: true),
      ];

      for (final source in samples) {
        final reparsed = Hora.fromMap({
          ...source.toMap(),
          'utc': source.isUtc,
        });
        expect(reparsed.isUtc, source.isUtc, reason: source.toIso8601());
        expect(reparsed.toMap(), source.toMap(), reason: source.toIso8601());
      }
    });
  });

  group('Hora Getters', () {
    late Hora h;

    setUp(() {
      h = Hora.of(
        year: 2023,
        month: 12,
        day: 25,
        hour: 14,
        minute: 30,
        second: 45,
        millisecond: 123,
        microsecond: 456,
      );
    });

    test('date components', () {
      expect(h.year, 2023);
      expect(h.month, 12);
      expect(h.day, 25);
      expect(h.weekday, 1); // Monday
    });

    test('time components', () {
      expect(h.hour, 14);
      expect(h.minute, 30);
      expect(h.second, 45);
      expect(h.millisecond, 123);
      expect(h.microsecond, 456);
    });

    test('derived values', () {
      expect(h.quarter, 4);
      expect(h.dayOfYear, 359);
      expect(h.daysInMonth, 31);
      expect(h.isLeapYear, isFalse);
    });

    test('leap year detection', () {
      expect(Hora.of(year: 2024).isLeapYear, isTrue);
      expect(Hora.of(year: 2023).isLeapYear, isFalse);
      expect(Hora.of(year: 2000).isLeapYear, isTrue);
      expect(Hora.of(year: 1900).isLeapYear, isFalse);
    });

    test('ISO week', () {
      // 2023-01-01 is Sunday, belongs to ISO week 52 of 2022
      final jan1 = Hora.of(year: 2023);
      expect(jan1.isoWeekYear, 2022);

      // 2023-01-02 is Monday, week 1 of 2023
      final jan2 = Hora.of(year: 2023, day: 2);
      expect(jan2.isoWeek, 1);
      expect(jan2.isoWeekYear, 2023);
    });

    test('dayOfYear is based on calendar date regardless timezone mode', () {
      final local = Hora.of(year: 2024, month: 10, day: 27);
      final utc = Hora.of(year: 2024, month: 10, day: 27, utc: true);
      expect(local.dayOfYear, utc.dayOfYear);
      expect(local.dayOfYear, 301);
    });
  });

  group('Hora Manipulation', () {
    late Hora h;

    setUp(() {
      h = Hora.of(year: 2023, month: 6, day: 15);
    });

    test('add() with various units', () {
      expect(h.add(1, TemporalUnit.day).day, 16);
      expect(h.add(1, TemporalUnit.week).day, 22);
      expect(h.add(1, TemporalUnit.month).month, 7);
      expect(h.add(1, TemporalUnit.year).year, 2024);
    });

    test('subtract() with various units', () {
      expect(h.subtract(1, TemporalUnit.day).day, 14);
      expect(h.subtract(1, TemporalUnit.month).month, 5);
    });

    test('plus()/minus() supports multi-unit operations', () {
      final moved = h.plus(months: 2, days: 3, hours: 5);
      expect(moved.month, 8);
      expect(moved.day, 18);
      expect(moved.hour, 5);

      final back = moved.minus(months: 2, days: 3, hours: 5);
      expect(back.year, h.year);
      expect(back.month, h.month);
      expect(back.day, h.day);
      expect(back.hour, h.hour);
    });

    test('plus()/minus() keeps deterministic order across boundary cascades',
        () {
      final base = Hora.of(
        year: 2024,
        day: 31,
        hour: 23,
        minute: 59,
        second: 59,
        millisecond: 900,
        microsecond: 900,
      );

      final moved = base.plus(
        months: 1,
        days: 1,
        hours: 1,
        minutes: 1,
        seconds: 1,
        milliseconds: 200,
        microseconds: 200,
      );

      expect(moved.year, 2024);
      expect(moved.month, 3);
      expect(moved.day, 2);
      expect(moved.hour, 1);
      expect(moved.minute, 1);
      expect(moved.second, 1);
      expect(moved.millisecond, 101);
      expect(moved.microsecond, 100);

      final reversed = Hora.of(
        year: 2024,
        month: 3,
        day: 31,
      ).minus(months: 1, days: 1);
      expect(reversed.year, 2024);
      expect(reversed.month, 2);
      expect(reversed.day, 28);
    });

    test('add() handles month overflow', () {
      final jan31 = Hora.of(year: 2023, day: 31);
      final nextMonth = jan31.add(1, TemporalUnit.month);
      expect(nextMonth.month, 2);
      expect(nextMonth.day, 28); // Clamped to Feb 28
    });

    test('startOf() various units', () {
      final full = Hora.of(
        year: 2023,
        month: 6,
        day: 15,
        hour: 14,
        minute: 30,
        second: 45,
      );

      final startOfDay = full.startOf(TemporalUnit.day);
      expect(startOfDay.hour, 0);
      expect(startOfDay.minute, 0);
      expect(startOfDay.second, 0);

      final startOfMonth = full.startOf(TemporalUnit.month);
      expect(startOfMonth.day, 1);
      expect(startOfMonth.hour, 0);

      final startOfYear = full.startOf(TemporalUnit.year);
      expect(startOfYear.month, 1);
      expect(startOfYear.day, 1);
    });

    test('endOf() various units', () {
      final full = Hora.of(year: 2023, month: 6, day: 15);

      final endOfDay = full.endOf(TemporalUnit.day);
      expect(endOfDay.hour, 23);
      expect(endOfDay.minute, 59);
      expect(endOfDay.second, 59);
      expect(endOfDay.millisecond, 999);

      final endOfMonth = full.endOf(TemporalUnit.month);
      expect(endOfMonth.day, 30); // June has 30 days

      final endOfYear = full.endOf(TemporalUnit.year);
      expect(endOfYear.month, 12);
      expect(endOfYear.day, 31);
    });

    test('copyWith()', () {
      final modified = h.copyWith(year: 2025, month: 3);
      expect(modified.year, 2025);
      expect(modified.month, 3);
      expect(modified.day, 15); // Unchanged
    });

    test('copyWith() validates explicit component ranges', () {
      expect(() => h.copyWith(month: 13), throwsArgumentError);
      expect(() => h.copyWith(day: 32), throwsArgumentError);
      expect(() => h.copyWith(hour: 24), throwsArgumentError);
      expect(
        () => Hora.of(year: 2024, day: 31).copyWith(month: 2, day: 31),
        throwsArgumentError,
      );
    });

    test('copyWith() clamps existing day when month changes', () {
      final jan31 = Hora.of(year: 2024, day: 31);
      final toFebruary = jan31.copyWith(month: 2);
      expect(toFebruary.year, 2024);
      expect(toFebruary.month, 2);
      expect(toFebruary.day, 29);
    });

    test('set() is an alias of copyWith()', () {
      final modified = h.set(year: 2026, month: 4, day: 9);
      expect(modified.year, 2026);
      expect(modified.month, 4);
      expect(modified.day, 9);
    });

    test('set() validates explicit component ranges', () {
      expect(() => h.set(minute: 60), throwsArgumentError);
      expect(() => h.set(millisecond: 1000), throwsArgumentError);
      expect(() => h.set(day: 0), throwsArgumentError);
    });

    test('copyWith()/set() keep invalid instance invalid', () {
      final invalid = Hora.parse('invalid');
      final copied = invalid.copyWith(year: 2024);
      final updated = invalid.set(month: 6);

      expect(copied.isValid, isFalse);
      expect(updated.isValid, isFalse);
    });
  });

  group('Hora Comparison', () {
    late Hora earlier;
    late Hora later;
    late Hora same;

    setUp(() {
      earlier = Hora.of(year: 2023, month: 6, day: 15);
      later = Hora.of(year: 2023, month: 6, day: 20);
      same = Hora.of(year: 2023, month: 6, day: 15);
    });

    test('isBefore()', () {
      expect(earlier.isBefore(later), isTrue);
      expect(later.isBefore(earlier), isFalse);
    });

    test('isAfter()', () {
      expect(later.isAfter(earlier), isTrue);
      expect(earlier.isAfter(later), isFalse);
    });

    test('isSame()', () {
      expect(earlier.isSame(same), isTrue);
      expect(earlier.isSame(later), isFalse);
    });

    test('isSame() with unit', () {
      final h1 = Hora.of(year: 2023, month: 6, day: 15, hour: 10);
      final h2 = Hora.of(year: 2023, month: 6, day: 15, hour: 20);
      expect(h1.isSame(h2, TemporalUnit.day), isTrue);
      expect(h1.isSame(h2, TemporalUnit.hour), isFalse);
    });

    test('isBetween() honors inclusivity flags', () {
      final middle = Hora.of(year: 2023, month: 6, day: 17);
      expect(middle.isBetween(earlier, later), isTrue);
      expect(earlier.isBetween(earlier, later, '[]'), isTrue);
      expect(later.isBetween(earlier, later, '[]'), isTrue);
      expect(earlier.isBetween(earlier, later, '[)'), isTrue);
      expect(earlier.isBetween(earlier, later, '(]'), isFalse);
      expect(later.isBetween(earlier, later, '(]'), isTrue);
      expect(later.isBetween(earlier, later, '[)'), isFalse);
      expect(earlier.isBetween(earlier, later), isFalse);
      expect(later.isBetween(earlier, later), isFalse);
      expect(middle.isBetween(later, earlier, '[]'), isFalse);
    });

    test('isBetween() validates inclusivity flag', () {
      final middle = Hora.of(year: 2023, month: 6, day: 17);
      expect(
        () => middle.isBetween(earlier, later, ''),
        throwsArgumentError,
      );
      expect(
        () => middle.isBetween(earlier, later, '<>'),
        throwsArgumentError,
      );
    });

    test('isBetweenWith() provides type-safe inclusivity API', () {
      final middle = Hora.of(year: 2023, month: 6, day: 17);
      expect(middle.isBetweenWith(earlier, later), isTrue);
      expect(
        earlier.isBetweenWith(
          earlier,
          later,
          inclusivity: HoraInclusivity.inclusive,
        ),
        isTrue,
      );
      expect(
        later.isBetweenWith(
          earlier,
          later,
          inclusivity: HoraInclusivity.includeStart,
        ),
        isFalse,
      );
      expect(
        later.isBetweenWith(
          earlier,
          later,
          inclusivity: HoraInclusivity.includeEnd,
        ),
        isTrue,
      );
    });

    test('diff()', () {
      expect(later.diff(earlier, TemporalUnit.day), 5);
      expect(earlier.diff(later, TemporalUnit.day), -5);
    });

    test('diff() precise keeps microsecond precision for fixed units', () {
      final a = Hora.of(year: 2024, month: 6, microsecond: 750);
      final b = Hora.of(year: 2024, month: 6, microsecond: 250);

      expect(a.diff(b, TemporalUnit.microsecond, precise: true), 500);
      expect(
        a.diff(b, TemporalUnit.millisecond, precise: true),
        closeTo(0.5, 1e-12),
      );
      expect(
        a.diff(b, TemporalUnit.second, precise: true),
        closeTo(0.0005, 1e-12),
      );
      expect(a.diff(b, TemporalUnit.millisecond), 0);
    });

    test('compareTo()', () {
      expect(earlier.compareTo(later), isNegative);
      expect(later.compareTo(earlier), isPositive);
      expect(earlier.compareTo(same), isZero);
    });

    test('boolean comparisons return false when either side is invalid', () {
      final invalid = Hora.parse('invalid');

      expect(earlier.isBefore(invalid), isFalse);
      expect(earlier.isAfter(invalid), isFalse);
      expect(earlier.isSame(invalid), isFalse);
      expect(earlier.isSameOrBefore(invalid), isFalse);
      expect(earlier.isSameOrAfter(invalid), isFalse);
      expect(earlier.isSameOrBefore(invalid, TemporalUnit.day), isFalse);
      expect(earlier.isSameOrAfter(invalid, TemporalUnit.day), isFalse);
      expect(invalid.isBefore(earlier), isFalse);
      expect(invalid.isAfter(earlier), isFalse);
      expect(invalid.isSame(earlier), isFalse);
      expect(invalid.isSameOrBefore(earlier), isFalse);
      expect(invalid.isSameOrAfter(earlier), isFalse);
      expect(invalid.isSameOrBefore(earlier, TemporalUnit.day), isFalse);
      expect(invalid.isSameOrAfter(earlier, TemporalUnit.day), isFalse);
      expect(invalid.isBetween(earlier, later), isFalse);
      expect(earlier.isBetween(invalid, later), isFalse);
      expect(earlier.isBetween(earlier, invalid, '[]'), isFalse);
    });

    test('numeric comparisons throw for invalid instances', () {
      final invalid = Hora.parse('invalid');

      expect(() => earlier.difference(invalid), throwsStateError);
      expect(() => invalid.difference(earlier), throwsStateError);
      expect(() => earlier.diff(invalid, TemporalUnit.day), throwsStateError);
      expect(() => invalid.diff(earlier, TemporalUnit.day), throwsStateError);
      expect(() => earlier.compareTo(invalid), throwsStateError);
      expect(() => invalid.compareTo(earlier), throwsStateError);
    });
  });

  group('Hora Query', () {
    test('isToday, isYesterday, isTomorrow', () {
      final now = Hora.now();
      expect(now.isToday, isTrue);

      final yesterday = now.subtract(1, TemporalUnit.day);
      expect(yesterday.isYesterday, isTrue);

      final tomorrow = now.add(1, TemporalUnit.day);
      expect(tomorrow.isTomorrow, isTrue);
    });

    test('isPast and isFuture', () {
      final past = Hora.of(year: 2020);
      final future = Hora.of(year: 2030);
      expect(past.isPast, isTrue);
      expect(future.isFuture, isTrue);
    });

    test('isWeekend and isWeekday', () {
      // 2023-12-23 is Saturday
      final saturday = Hora.of(year: 2023, month: 12, day: 23);
      expect(saturday.isWeekend, isTrue);
      expect(saturday.isWeekday, isFalse);

      // 2023-12-25 is Monday
      final monday = Hora.of(year: 2023, month: 12, day: 25);
      expect(monday.isWeekend, isFalse);
      expect(monday.isWeekday, isTrue);
    });
  });

  group('Hora Formatting', () {
    late Hora h;

    setUp(() {
      h = Hora.of(
        year: 2023,
        month: 6,
        day: 15,
        hour: 14,
        minute: 30,
        second: 45,
        millisecond: 123,
      );
    });

    test('format() with tokens', () {
      expect(h.format('YYYY'), '2023');
      expect(h.format('YY'), '23');
      expect(h.format('MM'), '06');
      expect(h.format('M'), '6');
      expect(h.format('DD'), '15');
      expect(h.format('D'), '15');
      expect(h.format('HH'), '14');
      expect(h.format('mm'), '30');
      expect(h.format('ss'), '45');
      expect(h.format('SSS'), '123');
    });

    test('format() with 12-hour time', () {
      expect(h.format('h'), '2');
      expect(h.format('hh'), '02');
      expect(h.format('A'), 'PM');
      expect(h.format('a'), 'pm');
    });

    test('format() with escaped text', () {
      expect(h.format('[Today is] YYYY-MM-DD'), 'Today is 2023-06-15');
    });

    test('format() with quarter', () {
      expect(h.format('Q'), '2');
    });

    test('toIso8601()', () {
      expect(h.toIso8601(), contains('2023-06-15'));
    });

    test('invalid Hora formats as Invalid Date', () {
      final invalid = Hora.parse('invalid');
      expect(invalid.format('YYYY-MM-DD'), 'Invalid Date');
    });
  });

  group('Hora Conversion', () {
    test('toUtc() and toLocal()', () {
      final local = Hora.now();
      final utc = local.toUtc();
      expect(utc.isUtc, isTrue);

      final backToLocal = utc.toLocal();
      expect(backToLocal.isLocal, isTrue);
    });

    test('toDateTime()', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      final dt = h.toDateTime();
      expect(dt, isA<DateTime>());
      expect(dt.year, 2023);
    });

    test('toList()', () {
      final h = Hora.of(
        year: 2023,
        month: 6,
        day: 15,
        hour: 14,
        minute: 30,
        second: 45,
        millisecond: 123,
        microsecond: 456,
      );
      expect(h.toList(), [2023, 6, 15, 14, 30, 45, 123, 456]);
    });

    test('toMap()', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      final map = h.toMap();
      expect(map['year'], 2023);
      expect(map['month'], 6);
      expect(map['day'], 15);
    });

    test('invalid instance remains stable across conversion and duration APIs',
        () {
      final invalid = Hora.parse('invalid');

      final utc = invalid.toUtc();
      final local = invalid.toLocal();
      final localized = invalid.withLocale(const HoraLocaleZhCn());
      final added = invalid.addDuration(const Duration(days: 1));
      final subtracted = invalid.subtractDuration(const Duration(hours: 2));
      final plus = invalid + const Duration(minutes: 30);
      final minus = invalid - const Duration(seconds: 45);

      expect(utc.isValid, isFalse);
      expect(local.isValid, isFalse);
      expect(localized.isValid, isFalse);
      expect(localized.locale, isA<HoraLocaleZhCn>());
      expect(added.isValid, isFalse);
      expect(subtracted.isValid, isFalse);
      expect(plus.isValid, isFalse);
      expect(minus.isValid, isFalse);
    });
  });

  group('Hora Operators', () {
    test('+ and - with Duration', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      final later = h + const Duration(days: 5);
      expect(later.day, 20);

      final earlier = h - const Duration(days: 5);
      expect(earlier.day, 10);
    });

    test('== and hashCode', () {
      final h1 = Hora.of(year: 2023, month: 6, day: 15);
      final h2 = Hora.of(year: 2023, month: 6, day: 15);
      final h3 = Hora.of(year: 2023, month: 6, day: 16);

      expect(h1 == h2, isTrue);
      expect(h1 == h3, isFalse);
      expect(h1.hashCode, h2.hashCode);
    });
  });
}
