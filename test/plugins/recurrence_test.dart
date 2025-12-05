import 'package:hora/hora.dart';
import 'package:hora/src/plugins/recurrence.dart';
import 'package:test/test.dart';

void main() {
  group('Recurrence.daily', () {
    test('generates daily occurrences', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, count: 5);
      final list = rec.toList();

      expect(list.length, 5);
      expect(list[0].day, 1);
      expect(list[1].day, 2);
      expect(list[4].day, 5);
    });

    test('respects interval', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, interval: 2, count: 3);
      final list = rec.toList();

      expect(list.length, 3);
      expect(list[0].day, 1);
      expect(list[1].day, 3);
      expect(list[2].day, 5);
    });

    test('excludes weekdays', () {
      final start = Hora.of(year: 2024, month: 3, day: 4); // Monday
      final rec = Recurrence.daily(
        start: start,
        excludeWeekdays: {DateTime.saturday, DateTime.sunday},
        count: 7,
      );
      final list = rec.toList();

      // Should be Mon-Fri, then next Mon-Tue
      for (final d in list) {
        expect(d.weekday, isNot(DateTime.saturday));
        expect(d.weekday, isNot(DateTime.sunday));
      }
    });

    test('respects end date', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 3, day: 5);
      final rec = Recurrence.daily(start: start, end: end);
      final list = rec.toList();

      expect(list.length, 5);
      expect(list.last.day, 5);
    });
  });

  group('Recurrence.weekly', () {
    test('generates weekly occurrences on specific days', () {
      final start = Hora.of(year: 2024, month: 3, day: 4); // Monday
      final rec = Recurrence.weekly(
        start: start,
        daysOfWeek: {DateTime.monday, DateTime.friday},
        count: 4,
      );
      final list = rec.toList();

      expect(list.length, 4);
      expect(list[0].weekday, DateTime.monday); // Mar 4
      expect(list[1].weekday, DateTime.friday); // Mar 8
      expect(list[2].weekday, DateTime.monday); // Mar 11
      expect(list[3].weekday, DateTime.friday); // Mar 15
    });

    test('respects interval', () {
      final start = Hora.of(year: 2024, month: 3, day: 4); // Monday
      final rec = Recurrence.weekly(
        start: start,
        interval: 2,
        daysOfWeek: {DateTime.monday},
        count: 3,
      );
      final list = rec.toList();

      expect(list.length, 3);
      expect(list[0].day, 4); // Mar 4
      expect(list[1].day, 18); // Mar 18 (2 weeks later)
      expect(list[2].day, 1); // Apr 1 (2 weeks later)
    });
  });

  group('Recurrence.monthly', () {
    test('generates on specific day of month', () {
      final start = Hora.of(year: 2024, day: 15);
      final rec = Recurrence.monthly(start: start, dayOfMonth: 15, count: 3);
      final list = rec.toList();

      expect(list.length, 3);
      expect(list[0].month, 1);
      expect(list[1].month, 2);
      expect(list[2].month, 3);
      for (final d in list) {
        expect(d.day, 15);
      }
    });

    test('handles end of month gracefully', () {
      final start = Hora.of(year: 2024, day: 31);
      final rec = Recurrence.monthly(start: start, dayOfMonth: 31, count: 3);
      final list = rec.toList();

      expect(list.length, 3);
      expect(list[0].day, 31); // Jan 31
      expect(list[1].day, 29); // Feb 29 (leap year)
      expect(list[2].day, 31); // Mar 31
    });

    test('generates on nth weekday of month', () {
      final start = Hora.of(year: 2024);
      final rec = Recurrence.monthly(
        start: start,
        weekdayOrdinal: 2,
        weekday: DateTime.monday,
        count: 3,
      );
      final list = rec.toList();

      // 2nd Monday of each month
      for (final d in list) {
        expect(d.weekday, DateTime.monday);
      }
    });
  });

  group('Recurrence.yearly', () {
    test('generates yearly occurrences', () {
      final start = Hora.of(year: 2024, month: 7, day: 4);
      final rec = Recurrence.yearly(start: start, count: 3);
      final list = rec.toList();

      expect(list.length, 3);
      expect(list[0].year, 2024);
      expect(list[1].year, 2025);
      expect(list[2].year, 2026);
    });

    test('handles Feb 29 for leap years', () {
      final start = Hora.of(year: 2024, month: 2, day: 29);
      final rec = Recurrence.yearly(start: start, count: 4);
      final list = rec.toList();

      expect(list.length, 4);
      expect(list[0].day, 29); // 2024 leap
      expect(list[1].day, 28); // 2025 non-leap
      expect(list[2].day, 28); // 2026 non-leap
      expect(list[3].day, 28); // 2027 non-leap
    });
  });

  group('Recurrence.custom', () {
    test('uses custom generator', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.custom(
        start: start,
        generator: (current) => current.add(3, TemporalUnit.day),
        count: 4,
      );
      final list = rec.toList();

      expect(list.length, 4);
      expect(list[0].day, 1);
      expect(list[1].day, 4);
      expect(list[2].day, 7);
      expect(list[3].day, 10);
    });
  });

  group('Recurrence methods', () {
    test('occurrence returns nth occurrence', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start);

      expect(rec.occurrence(0)?.day, 1);
      expect(rec.occurrence(4)?.day, 5);
    });

    test('matches checks if date matches pattern', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, interval: 2);

      expect(rec.matches(Hora.of(year: 2024, month: 3)), isTrue);
      expect(rec.matches(Hora.of(year: 2024, month: 3, day: 3)), isTrue);
      expect(rec.matches(Hora.of(year: 2024, month: 3, day: 2)), isFalse);
    });

    test('between returns occurrences in range', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start);
      
      final rangeStart = Hora.of(year: 2024, month: 3, day: 5);
      final rangeEnd = Hora.of(year: 2024, month: 3, day: 10);
      final result = rec.between(rangeStart, rangeEnd);

      expect(result.length, 6);
      expect(result.first.day, 5);
      expect(result.last.day, 10);
    });
  });

  group('RecurrenceExt', () {
    test('daily creates recurrence from Hora', () {
      final h = Hora.of(year: 2024, month: 3);
      final rec = h.daily(count: 3);
      expect(rec.toList().length, 3);
    });

    test('weekly creates recurrence from Hora', () {
      final h = Hora.of(year: 2024, month: 3, day: 4); // Monday
      final rec = h.weekly(count: 3);
      expect(rec.toList().length, 3);
    });

    test('nextMatching finds next match', () {
      final h = Hora.of(year: 2024, month: 3, day: 5); // Tuesday
      final next = h.nextMatching((d) => d.weekday == DateTime.friday);
      expect(next?.day, 8);
      expect(next?.weekday, DateTime.friday);
    });

    test('previousMatching finds previous match', () {
      final h = Hora.of(year: 2024, month: 3, day: 5); // Tuesday
      final prev = h.previousMatching((d) => d.weekday == DateTime.monday);
      expect(prev?.day, 4);
      expect(prev?.weekday, DateTime.monday);
    });
  });
}
