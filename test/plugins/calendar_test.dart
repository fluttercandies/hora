import 'package:hora/hora.dart';
import 'package:hora/src/plugins/calendar.dart';
import 'package:test/test.dart';

void main() {
  group('CalendarExt', () {
    group('calendar formatting', () {
      test('expands LLLL token in sameElse', () {
        final h = Hora.of(
          year: 2024,
          month: 5,
          day: 2,
          hour: 9,
          minute: 5,
          locale: const HoraLocaleEn(),
        );

        final formatted = h.calendar(
          referenceDate: Hora.of(year: 2020),
          config: const CalendarConfig(sameElse: 'LLLL'),
        );

        expect(formatted, 'Thursday, May 2, 2024 9:05 AM');
      });

      test('expands LTS token in sameElse', () {
        final h = Hora.of(
          year: 2024,
          month: 5,
          day: 2,
          hour: 9,
          minute: 5,
          second: 7,
          locale: const HoraLocaleEn(),
        );

        final formatted = h.calendar(
          referenceDate: Hora.of(year: 2020),
          config: const CalendarConfig(sameElse: 'LTS'),
        );

        expect(formatted, '9:05:07 AM');
      });

      test('keeps escaped literals intact in default lastWeek pattern', () {
        final reference = Hora.of(
          year: 2024,
          month: 3,
          day: 15,
          hour: 12,
          locale: const HoraLocaleEn(),
        );
        final target = Hora.of(
          year: 2024,
          month: 3,
          day: 13, // two days earlier => lastWeek branch
          hour: 9,
          locale: const HoraLocaleEn(),
        );

        final formatted = target.calendar(referenceDate: reference);
        expect(formatted, 'Last Wednesday at 9:00 AM');
      });

      test('does not expand bracketed L token as localized token', () {
        final h = Hora.of(
          year: 2024,
          month: 5,
          day: 2,
          hour: 9,
          minute: 5,
          locale: const HoraLocaleEn(),
        );

        final formatted = h.calendar(
          referenceDate: h,
          config: const CalendarConfig(sameDay: '[L] LT'),
        );
        expect(formatted, 'L 9:05 AM');
      });
    });

    group('monthCalendar', () {
      test('generates calendar for month', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        final cal = h.monthCalendar();

        expect(cal.year, 2024);
        expect(cal.month, 3);
        expect(cal.weeks.isNotEmpty, isTrue);
      });

      test('each week has 7 slots', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        final cal = h.monthCalendar();

        for (final week in cal.weeks) {
          expect(week.length, 7);
        }
      });

      test('contains all days of month', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        final cal = h.monthCalendar();
        final allDays = cal.weeks.expand((w) => w).whereType<Hora>().toList();

        expect(allDays.length, 31); // March has 31 days
      });

      test('throws for invalid firstDayOfWeek', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        expect(
          () => h.monthCalendar(firstDayOfWeek: 0),
          throwsArgumentError,
        );
        expect(
          () => h.monthCalendar(firstDayOfWeek: 8),
          throwsArgumentError,
        );
      });

      test('preserves UTC dates when source is UTC', () {
        final h = Hora.of(year: 2024, month: 3, day: 15, utc: true);
        final cal = h.monthCalendar();
        final days = cal.weeks.expand((w) => w).whereType<Hora>();

        expect(days.every((d) => d.isUtc), isTrue);
      });
    });

    group('yearCalendar', () {
      test('generates 12 months', () {
        final h = Hora.of(year: 2024);
        final cal = h.yearCalendar();

        expect(cal.months.length, 12);
      });

      test('month access by 1-based index', () {
        final h = Hora.of(year: 2024);
        final cal = h.yearCalendar();

        expect(cal.month(1).month, 1);
        expect(cal.month(6).month, 6);
        expect(cal.month(12).month, 12);
      });
    });

    group('daysOfMonth', () {
      test('returns all days in month', () {
        expect(Hora.of(year: 2024, month: 3).daysOfMonth.length, 31);
        expect(
          Hora.of(year: 2024, month: 2).daysOfMonth.length,
          29,
        ); // leap year
        expect(Hora.of(year: 2023, month: 2).daysOfMonth.length, 28);
      });
    });

    group('daysOfYear', () {
      test('returns 365 or 366 days', () {
        expect(Hora.of(year: 2024).daysOfYear.length, 366); // leap
        expect(Hora.of(year: 2023).daysOfYear.length, 365);
      });
    });

    group('firstWeekdayInMonth', () {
      test('finds first Monday in March 2024', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        final first = h.firstWeekdayInMonth(DateTime.monday);

        expect(first.day, 4);
        expect(first.weekday, DateTime.monday);
      });

      test('throws for invalid weekday', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        expect(() => h.firstWeekdayInMonth(0), throwsArgumentError);
      });
    });

    group('lastWeekdayInMonth', () {
      test('finds last Friday in March 2024', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        final last = h.lastWeekdayInMonth(DateTime.friday);

        expect(last.day, 29);
        expect(last.weekday, DateTime.friday);
      });

      test('throws for invalid weekday', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        expect(() => h.lastWeekdayInMonth(9), throwsArgumentError);
      });
    });

    group('nthWeekdayInMonth', () {
      test('finds 2nd Monday', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        expect(h.nthWeekdayInMonth(DateTime.monday, 2)?.day, 11);
      });

      test('returns null for non-existent nth weekday', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        expect(h.nthWeekdayInMonth(DateTime.monday, 5), isNull);
      });

      test('throws for invalid weekday', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        expect(() => h.nthWeekdayInMonth(0, 1), throwsArgumentError);
      });
    });

    group('isLongWeekend', () {
      test('returns false for standard two-day weekend without holidays', () {
        final saturday = Hora.of(year: 2024, month: 3, day: 16);
        expect(saturday.isLongWeekend(), isFalse);
      });

      test('returns true when holiday extends weekend to three days', () {
        final fridayHoliday = Hora.of(year: 2024, month: 3, day: 15);
        final saturday = Hora.of(year: 2024, month: 3, day: 16);
        final sunday = Hora.of(year: 2024, month: 3, day: 17);
        final holidayDates = {
          fridayHoliday.format('YYYY-MM-DD'),
        };

        bool isHoliday(Hora d) => holidayDates.contains(d.format('YYYY-MM-DD'));

        expect(fridayHoliday.isLongWeekend(isHoliday: isHoliday), isTrue);
        expect(saturday.isLongWeekend(isHoliday: isHoliday), isTrue);
        expect(sunday.isLongWeekend(isHoliday: isHoliday), isTrue);
      });
    });
  });

  group('CalendarIterationExt', () {
    test('monthsInYear generates 12 months', () {
      final months = Hora.of(year: 2024).monthsInYear.toList();
      expect(months.length, 12);
    });

    test('monthsInYear preserves UTC when source is UTC', () {
      final months = Hora.of(year: 2024, utc: true).monthsInYear.toList();
      expect(months.every((m) => m.isUtc), isTrue);
    });

    test('daysUntil generates range', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 3, day: 5);

      expect(start.daysUntil(end).length, 5);
      expect(start.daysUntil(end, inclusive: false).length, 4);
    });

    test('monthsUntil includes both start and end month starts', () {
      final start = Hora.of(year: 2024, month: 2, day: 20);
      final end = Hora.of(year: 2024, month: 5, day: 3);
      final months = start.monthsUntil(end).toList();

      expect(months.length, 4);
      expect(months[0].format('YYYY-MM-DD'), '2024-02-01');
      expect(months[3].format('YYYY-MM-DD'), '2024-05-01');
    });

    test('weekdaysInMonth returns all weekday occurrences', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final mondays = h.weekdaysInMonth(DateTime.monday);

      expect(mondays.length, 4);
      expect(mondays.first.day, 4);
      expect(mondays.last.day, 25);
    });

    test('weekdaysInMonth validates weekday range', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(() => h.weekdaysInMonth(0), throwsArgumentError);
      expect(() => h.weekdaysInMonth(8), throwsArgumentError);
    });
  });
}
