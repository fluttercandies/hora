import 'package:hora/hora.dart';
import 'package:hora/src/plugins/business_day.dart';
import 'package:test/test.dart';

void main() {
  group('BusinessDayExt', () {
    group('isBusinessDay', () {
      test('weekday is business day', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        expect(monday.isBusinessDay(), isTrue);
      });

      test('weekend is not business day', () {
        final saturday = Hora.of(year: 2024, month: 3, day: 16);
        final sunday = Hora.of(year: 2024, month: 3, day: 17);

        expect(saturday.isBusinessDay(), isFalse);
        expect(sunday.isBusinessDay(), isFalse);
      });

      test('respects custom config', () {
        final saturday = Hora.of(year: 2024, month: 3, day: 16);
        final config = BusinessDayConfig(weekendDays: {DateTime.sunday});
        expect(saturday.isBusinessDay(config), isTrue);
      });

      test('throws for invalid weekend day values', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        final config = BusinessDayConfig(weekendDays: {0, DateTime.sunday});
        expect(() => monday.isBusinessDay(config), throwsArgumentError);
      });

      test('respects holidays', () {
        final friday = Hora.of(year: 2024, month: 3, day: 15);
        final holidays = HolidayCalendar(
          fixedHolidays: [DateTime(2024, 3, 15)],
        );
        final config = BusinessDayConfig(holidays: holidays);
        expect(friday.isBusinessDay(config), isFalse);
      });
    });

    group('isWeekendDay', () {
      test('detects weekends with default config', () {
        final saturday = Hora.of(year: 2024, month: 3, day: 16);
        final monday = Hora.of(year: 2024, month: 3, day: 11);

        expect(saturday.isWeekendDay(), isTrue);
        expect(monday.isWeekendDay(), isFalse);
      });

      test('respects custom weekend config and validates values', () {
        final friday = Hora.of(year: 2024, month: 3, day: 15);
        final custom = BusinessDayConfig(
          weekendDays: {DateTime.friday, DateTime.saturday},
        );
        final invalid = BusinessDayConfig(weekendDays: {8});

        expect(friday.isWeekendDay(custom), isTrue);
        expect(() => friday.isWeekendDay(invalid), throwsArgumentError);
      });
    });

    group('nextBusinessDay', () {
      test('returns next business day from weekend', () {
        final saturday = Hora.of(year: 2024, month: 3, day: 16);
        final next = saturday.nextBusinessDay();

        expect(next.weekday, DateTime.monday);
        expect(next.day, 18);
      });

      test('returns same day if already business day', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        final next = monday.nextBusinessDay();

        expect(next.day, 11);
      });

      test('throws for invalid Hora', () {
        final invalid = Hora.parse('invalid');
        expect(invalid.nextBusinessDay, throwsStateError);
      });

      test('throws when all weekdays are configured as weekend', () {
        final anyDay = Hora.of(year: 2024, month: 3, day: 12);
        final noBusinessDayConfig = BusinessDayConfig(
          weekendDays: {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
            DateTime.sunday,
          },
        );
        expect(
          () => anyDay.nextBusinessDay(noBusinessDayConfig),
          throwsStateError,
        );
      });
    });

    group('previousBusinessDay', () {
      test('returns previous business day from weekend', () {
        final sunday = Hora.of(year: 2024, month: 3, day: 17);
        final prev = sunday.previousBusinessDay();

        expect(prev.weekday, DateTime.friday);
        expect(prev.day, 15);
      });
    });

    group('nearestBusinessDay', () {
      test('returns same day when already a business day', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        expect(monday.nearestBusinessDay(), same(monday));
      });

      test('chooses previous or next business day by distance', () {
        final saturday = Hora.of(year: 2024, month: 3, day: 16);
        final sunday = Hora.of(year: 2024, month: 3, day: 17);

        expect(saturday.nearestBusinessDay().day, 15); // Friday is closer.
        expect(sunday.nearestBusinessDay().day, 18); // Monday is closer.
      });

      test('prefers next day when distances are equal', () {
        final sunday = Hora.of(year: 2024, month: 3, day: 17);
        final config = BusinessDayConfig(weekendDays: {DateTime.sunday});

        final nearest = sunday.nearestBusinessDay(config);
        expect(nearest.weekday, DateTime.monday);
        expect(nearest.day, 18);
      });
    });

    group('addBusinessDays', () {
      test('adds business days skipping weekend', () {
        final friday = Hora.of(year: 2024, month: 3, day: 15);
        final result = friday.addBusinessDays(1);

        expect(result.weekday, DateTime.monday);
        expect(result.day, 18);
      });

      test('adds multiple business days', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        final result = monday.addBusinessDays(5);

        expect(result.day, 18); // Mon + 5 business days = next Mon
      });

      test('throws for invalid Hora', () {
        final invalid = Hora.parse('invalid');
        expect(() => invalid.addBusinessDays(1), throwsStateError);
      });

      test('returns same instance for zero business days', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        expect(monday.addBusinessDays(0), same(monday));
      });

      test('supports negative values for reverse traversal', () {
        final monday = Hora.of(year: 2024, month: 3, day: 18);
        final result = monday.addBusinessDays(-1);
        expect(result.weekday, DateTime.friday);
        expect(result.day, 15);
      });

      test('throws when all weekdays are configured as weekend', () {
        final anyDay = Hora.of(year: 2024, month: 3, day: 12);
        final noBusinessDayConfig = BusinessDayConfig(
          weekendDays: {
            DateTime.monday,
            DateTime.tuesday,
            DateTime.wednesday,
            DateTime.thursday,
            DateTime.friday,
            DateTime.saturday,
            DateTime.sunday,
          },
        );

        expect(
          () => anyDay.addBusinessDays(1, noBusinessDayConfig),
          throwsStateError,
        );
      });
    });

    group('subtractBusinessDays', () {
      test('subtracts business days', () {
        final monday = Hora.of(year: 2024, month: 3, day: 18);
        final result = monday.subtractBusinessDays(1);

        expect(result.weekday, DateTime.friday);
        expect(result.day, 15);
      });
    });

    group('businessDaysBetween', () {
      test('counts business days between dates', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        final nextMonday = Hora.of(year: 2024, month: 3, day: 18);

        expect(monday.businessDaysBetween(nextMonday), 5);
      });

      test('returns negative count for reverse order', () {
        final monday = Hora.of(year: 2024, month: 3, day: 11);
        final nextMonday = Hora.of(year: 2024, month: 3, day: 18);
        expect(nextMonday.businessDaysBetween(monday), -5);
      });
    });

    group('business week boundaries', () {
      test('startOfBusinessWeek defaults to Monday', () {
        final date = Hora.of(year: 2024, month: 3, day: 13); // Wednesday
        final start = date.startOfBusinessWeek();
        expect(start.weekday, DateTime.monday);
        expect(start.day, 11);
      });

      test('endOfBusinessWeek defaults to Friday end of day', () {
        final date = Hora.of(year: 2024, month: 3, day: 13); // Wednesday
        final end = date.endOfBusinessWeek();
        expect(end.weekday, DateTime.friday);
        expect(end.day, 15);
        expect(end.hour, 23);
      });

      test('supports middle east weekend boundaries', () {
        final date = Hora.of(year: 2024, month: 3, day: 13); // Wednesday
        final start = date.startOfBusinessWeek(BusinessDayConfig.middleEast);
        final end = date.endOfBusinessWeek(BusinessDayConfig.middleEast);

        expect(start.weekday, DateTime.sunday);
        expect(start.day, 10);
        expect(end.weekday, DateTime.thursday);
        expect(end.day, 14);
      });

      test('startOfBusinessWeek throws when weekendDays is empty', () {
        final date = Hora.of(year: 2024, month: 3, day: 13);
        final config = BusinessDayConfig(weekendDays: const <int>{});
        expect(() => date.startOfBusinessWeek(config), throwsStateError);
      });

      test('endOfBusinessWeek throws when weekendDays is empty', () {
        final date = Hora.of(year: 2024, month: 3, day: 13);
        final config = BusinessDayConfig(weekendDays: const <int>{});
        expect(() => date.endOfBusinessWeek(config), throwsStateError);
      });
    });
  });

  group('BusinessDayConfig', () {
    test('standard config has Saturday and Sunday as weekend', () {
      final config = BusinessDayConfig.standard;
      expect(config.weekendDays.contains(DateTime.saturday), isTrue);
      expect(config.weekendDays.contains(DateTime.sunday), isTrue);
      expect(config.weekendDays.contains(DateTime.friday), isFalse);
    });

    test('middleEast config has Friday and Saturday as weekend', () {
      final config = BusinessDayConfig.middleEast;
      expect(config.weekendDays.contains(DateTime.friday), isTrue);
      expect(config.weekendDays.contains(DateTime.saturday), isTrue);
      expect(config.weekendDays.contains(DateTime.sunday), isFalse);
    });

    test('withWeekends creates new config', () {
      final config = BusinessDayConfig.standard.withWeekends({DateTime.sunday});
      expect(config.weekendDays.length, 1);
      expect(config.weekendDays.contains(DateTime.sunday), isTrue);
    });

    test('withHolidays creates new config preserving weekends', () {
      final holidays = HolidayCalendar(
        fixedHolidays: [DateTime(2024, 3, 15)],
      );
      final config = BusinessDayConfig.standard.withHolidays(holidays);
      expect(config.weekendDays, BusinessDayConfig.standard.weekendDays);
      expect(config.holidays.isHoliday(DateTime(2024, 3, 15)), isTrue);
    });
  });

  group('HolidayCalendar', () {
    test('isHoliday checks fixed holidays', () {
      final cal = HolidayCalendar(
        fixedHolidays: [DateTime(2024, 12, 25)],
      );
      expect(cal.isHoliday(DateTime(2024, 12, 25)), isTrue);
      expect(cal.isHoliday(DateTime(2024, 12, 26)), isFalse);
    });

    test('isHoliday checks annual holidays', () {
      final cal = HolidayCalendar(
        annualHolidays: [(12, 25)],
      );
      expect(cal.isHoliday(DateTime(2024, 12, 25)), isTrue);
      expect(cal.isHoliday(DateTime(2025, 12, 25)), isTrue);
    });

    test('usCommon preset', () {
      const cal = HolidayCalendar.usCommon;
      expect(cal.isHoliday(DateTime(2024, 7, 4)), isTrue);
      expect(cal.isHoliday(DateTime(2024, 12, 25)), isTrue);
    });

    test('cnCommon preset', () {
      const cal = HolidayCalendar.cnCommon;
      expect(cal.isHoliday(DateTime(2024, 10)), isTrue);
      expect(cal.isHoliday(DateTime(2024, 10, 3)), isTrue);
      expect(cal.isHoliday(DateTime(2024, 10, 4)), isFalse);
    });

    test('empty calendar contains no holidays', () {
      const cal = HolidayCalendar.empty();
      expect(cal.isHoliday(DateTime(2024)), isFalse);
      expect(cal.name, 'Custom');
    });

    test('merge combines calendars', () {
      final cal1 = HolidayCalendar(annualHolidays: [(1, 1)]);
      final cal2 = HolidayCalendar(annualHolidays: [(12, 25)]);
      final merged = cal1.merge(cal2);

      expect(merged.isHoliday(DateTime(2024)), isTrue);
      expect(merged.isHoliday(DateTime(2024, 12, 25)), isTrue);
    });

    test('isHoliday on invalid Hora returns false', () {
      final invalid = Hora.parse('invalid');
      expect(invalid.isHoliday(HolidayCalendar.usCommon), isFalse);
    });

    test('isHoliday returns false when calendar is null', () {
      final date = Hora.of(year: 2024, month: 3, day: 15);
      expect(date.isHoliday(), isFalse);
    });
  });
}
