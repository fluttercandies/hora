import 'package:hora/hora.dart';
import 'package:hora/src/plugins/calendar.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeToHora Extension', () {
    test('toHora() converts DateTime', () {
      final dt = DateTime(2023, 12, 25, 14, 30);
      final h = dt.toHora();
      expect(h.year, 2023);
      expect(h.month, 12);
      expect(h.day, 25);
      expect(h.hour, 14);
      expect(h.minute, 30);
    });

    test('toHora() with locale', () {
      final dt = DateTime(2023, 12, 25);
      final h = dt.toHora(locale: const HoraLocaleZhCn());
      expect(h.locale.code, 'zh-cn');
    });
  });

  group('IntToHora Extension', () {
    test('asUnixSeconds', () {
      final h = 1703462400.asUnixSeconds;
      expect(h.unix, 1703462400);
    });

    test('asUnixMillis', () {
      final h = 1703462400000.asUnixMillis;
      expect(h.unixMillis, 1703462400000);
    });

    test('asUnix() supports precision option', () {
      final h = 1703462400.asUnix(unit: UnixTimestampUnit.seconds);
      expect(h.toUtc().day, 25);
    });

    test('duration extensions', () {
      expect(5.days.days, 5);
      expect(3.hours.hours, 3);
      expect(30.minutes.minutes, 30);
      expect(45.seconds.seconds, 45);
      expect(6.months.months, 6);
      expect(2.years.years, 2);
      expect(2.weeks.weeks, 2);
    });
  });

  group('StringToHora Extension', () {
    test('toHora() parses string', () {
      final h = '2023-12-25'.toHora();
      expect(h.year, 2023);
      expect(h.month, 12);
      expect(h.day, 25);
    });

    test('tryToHora() returns null for invalid', () {
      expect('invalid'.tryToHora(), isNull);
    });

    test('toHora() supports parse mode', () {
      expect('2023/12/25'.toHora().isValid, isTrue);
      expect(
        '2023/12/25'.toHora(mode: HoraParseMode.strict).isValid,
        isFalse,
      );
    });

    test('toHoraDuration() parses ISO 8601', () {
      final d = 'P1Y2M3D'.toHoraDuration();
      expect(d.years, 1);
      expect(d.months, 2);
      expect(d.days, 3);
    });

    test('tryToHoraDuration() returns null for invalid', () {
      expect('invalid'.tryToHoraDuration(), isNull);
    });
  });

  group('DurationToHora Extension', () {
    test('toHoraDuration() converts Duration', () {
      const d = Duration(days: 5, hours: 6, minutes: 30);
      final hd = d.toHoraDuration();
      expect(hd.inHours, 126);
      expect(hd.inMinutes, 7590);
    });
  });

  group('MapToHora Extension', () {
    test('toHora() creates Hora from map', () {
      final h = {
        'year': 2024,
        'month': 6,
        'day': 15,
      }.toHora();
      expect(h.year, 2024);
      expect(h.month, 6);
      expect(h.day, 15);
    });

    test('tryToHora() returns null on invalid map date string', () {
      final h = <String, Object?>{'date': 'not-a-date'}.tryToHora();
      expect(h, isNull);
    });
  });

  group('HoraRelativeTimeExt', () {
    test('fromNow()', () {
      final past = Hora.now().subtract(5, TemporalUnit.day);
      expect(past.fromNow(), contains('5 days ago'));
    });

    test('fromNow() with withoutSuffix', () {
      final past = Hora.now().subtract(5, TemporalUnit.day);
      expect(past.fromNow(withoutSuffix: true), '5 days');
    });

    test('toNow()', () {
      // toNow() is the inverse of fromNow()
      // For a future time, toNow() says "how long ago from that point to now"
      final future = Hora.now().add(3, TemporalUnit.hour);
      expect(future.toNow(), contains('ago'));
    });

    test('from() another Hora', () {
      final h1 = Hora.of(year: 2023, month: 6, day: 15);
      final h2 = Hora.of(year: 2023, month: 6, day: 20);
      expect(h2.from(h1), contains('5 days'));
    });

    test('to() another Hora', () {
      final h1 = Hora.of(year: 2023, month: 6, day: 15);
      final h2 = Hora.of(year: 2023, month: 6, day: 20);
      expect(h1.to(h2), contains('5 days'));
    });
  });

  group('HoraCalendarExt', () {
    test('calendar() for today', () {
      final now = Hora.now();
      expect(now.calendar(), contains('Today'));
    });

    test('calendar() for yesterday', () {
      final yesterday = Hora.now().subtract(1, TemporalUnit.day);
      expect(yesterday.calendar(), contains('Yesterday'));
    });

    test('calendar() for tomorrow', () {
      final tomorrow = Hora.now().add(1, TemporalUnit.day);
      expect(tomorrow.calendar(), contains('Tomorrow'));
    });
  });

  group('HoraMinMaxExt', () {
    test('earliest', () {
      final dates = [
        Hora.of(year: 2023, month: 6, day: 20),
        Hora.of(year: 2023, month: 6, day: 10),
        Hora.of(year: 2023, month: 6, day: 15),
      ];
      expect(dates.earliest?.day, 10);
    });

    test('latest', () {
      final dates = [
        Hora.of(year: 2023, month: 6, day: 20),
        Hora.of(year: 2023, month: 6, day: 10),
        Hora.of(year: 2023, month: 6, day: 15),
      ];
      expect(dates.latest?.day, 20);
    });

    test('range', () {
      final dates = [
        Hora.of(year: 2023, month: 6, day: 20),
        Hora.of(year: 2023, month: 6, day: 10),
        Hora.of(year: 2023, month: 6, day: 15),
      ];
      final (min, max) = dates.range;
      expect(min?.day, 10);
      expect(max?.day, 20);
    });

    test('earliest/latest return null for empty', () {
      final dates = <Hora>[];
      expect(dates.earliest, isNull);
      expect(dates.latest, isNull);
    });

    test('skips invalid Hora instances', () {
      final dates = [
        Hora.of(year: 2023, month: 6, day: 20),
        Hora.parse('invalid'),
        Hora.of(year: 2023, month: 6, day: 10),
      ];
      expect(dates.earliest?.day, 10);
      expect(dates.latest?.day, 20);
    });
  });

  group('HoraRangeExt', () {
    test('rangeTo() generates dates', () {
      final start = Hora.of(year: 2023, month: 6, day: 10);
      final end = Hora.of(year: 2023, month: 6, day: 15);
      final range = start.rangeTo(end).toList();
      expect(range, hasLength(6));
      expect(range.first.day, 10);
      expect(range.last.day, 15);
    });

    test('rangeTo() with step', () {
      final start = Hora.of(year: 2023, month: 6, day: 10);
      final end = Hora.of(year: 2023, month: 6, day: 20);
      final range = start.rangeTo(end, step: 2).toList();
      expect(range.map((h) => h.day), [10, 12, 14, 16, 18, 20]);
    });

    test('rangeTo() reverse', () {
      final start = Hora.of(year: 2023, month: 6, day: 15);
      final end = Hora.of(year: 2023, month: 6, day: 10);
      final range = start.rangeTo(end).toList();
      expect(range, hasLength(6));
      expect(range.first.day, 15);
      expect(range.last.day, 10);
    });

    test('rangeTo() validates input and step', () {
      final valid = Hora.of(year: 2023, month: 6, day: 10);
      final invalid = Hora.parse('invalid');

      expect(
        () => valid.rangeTo(valid, step: 0).toList(),
        throwsArgumentError,
      );
      expect(
        () => invalid.rangeTo(valid).toList(),
        throwsArgumentError,
      );
      expect(
        () => valid.rangeTo(invalid).toList(),
        throwsArgumentError,
      );
    });

    test('take() generates n dates', () {
      final start = Hora.of(year: 2023, month: 6, day: 10);
      final dates = start.take(5).toList();
      expect(dates, hasLength(5));
      expect(dates.map((h) => h.day), [10, 11, 12, 13, 14]);
    });

    test('take() with unit', () {
      final start = Hora.of(year: 2023);
      final dates = start.take(3, unit: TemporalUnit.month).toList();
      expect(dates.map((h) => h.month), [1, 2, 3]);
    });

    test('take() validates count, step, and start instance', () {
      final valid = Hora.of(year: 2023);
      final invalid = Hora.parse('invalid');

      expect(() => valid.take(-1).toList(), throwsArgumentError);
      expect(() => valid.take(3, step: 0).toList(), throwsArgumentError);
      expect(() => invalid.take(1).toList(), throwsArgumentError);
      expect(valid.take(0), isEmpty);
    });
  });

  group('HoraBuilderExt', () {
    test('setters', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      expect(h.setYear(2024).year, 2024);
      expect(h.setMonth(12).month, 12);
      expect(h.setDay(25).day, 25);
      expect(h.setHour(10).hour, 10);
      expect(h.setMinute(30).minute, 30);
      expect(h.setSecond(45).second, 45);
      expect(h.setMillisecond(123).millisecond, 123);
      expect(h.setMicrosecond(456).microsecond, 456);
    });

    test('setters validate ranges', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      expect(() => h.setMonth(13), throwsArgumentError);
      expect(() => h.setDay(0), throwsArgumentError);
      expect(() => h.setHour(24), throwsArgumentError);
    });

    test('navigation shortcuts', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      expect(h.nextYear.year, 2024);
      expect(h.previousYear.year, 2022);
      expect(h.nextMonth.month, 7);
      expect(h.previousMonth.month, 5);
      expect(h.nextWeek.day, 22);
      expect(h.previousWeek.day, 8);
      expect(h.nextDay.day, 16);
      expect(h.previousDay.day, 14);
    });

    test('boundary shortcuts', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      expect(h.firstDayOfYear.month, 1);
      expect(h.firstDayOfYear.day, 1);
      expect(h.lastDayOfYear.month, 12);
      expect(h.lastDayOfYear.day, 31);
      expect(h.firstDayOfMonth.day, 1);
      expect(h.lastDayOfMonth.day, 30);
    });
  });
}
