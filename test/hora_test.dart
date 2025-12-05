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

    test('isBetween()', () {
      final middle = Hora.of(year: 2023, month: 6, day: 17);
      expect(middle.isBetween(earlier, later), isTrue);
      expect(earlier.isBetween(earlier, later, '[]'), isTrue);
      expect(earlier.isBetween(earlier, later), isFalse);
    });

    test('diff()', () {
      expect(later.diff(earlier, TemporalUnit.day), 5);
      expect(earlier.diff(later, TemporalUnit.day), -5);
    });

    test('compareTo()', () {
      expect(earlier.compareTo(later), isNegative);
      expect(later.compareTo(earlier), isPositive);
      expect(earlier.compareTo(same), isZero);
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
