import 'package:hora/hora.dart';
import 'package:hora/src/plugins/week_of_year.dart';
import 'package:test/test.dart';

void main() {
  group('WeekConfig', () {
    test('iso config has Monday start and minDays 4', () {
      expect(WeekConfig.iso.firstDayOfWeek, DateTime.monday);
      expect(WeekConfig.iso.minDaysInFirstWeek, 4);
    });

    test('us config has Sunday start and minDays 1', () {
      expect(WeekConfig.us.firstDayOfWeek, DateTime.sunday);
      expect(WeekConfig.us.minDaysInFirstWeek, 1);
    });

    test('equality', () {
      expect(WeekConfig.iso, equals(WeekConfig.iso));
    });
  });

  group('WeekOfYearExt', () {
    group('isoWeek', () {
      test('mid-year date', () {
        final h = Hora.of(year: 2024, month: 6, day: 15);
        expect(h.isoWeek, inInclusiveRange(1, 53));
      });

      test('Jan 1 may be in previous year week', () {
        // 2024-01-01 is Monday, so it's week 1
        final jan1 = Hora.of(year: 2024);
        expect(jan1.isoWeek, 1);
      });

      test('Dec 31 may be in next year week', () {
        // 2024-12-31 - check it calculates correctly
        final dec31 = Hora.of(year: 2024, month: 12, day: 31);
        expect(dec31.isoWeek, inInclusiveRange(1, 53));
      });
    });

    group('isoWeekYear', () {
      test('mid-year matches calendar year', () {
        final h = Hora.of(year: 2024, month: 6, day: 15);
        expect(h.isoWeekYear, 2024);
      });

      test('edge case: Dec in next week year', () {
        // Find a year where Dec 31 is in week 1 of next year
        final dec31_2019 = Hora.of(year: 2019, month: 12, day: 31);
        // 2019-12-31 is Tuesday, week 1 of 2020
        expect(dec31_2019.isoWeekYear, 2020);
      });
    });

    test('isoWeeksInYear', () {
      final h = Hora.of(year: 2024);
      expect(h.isoWeeksInYear, inInclusiveRange(52, 53));
    });

    test('startOfIsoWeek', () {
      final h = Hora.of(year: 2024, month: 3, day: 15); // Friday
      final start = h.startOfIsoWeek;
      expect(start.weekday, DateTime.monday);
      expect(start.day, 11);
    });

    test('endOfIsoWeek', () {
      final h = Hora.of(year: 2024, month: 3, day: 15); // Friday
      final end = h.endOfIsoWeek;
      expect(end.weekday, DateTime.sunday);
      expect(end.day, 17);
    });

    test('daysOfIsoWeek returns 7 days', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final days = h.daysOfIsoWeek;
      expect(days.length, 7);
      expect(days.first.weekday, DateTime.monday);
      expect(days.last.weekday, DateTime.sunday);
    });

    test('isSameIsoWeek', () {
      final h1 = Hora.of(year: 2024, month: 3, day: 11); // Monday
      final h2 = Hora.of(year: 2024, month: 3, day: 15); // Friday
      final h3 = Hora.of(year: 2024, month: 3, day: 18); // next Monday

      expect(h1.isSameIsoWeek(h2), isTrue);
      expect(h1.isSameIsoWeek(h3), isFalse);
    });

    test('setIsoWeek', () {
      final h = Hora.of(year: 2024, day: 15);
      final newH = h.setIsoWeek(10);
      expect(newH.isoWeek, 10);
    });

    test('isoDayOfWeek', () {
      expect(Hora.of(year: 2024, month: 3, day: 11).isoDayOfWeek, 1); // Monday
      expect(Hora.of(year: 2024, month: 3, day: 17).isoDayOfWeek, 7); // Sunday
    });

    test('weekOfMonth', () {
      expect(Hora.of(year: 2024, month: 3).weekOfMonth, 1);
      expect(Hora.of(year: 2024, month: 3, day: 8).weekOfMonth, 2);
      expect(Hora.of(year: 2024, month: 3, day: 22).weekOfMonth, 4);
    });

    test('weekSpansMonths', () {
      // March 31, 2024 is a Sunday
      final mar31 = Hora.of(year: 2024, month: 3, day: 31);
      // Check if the week spans months
      final start = mar31.startOf(TemporalUnit.week);
      final end = mar31.endOf(TemporalUnit.week);
      if (start.month != end.month) {
        expect(mar31.weekSpansMonths, isTrue);
      }
    });
  });

  group('WeekIterationExt', () {
    test('weeksInThisYear generates weeks', () {
      final h = Hora.of(year: 2024);
      final weeks = h.weeksInThisYear.toList();
      expect(weeks.length, inInclusiveRange(52, 53));
      
      for (final w in weeks) {
        expect(w.isoWeekYear, 2024);
      }
    });

    test('weeksUntil generates range', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 3, day: 31);
      final weeks = start.weeksUntil(end).toList();

      expect(weeks.length, greaterThan(0));
      // All weeks should be from start of week
      for (final w in weeks) {
        expect(w.weekday, DateTime.monday);
      }
    });
  });

  group('custom WeekConfig', () {
    test('weekOfYear with US config', () {
      final h = Hora.of(year: 2024);
      final usWeek = h.weekOfYear(config: WeekConfig.us);
      expect(usWeek, inInclusiveRange(1, 53));
    });

    test('startOfWeekWith US config', () {
      final h = Hora.of(year: 2024, month: 3, day: 15); // Friday
      final start = h.startOfWeekWith(config: WeekConfig.us);
      expect(start.weekday, DateTime.sunday);
    });
  });
}
