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

      test('respects holidays', () {
        final friday = Hora.of(year: 2024, month: 3, day: 15);
        final holidays = HolidayCalendar(
          fixedHolidays: [DateTime(2024, 3, 15)],
        );
        final config = BusinessDayConfig(holidays: holidays);
        expect(friday.isBusinessDay(config), isFalse);
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
    });

    group('previousBusinessDay', () {
      test('returns previous business day from weekend', () {
        final sunday = Hora.of(year: 2024, month: 3, day: 17);
        final prev = sunday.previousBusinessDay();

        expect(prev.weekday, DateTime.friday);
        expect(prev.day, 15);
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

    test('merge combines calendars', () {
      final cal1 = HolidayCalendar(annualHolidays: [(1, 1)]);
      final cal2 = HolidayCalendar(annualHolidays: [(12, 25)]);
      final merged = cal1.merge(cal2);

      expect(merged.isHoliday(DateTime(2024)), isTrue);
      expect(merged.isHoliday(DateTime(2024, 12, 25)), isTrue);
    });
  });
}
