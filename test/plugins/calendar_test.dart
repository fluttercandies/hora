import 'package:hora/hora.dart';
import 'package:hora/src/plugins/calendar.dart';
import 'package:test/test.dart';

void main() {
  group('CalendarExt', () {
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
            Hora.of(year: 2024, month: 2).daysOfMonth.length, 29,); // leap year
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
    });

    group('lastWeekdayInMonth', () {
      test('finds last Friday in March 2024', () {
        final h = Hora.of(year: 2024, month: 3, day: 15);
        final last = h.lastWeekdayInMonth(DateTime.friday);

        expect(last.day, 29);
        expect(last.weekday, DateTime.friday);
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
    });
  });

  group('CalendarIterationExt', () {
    test('monthsInYear generates 12 months', () {
      final months = Hora.of(year: 2024).monthsInYear.toList();
      expect(months.length, 12);
    });

    test('daysUntil generates range', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 3, day: 5);

      expect(start.daysUntil(end).length, 5);
      expect(start.daysUntil(end, inclusive: false).length, 4);
    });
  });
}
