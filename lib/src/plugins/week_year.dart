/// Week year plugin for Hora.
///
/// This plugin adds support for week-based year calculations, which is useful
/// for fiscal reporting and ISO week date systems.
///
/// The week year may differ from the calendar year at the beginning or end
/// of a year. For example, January 1, 2023 might belong to week 52 of 2022
/// if that week started in December 2022.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/week_year.dart';
///
/// final h = Hora.parse('2023-01-01');
/// print(h.weekYear);    // 2022 (if Jan 1 is in week 52 of previous year)
/// print(h.weeksInWeekYear); // 52 or 53
/// print(h.setWeekYear(2024)); // Set to same week in 2024
/// ```
library;

import '../hora.dart';

/// Configuration for week year calculations.
class WeekYearConfig {
  const WeekYearConfig({
    this.weekStart = DateTime.monday,
    this.yearStart = 4,
  });

  /// ISO week year configuration (week starts Monday, Jan 4 is always in week 1).
  static const iso = WeekYearConfig();

  /// US week year configuration (week starts Sunday).
  static const us = WeekYearConfig(weekStart: DateTime.sunday, yearStart: 1);

  /// The first day of the week (1=Monday, 7=Sunday).
  final int weekStart;

  /// The day in January that determines the first week of the year.
  /// For ISO 8601, this is 4 (the week containing Jan 4 is week 1).
  final int yearStart;
}

/// Extension on [Hora] for week year operations.
extension WeekYearExtension on Hora {
  /// Returns the week year based on the configured week start.
  ///
  /// The week year is the year that the current week belongs to.
  /// This may differ from the calendar year at year boundaries.
  int weekYear([WeekYearConfig config = WeekYearConfig.iso]) {
    final thursday = _getWeekThursday(config);
    return thursday.year;
  }

  /// Returns the week number within the week year.
  int weekOfWeekYear([WeekYearConfig config = WeekYearConfig.iso]) {
    final thursday = _getWeekThursday(config);
    final firstWeekThursday = _firstWeekThursday(thursday.year, config);
    return ((thursday.difference(firstWeekThursday).inDays) ~/ 7) + 1;
  }

  /// Returns the number of weeks in the week year.
  int weeksInWeekYear([WeekYearConfig config = WeekYearConfig.iso]) {
    final wy = weekYear(config);
    final lastDayOfYear = DateTime(wy, 12, 31);
    final horaLastDay = Hora.fromDateTime(lastDayOfYear, locale: locale);
    return horaLastDay.weekOfWeekYear(config);
  }

  /// Returns a new [Hora] set to the same week in a different week year.
  Hora setWeekYear(int year, [WeekYearConfig config = WeekYearConfig.iso]) {
    final currentWeek = weekOfWeekYear(config);
    final currentWeekday = _adjustedWeekday(config);

    // Find the first week of the target year
    final firstWeekThursday = _firstWeekThursday(year, config);
    final firstWeekStart = firstWeekThursday.subtract(
      Duration(days: (firstWeekThursday.weekday - config.weekStart + 7) % 7),
    );

    // Calculate the target date
    final targetDate = firstWeekStart.add(
      Duration(days: (currentWeek - 1) * 7 + currentWeekday),
    );

    return copyWith(
      year: targetDate.year,
      month: targetDate.month,
      day: targetDate.day,
    );
  }

  /// Returns the Thursday of the current week.
  /// Thursday is used because it always falls in the same year as the
  /// majority of the week's days for ISO weeks.
  DateTime _getWeekThursday(WeekYearConfig config) {
    // Adjust weekday relative to week start
    final adjustedWeekday = _adjustedWeekday(config);
    // Thursday is day 3 in a 0-indexed week
    const thursdayIndex = 3;
    final daysToThursday = thursdayIndex - adjustedWeekday;
    return dateTime.add(Duration(days: daysToThursday));
  }

  /// Returns the weekday adjusted for week start (0 = first day of week).
  int _adjustedWeekday(WeekYearConfig config) =>
      (weekday - config.weekStart + 7) % 7;

  /// Returns the Thursday of the first week of the given year.
  DateTime _firstWeekThursday(int year, WeekYearConfig config) {
    // Jan [yearStart] is always in week 1
    final jan = DateTime(year, 1, config.yearStart);
    // Find the Thursday of that week
    final janWeekday = (jan.weekday - config.weekStart + 7) % 7;
    const thursdayIndex = 3;
    return jan.add(Duration(days: thursdayIndex - janWeekday));
  }
}

/// Extension for getting week year using locale settings.
extension LocaleWeekYearExtension on Hora {
  /// Returns the week year using the locale's week configuration.
  int get localeWeekYear {
    final config = WeekYearConfig(
      weekStart: locale.weekStart,
      yearStart: locale.yearStart,
    );
    return weekYear(config);
  }

  /// Returns the week number using the locale's week configuration.
  int get localeWeek {
    final config = WeekYearConfig(
      weekStart: locale.weekStart,
      yearStart: locale.yearStart,
    );
    return weekOfWeekYear(config);
  }
}
