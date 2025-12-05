import 'package:hora/hora.dart';
import 'package:hora/src/plugins/week_year.dart';
import 'package:test/test.dart';

void main() {
  group('WeekYear', () {
    group('ISO week year', () {
      test('returns correct week year for dates in first week', () {
        // Jan 1, 2023 is Sunday, belongs to week 52 of 2022
        final h1 = Hora.of(year: 2023);
        expect(h1.weekYear(), equals(2022));

        // Jan 2, 2023 is Monday, belongs to week 1 of 2023
        final h2 = Hora.of(year: 2023, day: 2);
        expect(h2.weekYear(), equals(2023));
      });

      test('returns correct week year for dates in last week', () {
        // Dec 31, 2020 belongs to week 53 of 2020
        final h1 = Hora.of(year: 2020, month: 12, day: 31);
        expect(h1.weekYear(), equals(2020));

        // Dec 31, 2019 belongs to week 1 of 2020
        final h2 = Hora.of(year: 2019, month: 12, day: 31);
        expect(h2.weekYear(), equals(2020));
      });

      test('returns calendar year for mid-year dates', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.weekYear(), equals(2023));
      });
    });

    group('US week year', () {
      test('uses Sunday as week start', () {
        // Jan 1, 2023 is Sunday
        final h = Hora.of(year: 2023);
        expect(h.weekYear(WeekYearConfig.us), equals(2023));
      });
    });

    group('weekOfWeekYear', () {
      test('returns week 1 for first ISO week', () {
        // Jan 4 is always in week 1 for ISO
        final h = Hora.of(year: 2023, day: 4);
        expect(h.weekOfWeekYear(), equals(1));
      });

      test('returns week 52 or 53 for last week', () {
        final h = Hora.of(year: 2023, month: 12, day: 28);
        expect(h.weekOfWeekYear(), greaterThanOrEqualTo(52));
      });

      test('returns correct week for mid-year', () {
        // June 15, 2023 is Thursday
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.weekOfWeekYear(), equals(24));
      });
    });

    group('weeksInWeekYear', () {
      test('returns 52 for most years', () {
        final h2023 = Hora.of(year: 2023, month: 6, day: 15);
        expect(h2023.weeksInWeekYear(), equals(52));
      });

      test('returns 53 for long years', () {
        // 2020 has 53 ISO weeks
        final h2020 = Hora.of(year: 2020, month: 6, day: 15);
        expect(h2020.weeksInWeekYear(), equals(53));
      });
    });

    group('setWeekYear', () {
      test('moves to same week in different year', () {
        final h = Hora.of(year: 2023, month: 6, day: 15); // Week 24
        final h2024 = h.setWeekYear(2024);
        expect(h2024.weekYear(), equals(2024));
        expect(h2024.weekOfWeekYear(), equals(24));
      });

      test('preserves weekday', () {
        final h = Hora.of(year: 2023, month: 6, day: 15); // Thursday
        final h2024 = h.setWeekYear(2024);
        expect(h2024.weekday, equals(h.weekday));
      });
    });

    group('WeekYearConfig', () {
      test('iso config has correct values', () {
        expect(WeekYearConfig.iso.weekStart, equals(DateTime.monday));
        expect(WeekYearConfig.iso.yearStart, equals(4));
      });

      test('us config has correct values', () {
        expect(WeekYearConfig.us.weekStart, equals(DateTime.sunday));
        expect(WeekYearConfig.us.yearStart, equals(1));
      });

      test('custom config works', () {
        final custom = WeekYearConfig(
          weekStart: DateTime.saturday,
          yearStart: 1,
        );
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.weekYear(custom), isA<int>());
      });
    });

    group('Locale week year', () {
      test('localeWeekYear uses locale settings', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.localeWeekYear, isA<int>());
      });

      test('localeWeek uses locale settings', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.localeWeek, isA<int>());
      });
    });

    group('Edge cases', () {
      test('handles year transition correctly', () {
        // Test multiple years with different configurations
        for (var year = 2020; year <= 2025; year++) {
          final jan1 = Hora.of(year: year);
          final dec31 = Hora.of(year: year, month: 12, day: 31);

          // Week year should be within 1 year of calendar year
          expect((jan1.weekYear() - year).abs(), lessThanOrEqualTo(1));
          expect((dec31.weekYear() - year).abs(), lessThanOrEqualTo(1));
        }
      });

      test('week number is always between 1 and 53', () {
        for (var month = 1; month <= 12; month++) {
          final h = Hora.of(year: 2023, month: month, day: 15);
          final week = h.weekOfWeekYear();
          expect(week, greaterThanOrEqualTo(1));
          expect(week, lessThanOrEqualTo(53));
        }
      });
    });
  });
}
