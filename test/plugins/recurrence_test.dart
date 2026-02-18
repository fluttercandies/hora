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

    test('start after end returns empty sequence', () {
      final start = Hora.of(year: 2024, month: 3, day: 10);
      final end = Hora.of(year: 2024, month: 3, day: 9);
      final rec = Recurrence.daily(start: start, end: end);
      expect(rec.toList(), isEmpty);
    });

    test('count zero returns empty sequence', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, count: 0);
      expect(rec.toList(), isEmpty);
    });

    test('interval must be greater than zero', () {
      final start = Hora.of(year: 2024, month: 3);
      expect(
        () => Recurrence.daily(start: start, interval: 0),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.daily(start: start, interval: -1),
        throwsArgumentError,
      );
    });

    test('excludeWeekdays must be in 1..7', () {
      final start = Hora.of(year: 2024, month: 3);
      expect(
        () => Recurrence.daily(start: start, excludeWeekdays: {0}),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.daily(start: start, excludeWeekdays: {8}),
        throwsArgumentError,
      );
    });

    test('excludeWeekdays cannot exclude all weekdays', () {
      final start = Hora.of(year: 2024, month: 3);
      expect(
        () => Recurrence.daily(
          start: start,
          excludeWeekdays: {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
            DateTime.sunday,
          },
        ),
        throwsArgumentError,
      );
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

    test('interval must be greater than zero', () {
      final start = Hora.of(year: 2024, month: 3, day: 4);
      expect(
        () => Recurrence.weekly(
          start: start,
          interval: 0,
          daysOfWeek: {DateTime.monday},
        ),
        throwsArgumentError,
      );
    });

    test('daysOfWeek values must be in 1..7', () {
      final start = Hora.of(year: 2024, month: 3, day: 4);
      expect(
        () => Recurrence.weekly(start: start, daysOfWeek: {0}),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.weekly(start: start, daysOfWeek: {8}),
        throwsArgumentError,
      );
    });

    test('daysOfWeek must not be empty', () {
      final start = Hora.of(year: 2024, month: 3, day: 4);
      expect(
        () => Recurrence.weekly(start: start, daysOfWeek: const {}),
        throwsArgumentError,
      );
    });

    test(
        'matches returns true for start even when start weekday is not in rule',
        () {
      final start = Hora.of(year: 2024, month: 3, day: 4); // Monday
      final rec = Recurrence.weekly(
        start: start,
        daysOfWeek: {DateTime.friday},
        count: 3,
      );
      expect(rec.matches(start), isTrue);
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

    test('preserves start time and utc in generated occurrences', () {
      final start = Hora.of(
        year: 2024,
        day: 31,
        hour: 9,
        minute: 45,
        second: 12,
        millisecond: 123,
        microsecond: 456,
        utc: true,
      );
      final rec = Recurrence.monthly(start: start, count: 2);
      final list = rec.toList();

      expect(list[1].isUtc, isTrue);
      expect(list[1].hour, 9);
      expect(list[1].minute, 45);
      expect(list[1].second, 12);
      expect(list[1].millisecond, 123);
      expect(list[1].microsecond, 456);
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

    test('skips months without requested positive weekday ordinal', () {
      final start = Hora.of(year: 2024); // Monday
      final rec = Recurrence.monthly(
        start: start,
        weekdayOrdinal: 5,
        weekday: DateTime.monday,
        count: 2,
      );
      final list = rec.toList();

      expect(list[0], start);
      expect(list[1].year, 2024);
      expect(list[1].month, 4);
      expect(list[1].day, 29);
      expect(list[1].weekday, DateTime.monday);
    });

    test('skips months without requested negative weekday ordinal', () {
      final start = Hora.of(year: 2024); // Monday
      final rec = Recurrence.monthly(
        start: start,
        weekdayOrdinal: -5,
        weekday: DateTime.monday,
        count: 2,
      );
      final list = rec.toList();

      expect(list[0], start);
      expect(list[1].year, 2024);
      expect(list[1].month, 4);
      expect(list[1].day, 1);
      expect(list[1].weekday, DateTime.monday);
    });

    test('positive 5th weekday remains strictly increasing for long sequence',
        () {
      final start = Hora.of(year: 2024); // Monday
      final rec = Recurrence.monthly(
        start: start,
        weekdayOrdinal: 5,
        weekday: DateTime.monday,
        count: 8,
      );
      final list = rec.toList();

      expect(list.length, 8);
      for (var i = 1; i < list.length; i++) {
        expect(list[i].isAfter(list[i - 1]), isTrue);
        expect(list[i].weekday, DateTime.monday);
      }
    });

    test('respects end when next valid ordinal weekday is beyond end', () {
      final start = Hora.of(year: 2024); // 2024-01-01 Monday
      final end = Hora.of(year: 2024, month: 3, day: 31, hour: 23, minute: 59);
      final rec = Recurrence.monthly(
        start: start,
        end: end,
        weekdayOrdinal: 5,
        weekday: DateTime.monday,
      );
      final list = rec.toList();

      // Jan has 5 Mondays; next valid month is Apr (beyond end)
      expect(list.length, 1);
      expect(list.single, start);
    });

    test('weekday rule requires both weekdayOrdinal and weekday', () {
      final start = Hora.of(year: 2024);
      expect(
        () => Recurrence.monthly(start: start, weekdayOrdinal: 1),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.monthly(start: start, weekday: DateTime.monday),
        throwsArgumentError,
      );
    });

    test('weekdayOrdinal must be in -5..-1 or 1..5', () {
      final start = Hora.of(year: 2024);
      expect(
        () => Recurrence.monthly(
          start: start,
          weekdayOrdinal: 0,
          weekday: DateTime.monday,
        ),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.monthly(
          start: start,
          weekdayOrdinal: 6,
          weekday: DateTime.monday,
        ),
        throwsArgumentError,
      );
    });

    test('dayOfMonth must be in 1..31', () {
      final start = Hora.of(year: 2024);
      expect(
        () => Recurrence.monthly(start: start, dayOfMonth: 0),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.monthly(start: start, dayOfMonth: 32),
        throwsArgumentError,
      );
    });

    test('interval must be greater than zero', () {
      final start = Hora.of(year: 2024);
      expect(
        () => Recurrence.monthly(start: start, interval: 0),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.monthly(start: start, interval: -2),
        throwsArgumentError,
      );
    });

    test('matches returns true for start even when start does not satisfy rule',
        () {
      final start = Hora.of(year: 2024); // Monday
      final byDay = Recurrence.monthly(start: start, dayOfMonth: 15, count: 3);
      final byWeekday = Recurrence.monthly(
        start: start,
        weekdayOrdinal: 2,
        weekday: DateTime.monday,
        count: 3,
      );

      expect(byDay.matches(start), isTrue);
      expect(byWeekday.matches(start), isTrue);
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

    test('preserves utc and sub-second time for Feb 29 rollover', () {
      final start = Hora.of(
        year: 2024,
        month: 2,
        day: 29,
        hour: 22,
        minute: 10,
        second: 3,
        millisecond: 123,
        microsecond: 456,
        utc: true,
      );
      final rec = Recurrence.yearly(start: start, count: 2);
      final list = rec.toList();

      expect(list[1].isUtc, isTrue);
      expect(list[1].day, 28);
      expect(list[1].hour, 22);
      expect(list[1].minute, 10);
      expect(list[1].second, 3);
      expect(list[1].millisecond, 123);
      expect(list[1].microsecond, 456);
    });

    test('interval must be greater than zero', () {
      final start = Hora.of(year: 2024, month: 7, day: 4);
      expect(
        () => Recurrence.yearly(start: start, interval: 0),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.yearly(start: start, interval: -1),
        throwsArgumentError,
      );
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

    test('rejects negative count', () {
      final start = Hora.of(year: 2024, month: 3);
      expect(
        () => Recurrence.custom(
          start: start,
          generator: (current) => current.add(1, TemporalUnit.day),
          count: -1,
        ),
        throwsArgumentError,
      );
    });

    test('throws when generator does not progress forward', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.custom(
        start: start,
        generator: (_) => start,
        count: 2,
      );
      expect(rec.toList, throwsStateError);
    });

    test('throws when generator moves backwards', () {
      final start = Hora.of(year: 2024, month: 3, day: 10);
      final rec = Recurrence.custom(
        start: start,
        generator: (current) => current.subtract(1, TemporalUnit.day),
        count: 2,
      );
      expect(rec.toList, throwsStateError);
    });
  });

  group('Recurrence methods', () {
    test('next returns next occurrence for recurrence instance', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, interval: 2);
      final next = rec.next(start);
      expect(next, isNotNull);
      expect(next!.day, 3);
    });

    test('occurrence returns nth occurrence', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start);

      expect(rec.occurrence(0)?.day, 1);
      expect(rec.occurrence(4)?.day, 5);
    });

    test('occurrence returns null when count is zero', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, count: 0);
      expect(rec.occurrence(0), isNull);
    });

    test('occurrence returns null when start is after end', () {
      final start = Hora.of(year: 2024, month: 3, day: 10);
      final end = Hora.of(year: 2024, month: 3, day: 9);
      final rec = Recurrence.daily(start: start, end: end);
      expect(rec.occurrence(0), isNull);
    });

    test('occurrence returns null on negative index', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, count: 5);
      expect(rec.occurrence(-1), isNull);
    });

    test('occurrence respects count upper bound', () {
      final start = Hora.of(year: 2024, month: 3);
      final rec = Recurrence.daily(start: start, count: 2);
      expect(rec.occurrence(0)?.day, 1);
      expect(rec.occurrence(1)?.day, 2);
      expect(rec.occurrence(2), isNull);
      expect(rec.occurrence(20), isNull);
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

    test('validateInterval accepts positive and rejects non-positive', () {
      expect(() => Recurrence.validateInterval(1), returnsNormally);
      expect(() => Recurrence.validateInterval(0), throwsArgumentError);
      expect(() => Recurrence.validateInterval(-1), throwsArgumentError);
    });

    test('validateCount accepts null/non-negative and rejects negative', () {
      expect(() => Recurrence.validateCount(null), returnsNormally);
      expect(() => Recurrence.validateCount(0), returnsNormally);
      expect(() => Recurrence.validateCount(1), returnsNormally);
      expect(() => Recurrence.validateCount(-1), throwsArgumentError);
    });

    test('validateWeekdays enforces ISO weekday range', () {
      expect(
        () => Recurrence.validateWeekdays(
          const [DateTime.monday, DateTime.sunday],
          field: 'weekdays',
        ),
        returnsNormally,
      );
      expect(
        () => Recurrence.validateWeekdays(const [0], field: 'weekdays'),
        throwsArgumentError,
      );
      expect(
        () => Recurrence.validateWeekdays(const [8], field: 'weekdays'),
        throwsArgumentError,
      );
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

  group('Recurrence properties', () {
    test('generated daily sequence is strictly increasing and self-matching',
        () {
      final rec = Recurrence.daily(
        start: Hora.of(year: 2024, hour: 9),
        interval: 3,
        excludeWeekdays: {DateTime.saturday, DateTime.sunday},
        count: 40,
      );
      final list = rec.toList();

      expect(list.length, 40);
      for (var i = 0; i < list.length; i++) {
        if (i > 0) {
          expect(list[i].isAfter(list[i - 1]), isTrue);
        }
        expect(rec.matches(list[i]), isTrue);
      }
    });

    test('generated weekly sequence is strictly increasing and self-matching',
        () {
      final rec = Recurrence.weekly(
        start: Hora.of(year: 2024, hour: 8), // Monday
        interval: 2,
        daysOfWeek: {DateTime.monday, DateTime.wednesday, DateTime.friday},
        count: 50,
      );
      final list = rec.toList();

      expect(list.length, 50);
      for (var i = 0; i < list.length; i++) {
        if (i > 0) {
          expect(list[i].isAfter(list[i - 1]), isTrue);
        }
        expect(rec.matches(list[i]), isTrue);
      }
    });

    test(
        'generated monthly weekday-ordinal sequence stays in-month and self-matching',
        () {
      final rec = Recurrence.monthly(
        start: Hora.of(year: 2024, hour: 10), // Monday
        weekdayOrdinal: 5,
        weekday: DateTime.monday,
        count: 24,
      );
      final list = rec.toList();

      expect(list.length, 24);
      for (var i = 0; i < list.length; i++) {
        if (i > 0) {
          expect(list[i].isAfter(list[i - 1]), isTrue);
          // Monthly recurrence includes start as first item even when start
          // does not satisfy weekdayOrdinal/weekday rule.
          expect(rec.matches(list[i]), isTrue);
          // 5th weekday must be day 29..31 and stay inside current month.
          expect(list[i].day >= 29 && list[i].day <= 31, isTrue);
        }
      }
    });

    test('generated yearly sequence preserves month/day rule and self-matching',
        () {
      final rec = Recurrence.yearly(
        start: Hora.of(
          year: 2024,
          month: 2,
          day: 29,
          hour: 6,
          minute: 30,
          utc: true,
        ),
        count: 20,
      );
      final list = rec.toList();

      expect(list.length, 20);
      for (var i = 0; i < list.length; i++) {
        if (i > 0) {
          expect(list[i].isAfter(list[i - 1]), isTrue);
        }
        expect(list[i].isUtc, isTrue);
        expect(list[i].month, 2);
        expect(list[i].day == 29 || list[i].day == 28, isTrue);
        expect(rec.matches(list[i]), isTrue);
      }
    });

    test('yearly Feb 29 recurrence restores Feb 29 on later leap years', () {
      final rec = Recurrence.yearly(
        start: Hora.of(
          year: 2024,
          month: 2,
          day: 29,
          hour: 6,
          minute: 30,
          utc: true,
        ),
        count: 6,
      );
      final list = rec.toList();

      expect(list[0].toList().sublist(0, 3), [2024, 2, 29]);
      expect(list[1].toList().sublist(0, 3), [2025, 2, 28]);
      expect(list[2].toList().sublist(0, 3), [2026, 2, 28]);
      expect(list[3].toList().sublist(0, 3), [2027, 2, 28]);
      expect(list[4].toList().sublist(0, 3), [2028, 2, 29]);
      expect(list[5].toList().sublist(0, 3), [2029, 2, 28]);
    });

    test('between() matches deterministic windows of generated occurrences',
        () {
      final rec = Recurrence.daily(
        start: Hora.of(year: 2024, hour: 9),
        interval: 2,
        count: 80,
      );
      final all = rec.toList();
      final windows = [
        (start: 0, end: 0),
        (start: 0, end: 10),
        (start: 5, end: 20),
        (start: 10, end: 79),
        (start: 30, end: 30),
      ];

      for (final w in windows) {
        final rangeStart = all[w.start];
        final rangeEnd = all[w.end];
        final between = rec.between(rangeStart, rangeEnd);
        expect(
          between,
          all.sublist(w.start, w.end + 1),
          reason: 'window=${w.start}-${w.end}',
        );
      }
    });
  });
}
