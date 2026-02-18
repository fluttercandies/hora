import 'package:hora/hora.dart';
import 'package:hora/src/plugins/week.dart';
import 'package:test/test.dart';

class _InvalidFirstDayWeekConfig extends WeekConfig {
  const _InvalidFirstDayWeekConfig() : super();

  @override
  int get firstDayOfWeek => 0;
}

class _InvalidMinDaysWeekConfig extends WeekConfig {
  const _InvalidMinDaysWeekConfig() : super();

  @override
  int get minDaysInFirstWeek => 8;
}

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

    test('fromLocale uses locale weekStart and yearStart', () {
      final h = Hora.of(year: 2024);
      final config = WeekConfig.fromLocale(h.locale);
      expect(config.firstDayOfWeek, h.locale.weekStart);
      expect(config.minDaysInFirstWeek, h.locale.yearStart);
    });

    test('equality', () {
      expect(WeekConfig.iso, equals(WeekConfig.iso));
      expect(
        WeekConfig.iso,
        equals(WeekConfig.iso),
      );
      expect(WeekConfig.iso, isNot(equals(WeekConfig.us)));
    });

    test('hashCode is consistent with equality', () {
      expect(WeekConfig.iso.hashCode, equals(WeekConfig.iso.hashCode));
      expect(
        WeekConfig.iso.hashCode,
        equals(WeekConfig.iso.hashCode),
      );
    });

    test('toString is descriptive', () {
      expect(
        WeekConfig.iso.toString(),
        equals('WeekConfig(firstDay: 1, minDays: 4)'),
      );
    });

    test('methods reject invalid firstDayOfWeek at runtime', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(
        () => h.weekOfYear(config: const _InvalidFirstDayWeekConfig()),
        throwsArgumentError,
      );
    });

    test('methods reject invalid minDaysInFirstWeek at runtime', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(
        () => h.weekYear(config: const _InvalidMinDaysWeekConfig()),
        throwsArgumentError,
      );
    });
  });

  group('ISO week calculations', () {
    // Core Hora already provides isoWeek/isoWeekYear/isoWeeksInYear.
    // The extension's weekOfYear()/weekYear()/weeksInYear() with ISO config
    // must agree with them.

    test('weekOfYear(iso) matches core isoWeek', () {
      for (var year = 2020; year <= 2025; year++) {
        for (var month = 1; month <= 12; month++) {
          final h = Hora.of(year: year, month: month, day: 15);
          expect(
            h.weekOfYear(),
            equals(h.isoWeek),
            reason: '$year-$month-15',
          );
        }
      }
    });

    test('weekYear(iso) matches core isoWeekYear', () {
      for (var year = 2020; year <= 2025; year++) {
        for (var month = 1; month <= 12; month++) {
          final h = Hora.of(year: year, month: month, day: 15);
          expect(
            h.weekYear(),
            equals(h.isoWeekYear),
            reason: '$year-$month-15',
          );
        }
      }
    });

    test('weeksInYear(iso) matches core isoWeeksInYear', () {
      for (var year = 2020; year <= 2030; year++) {
        final h = Hora.of(year: year);
        expect(
          h.weeksInYear(),
          equals(h.isoWeeksInYear),
          reason: 'year $year',
        );
      }
    });

    group('known ISO week values', () {
      test('2024-01-01 (Monday) is ISO week 1 of 2024', () {
        final h = Hora.of(year: 2024);
        expect(h.weekOfYear(), 1);
        expect(h.weekYear(), 2024);
      });

      test('2023-01-01 (Sunday) is ISO week 52 of 2022', () {
        final h = Hora.of(year: 2023);
        expect(h.weekOfYear(), 52);
        expect(h.weekYear(), 2022);
      });

      test('2019-12-31 (Tuesday) is ISO week 1 of 2020', () {
        final h = Hora.of(year: 2019, month: 12, day: 31);
        expect(h.weekOfYear(), 1);
        expect(h.weekYear(), 2020);
      });

      test('2020-12-31 (Thursday) is ISO week 53 of 2020', () {
        final h = Hora.of(year: 2020, month: 12, day: 31);
        expect(h.weekOfYear(), 53);
        expect(h.weekYear(), 2020);
      });

      test('Jan 4 is always in ISO week 1', () {
        for (var year = 2000; year <= 2030; year++) {
          final h = Hora.of(year: year, day: 4);
          expect(h.weekOfYear(), 1, reason: 'year $year');
          expect(h.weekYear(), year, reason: 'year $year');
        }
      });

      test('Dec 28 is always in the last ISO week of its year', () {
        for (var year = 2000; year <= 2030; year++) {
          final h = Hora.of(year: year, month: 12, day: 28);
          expect(h.weekYear(), year, reason: 'year $year');
        }
      });

      test('2023-06-15 (Thursday) is ISO week 24', () {
        final h = Hora.of(year: 2023, month: 6, day: 15);
        expect(h.weekOfYear(), 24);
        expect(h.weekYear(), 2023);
      });

      test('ISO weeks in year: 2020 has 53, 2023 has 52', () {
        expect(Hora.of(year: 2020).weeksInYear(), 53);
        expect(Hora.of(year: 2023).weeksInYear(), 52);
      });
    });
  });

  group('US week calculations', () {
    const us = WeekConfig.us;

    test('Jan 1 is always in US week 1', () {
      for (var year = 2020; year <= 2025; year++) {
        final h = Hora.of(year: year);
        expect(h.weekOfYear(config: us), 1, reason: 'year $year');
        expect(h.weekYear(config: us), year, reason: 'year $year');
      }
    });

    test('2023-01-01 (Sunday) is US week 1 of 2023', () {
      final h = Hora.of(year: 2023);
      expect(h.weekOfYear(config: us), 1);
      expect(h.weekYear(config: us), 2023);
    });
  });

  group('locale-aware shortcuts', () {
    test('localeWeek uses locale settings', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      final config = WeekConfig.fromLocale(h.locale);
      expect(h.localeWeek, equals(h.weekOfYear(config: config)));
    });

    test('localeWeekYear uses locale settings', () {
      final h = Hora.of(year: 2023, month: 6, day: 15);
      final config = WeekConfig.fromLocale(h.locale);
      expect(h.localeWeekYear, equals(h.weekYear(config: config)));
    });
  });

  group('startOfWeek / endOfWeek', () {
    test('ISO startOfWeek is Monday', () {
      // 2024-03-15 is Friday
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final start = h.startOfWeek();
      expect(start.weekday, DateTime.monday);
      expect(start.year, 2024);
      expect(start.month, 3);
      expect(start.day, 11);
      expect(start.hour, 0);
      expect(start.minute, 0);
      expect(start.second, 0);
    });

    test('ISO endOfWeek is Sunday 23:59:59.999999', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final end = h.endOfWeek();
      expect(end.weekday, DateTime.sunday);
      expect(end.day, 17);
      expect(end.hour, 23);
      expect(end.minute, 59);
      expect(end.second, 59);
    });

    test('US startOfWeek is Sunday', () {
      // 2024-03-15 is Friday
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final start = h.startOfWeek(config: WeekConfig.us);
      expect(start.weekday, DateTime.sunday);
      expect(start.day, 10);
    });

    test('US endOfWeek is Saturday', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final end = h.endOfWeek(config: WeekConfig.us);
      expect(end.weekday, DateTime.saturday);
      expect(end.day, 16);
    });

    test('startOfWeek on Monday returns same date', () {
      final monday = Hora.of(year: 2024, month: 3, day: 11);
      expect(monday.weekday, DateTime.monday);
      final start = monday.startOfWeek();
      expect(start.day, 11);
    });

    test('startOfWeek on Sunday (ISO) goes to previous Monday', () {
      final sunday = Hora.of(year: 2024, month: 3, day: 17);
      expect(sunday.weekday, DateTime.sunday);
      final start = sunday.startOfWeek();
      expect(start.weekday, DateTime.monday);
      expect(start.day, 11);
    });

    test('startOfWeek on Sunday (US) returns same date', () {
      final sunday = Hora.of(year: 2024, month: 3, day: 10);
      expect(sunday.weekday, DateTime.sunday);
      final start = sunday.startOfWeek(config: WeekConfig.us);
      expect(start.day, 10);
    });

    test('ISO convenience: startOfIsoWeek / endOfIsoWeek', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      expect(h.startOfIsoWeek, equals(h.startOfWeek()));
      expect(h.endOfIsoWeek, equals(h.endOfWeek()));
    });
  });

  group('daysOfWeekWith', () {
    test('ISO returns 7 days Monday..Sunday', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final days = h.daysOfIsoWeek;
      expect(days.length, 7);
      expect(days.first.weekday, DateTime.monday);
      expect(days.last.weekday, DateTime.sunday);
      for (var i = 0; i < 6; i++) {
        expect(
          days[i + 1].diff(days[i], TemporalUnit.day),
          equals(1),
        );
      }
    });

    test('US returns 7 days Sunday..Saturday', () {
      final h = Hora.of(year: 2024, month: 3, day: 15);
      final days = h.daysOfWeekWith(config: WeekConfig.us);
      expect(days.length, 7);
      expect(days.first.weekday, DateTime.sunday);
      expect(days.last.weekday, DateTime.saturday);
    });

    test('daysOfIsoWeek is equivalent to daysOfWeekWith(iso)', () {
      final h = Hora.of(year: 2024, month: 6, day: 20);
      final isoD = h.daysOfIsoWeek;
      final cfgD = h.daysOfWeekWith();
      for (var i = 0; i < 7; i++) {
        expect(isoD[i], equals(cfgD[i]));
      }
    });
  });

  group('setWeekOfYear', () {
    test('sets to target week', () {
      final h = Hora.of(year: 2024, day: 15);
      final newH = h.setWeekOfYear(10);
      expect(newH.weekOfYear(), 10);
    });

    test('setting to week 1 goes to first week', () {
      final h = Hora.of(year: 2024, month: 6, day: 15);
      final newH = h.setWeekOfYear(1);
      expect(newH.weekOfYear(), 1);
    });

    test('setting to last week stays valid', () {
      final h = Hora.of(year: 2020, month: 6, day: 15);
      final newH = h.setWeekOfYear(53);
      expect(newH.weekOfYear(), 53);
    });
  });

  group('setWeekYear', () {
    test('moves to same week in different year', () {
      final h = Hora.of(year: 2023, month: 6, day: 15); // Week 24
      final h2024 = h.setWeekYear(2024);
      expect(h2024.weekYear(), 2024);
      expect(h2024.weekOfYear(), 24);
    });

    test('preserves weekday', () {
      final h = Hora.of(year: 2023, month: 6, day: 15); // Thursday
      final h2024 = h.setWeekYear(2024);
      expect(h2024.weekday, equals(h.weekday));
    });
  });

  group('isSameIsoWeek', () {
    test('same week returns true', () {
      final mon = Hora.of(year: 2024, month: 3, day: 11);
      final fri = Hora.of(year: 2024, month: 3, day: 15);
      expect(mon.isSameIsoWeek(fri), isTrue);
    });

    test('different week returns false', () {
      final fri = Hora.of(year: 2024, month: 3, day: 15);
      final nextMon = Hora.of(year: 2024, month: 3, day: 18);
      expect(fri.isSameIsoWeek(nextMon), isFalse);
    });

    test('cross-year same ISO week returns true', () {
      // 2019-12-30 (Mon) and 2019-12-31 (Tue) are both ISO week 1 of 2020
      final mon = Hora.of(year: 2019, month: 12, day: 30);
      final tue = Hora.of(year: 2019, month: 12, day: 31);
      expect(mon.isSameIsoWeek(tue), isTrue);
    });
  });

  group('isSameWeek', () {
    test('with US config', () {
      // 2024-03-10 is Sunday (US week start)
      final sun = Hora.of(year: 2024, month: 3, day: 10);
      final sat = Hora.of(year: 2024, month: 3, day: 16);
      expect(sun.isSameWeek(sat, config: WeekConfig.us), isTrue);

      final nextSun = Hora.of(year: 2024, month: 3, day: 17);
      expect(sun.isSameWeek(nextSun, config: WeekConfig.us), isFalse);
    });
  });

  group('isoDayOfWeek', () {
    test('Monday = 1, Sunday = 7', () {
      expect(Hora.of(year: 2024, month: 3, day: 11).isoDayOfWeek, 1);
      expect(Hora.of(year: 2024, month: 3, day: 12).isoDayOfWeek, 2);
      expect(Hora.of(year: 2024, month: 3, day: 17).isoDayOfWeek, 7);
    });
  });

  group('weekOfMonth', () {
    test('first 7 days are week 1', () {
      for (var d = 1; d <= 7; d++) {
        expect(Hora.of(year: 2024, month: 3, day: d).weekOfMonth, 1);
      }
    });

    test('days 8-14 are week 2', () {
      expect(Hora.of(year: 2024, month: 3, day: 8).weekOfMonth, 2);
      expect(Hora.of(year: 2024, month: 3, day: 14).weekOfMonth, 2);
    });

    test('days 22-28 are week 4', () {
      expect(Hora.of(year: 2024, month: 3, day: 22).weekOfMonth, 4);
      expect(Hora.of(year: 2024, month: 3, day: 28).weekOfMonth, 4);
    });

    test('day 29+ is week 5', () {
      expect(Hora.of(year: 2024, month: 3, day: 29).weekOfMonth, 5);
    });
  });

  group('weekSpansMonths', () {
    test('week spanning month boundary returns true', () {
      // 2024-03-31 Sunday — ISO week is Mon Mar 25 to Sun Mar 31: no span
      // 2024-04-01 Monday — ISO week is Mon Apr 1 to Sun Apr 7: no span
      // 2024-03-29 Friday — ISO week Mon Mar 25 to Sun Mar 31: no span
      // 2024-02-29 Thursday — ISO week Mon Feb 26 to Sun Mar 3: spans!
      final h = Hora.of(year: 2024, month: 2, day: 29);
      expect(h.weekSpansMonths(), isTrue);
    });

    test('mid-month week does not span', () {
      final h = Hora.of(year: 2024, month: 3, day: 13); // Wednesday
      expect(h.weekSpansMonths(), isFalse);
    });
  });

  group('weekSpansYears', () {
    test('last week of year spanning into next year returns true', () {
      // 2024-12-30 Monday — ISO week Mon Dec 30 to Sun Jan 5: spans years!
      final h = Hora.of(year: 2024, month: 12, day: 30);
      expect(h.weekSpansYears(), isTrue);
    });

    test('mid-year week does not span years', () {
      final h = Hora.of(year: 2024, month: 6, day: 15);
      expect(h.weekSpansYears(), isFalse);
    });
  });

  group('weeksInThisYear', () {
    test('generates correct number of ISO weeks', () {
      final h = Hora.of(year: 2024);
      final weeks = h.weeksInThisYear.toList();
      expect(weeks.length, h.isoWeeksInYear);
      for (final w in weeks) {
        expect(w.isoWeekYear, 2024);
        expect(w.weekday, DateTime.monday);
      }
    });

    test('preserves UTC mode from source date', () {
      final h = Hora.of(year: 2024, utc: true);
      final weeks = h.weeksInThisYear.toList();
      expect(weeks, isNotEmpty);
      expect(weeks.every((w) => w.isUtc), isTrue);
    });

    test('2020 has 53 weeks', () {
      final weeks = Hora.of(year: 2020).weeksInThisYear.toList();
      expect(weeks.length, 53);
    });

    test('2023 has 52 weeks', () {
      final weeks = Hora.of(year: 2023).weeksInThisYear.toList();
      expect(weeks.length, 52);
    });

    test('throws for invalid Hora', () {
      final invalid = Hora.parse('invalid');
      expect(() => invalid.weeksInThisYear.toList(), throwsStateError);
    });
  });

  group('weeksUntil', () {
    test('generates week starts in range', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 3, day: 31);
      final weeks = start.weeksUntil(end).toList();

      expect(weeks.length, greaterThan(0));
      for (final w in weeks) {
        expect(w.weekday, DateTime.monday);
      }
    });

    test('US config generates Sunday starts', () {
      final start = Hora.of(year: 2024, month: 3);
      final end = Hora.of(year: 2024, month: 3, day: 31);
      final weeks = start.weeksUntil(end, config: WeekConfig.us).toList();

      for (final w in weeks) {
        expect(w.weekday, DateTime.sunday);
      }
    });

    test('same week returns single element', () {
      final h = Hora.of(year: 2024, month: 3, day: 12); // Tuesday
      final weeks = h.weeksUntil(h).toList();
      expect(weeks.length, 1);
    });

    test('throws for invalid start or end to avoid infinite loop', () {
      final valid = Hora.of(year: 2024, month: 3, day: 12);
      final invalid = Hora.parse('invalid');

      expect(() => invalid.weeksUntil(valid).toList(), throwsArgumentError);
      expect(() => valid.weeksUntil(invalid).toList(), throwsArgumentError);
    });
  });

  group('edge cases', () {
    test('week number is always 1..53', () {
      for (var year = 2000; year <= 2025; year++) {
        for (var doy = 1; doy <= 365; doy += 30) {
          final dt = DateTime(year).add(Duration(days: doy - 1));
          final h = Hora.of(
            year: dt.year,
            month: dt.month,
            day: dt.day,
          );
          final w = h.weekOfYear();
          expect(w, greaterThanOrEqualTo(1));
          expect(w, lessThanOrEqualTo(53));
        }
      }
    });

    test('week year is within ±1 of calendar year', () {
      for (var year = 2020; year <= 2025; year++) {
        final jan1 = Hora.of(year: year);
        final dec31 = Hora.of(year: year, month: 12, day: 31);
        expect((jan1.weekYear() - year).abs(), lessThanOrEqualTo(1));
        expect((dec31.weekYear() - year).abs(), lessThanOrEqualTo(1));
      }
    });

    test('custom Saturday-start config works', () {
      const satConfig = WeekConfig(
        firstDayOfWeek: DateTime.saturday,
        minDaysInFirstWeek: 1,
      );
      final h = Hora.of(year: 2024, month: 3, day: 15); // Friday
      final w = h.weekOfYear(config: satConfig);
      expect(w, greaterThanOrEqualTo(1));
      expect(w, lessThanOrEqualTo(53));

      final start = h.startOfWeek(config: satConfig);
      expect(start.weekday, DateTime.saturday);
    });

    test('start/end/days invariants hold across sampled dates and configs', () {
      const configs = [
        WeekConfig.iso,
        WeekConfig.us,
        WeekConfig(firstDayOfWeek: DateTime.saturday, minDaysInFirstWeek: 1),
      ];

      for (var year = 2023; year <= 2025; year++) {
        for (var month = 1; month <= 12; month++) {
          final maxDay = Hora.of(year: year, month: month).daysInMonth;
          for (final day in [1, 7, 14, 21, 28]) {
            if (day > maxDay) continue;
            final h = Hora.of(year: year, month: month, day: day);

            for (final config in configs) {
              final start = h.startOfWeek(config: config);
              final end = h.endOfWeek(config: config);
              final days = h.daysOfWeekWith(config: config);

              expect(days.length, 7);
              expect(days.first, start);
              expect(
                days.last.startOf(TemporalUnit.day),
                end.startOf(TemporalUnit.day),
              );
              expect(h.isSameOrAfter(start), isTrue);
              expect(h.isSameOrBefore(end), isTrue);

              for (var i = 0; i < days.length; i++) {
                expect(
                  days[i],
                  start.add(i, TemporalUnit.day),
                  reason: 'config=$config date=$year-$month-$day index=$i',
                );
              }
            }
          }
        }
      }
    });
  });
}
